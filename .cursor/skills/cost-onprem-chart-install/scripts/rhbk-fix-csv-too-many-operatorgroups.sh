#!/usr/bin/env bash
#
# Workaround: RHBK CSV Failed (TooManyOperatorGroups)
#
# OLM fails the rhbk-operator ClusterServiceVersion when more than one OperatorGroup
# exists in the same namespace (e.g. console keycloak-og + deploy-rhbk.sh rhbk-operator-group).
# The operator Deployment and Keycloak CR may still be Running.
#
# Usage:
#   ./rhbk-fix-csv-too-many-operatorgroups.sh verify   # exit 0 if OK, 1 if fix needed or error
#   ./rhbk-fix-csv-too-many-operatorgroups.sh fix      # apply (idempotent)
#   ./rhbk-fix-csv-too-many-operatorgroups.sh fix --dry-run
#
# Prerequisites: oc (logged in)
#
# Environment:
#   RHBK_NAMESPACE=keycloak
#   RHBK_OG_TO_DELETE=rhbk-operator-group   # duplicate OG created by deploy-rhbk.sh (default)
#   RHBK_CSV_WAIT_SECONDS=120               # max wait for CSV Succeeded after fix

set -euo pipefail

RHBK_NAMESPACE="${RHBK_NAMESPACE:-keycloak}"
RHBK_OG_TO_DELETE="${RHBK_OG_TO_DELETE:-rhbk-operator-group}"
RHBK_CSV_WAIT_SECONDS="${RHBK_CSV_WAIT_SECONDS:-120}"

CMD="${1:-}"
DRY_RUN=0
if [[ "${2:-}" == "--dry-run" ]]; then
  DRY_RUN=1
fi

usage() {
  sed -n '1,22p' "$0" | tail -n +2
  echo "Commands: fix | verify | help"
  exit "${1:-0}"
}

[[ "$CMD" == "help" || "$CMD" == "-h" || "$CMD" == "--help" ]] && usage 0
[[ -z "$CMD" ]] && usage 1

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: required command not found: $1" >&2
    exit 1
  }
}

need_cmd oc

if ! oc whoami >/dev/null 2>&1; then
  echo "ERROR: not logged in; run oc login" >&2
  exit 1
fi

og_count() {
  oc get operatorgroup -n "$RHBK_NAMESPACE" --no-headers 2>/dev/null | wc -l | tr -d ' '
}

list_ogs() {
  oc get operatorgroup -n "$RHBK_NAMESPACE" -o custom-columns=NAME:.metadata.name --no-headers 2>/dev/null || true
}

rhbk_csv_name() {
  oc get csv -n "$RHBK_NAMESPACE" --no-headers 2>/dev/null \
    | awk '/^rhbk-operator\./ {print $1; exit}'
}

csv_phase() {
  local name="$1"
  oc get csv "$name" -n "$RHBK_NAMESPACE" -o jsonpath='{.status.phase}' 2>/dev/null || echo ""
}

csv_reason() {
  local name="$1"
  oc get csv "$name" -n "$RHBK_NAMESPACE" -o jsonpath='{.status.reason}' 2>/dev/null || echo ""
}

check_state() {
  local ogs n csv phase reason issues=0

  n="$(og_count)"
  ogs="$(list_ogs | tr '\n' ' ' | sed 's/ $//')"

  if [[ "$n" -gt 1 ]]; then
    echo "NEEDS_FIX: $n OperatorGroups in $RHBK_NAMESPACE ($ogs)"
    issues=1
  elif [[ "$n" -eq 0 ]]; then
    echo "WARN: no OperatorGroup in $RHBK_NAMESPACE (RHBK may not be installed via OLM here)"
  else
    echo "OK: single OperatorGroup in $RHBK_NAMESPACE ($ogs)"
  fi

  csv="$(rhbk_csv_name)"
  if [[ -z "$csv" ]]; then
    echo "WARN: no rhbk-operator CSV in $RHBK_NAMESPACE"
    return "$issues"
  fi

  phase="$(csv_phase "$csv")"
  reason="$(csv_reason "$csv")"

  if [[ "$phase" == "Succeeded" ]]; then
    echo "OK: CSV $csv phase=Succeeded"
    return "$issues"
  fi

  if [[ "$reason" == "TooManyOperatorGroups" ]]; then
    echo "NEEDS_FIX: CSV $csv phase=$phase reason=TooManyOperatorGroups"
    issues=1
  elif [[ "$phase" == "Failed" ]]; then
    echo "NEEDS_FIX: CSV $csv phase=Failed reason=${reason:-unknown}"
    issues=1
  else
    echo "WARN: CSV $csv phase=${phase:-unknown} reason=${reason:-none}"
  fi

  return "$issues"
}

wait_csv_succeeded() {
  local csv="$1" elapsed=0 interval=5 phase

  while [[ "$elapsed" -lt "$RHBK_CSV_WAIT_SECONDS" ]]; do
    phase="$(csv_phase "$csv")"
    if [[ "$phase" == "Succeeded" ]]; then
      echo "OK: CSV $csv reached Succeeded (${elapsed}s)"
      return 0
    fi
    sleep "$interval"
    elapsed=$((elapsed + interval))
  done
  echo "ERROR: CSV $csv did not reach Succeeded within ${RHBK_CSV_WAIT_SECONDS}s (phase=$(csv_phase "$csv"))" >&2
  return 1
}

nudge_csv_reconcile() {
  local csv="$1"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] Would annotate csv/$csv operators.coreos.com/force=true"
    return 0
  fi
  oc annotate csv "$csv" -n "$RHBK_NAMESPACE" operators.coreos.com/force=true --overwrite >/dev/null
  echo "Applied: annotated csv/$csv operators.coreos.com/force=true"
}

case "$CMD" in
  verify)
    if check_state; then
      exit 0
    fi
    exit 1
    ;;
  fix)
    if check_state && [[ "$(og_count)" -le 1 ]]; then
      csv="$(rhbk_csv_name)"
      if [[ -n "$csv" && "$(csv_phase "$csv")" == "Succeeded" ]]; then
        echo "Verify: OK (no duplicate OperatorGroup; CSV Succeeded)"
        exit 0
      fi
    fi

    n="$(og_count)"
    if [[ "$n" -gt 1 ]]; then
      if oc get operatorgroup "$RHBK_OG_TO_DELETE" -n "$RHBK_NAMESPACE" >/dev/null 2>&1; then
        if [[ "$DRY_RUN" -eq 1 ]]; then
          echo "[dry-run] Would delete operatorgroup/$RHBK_OG_TO_DELETE -n $RHBK_NAMESPACE"
        else
          oc delete operatorgroup "$RHBK_OG_TO_DELETE" -n "$RHBK_NAMESPACE"
          echo "Applied: deleted operatorgroup/$RHBK_OG_TO_DELETE"
        fi
      else
        echo "ERROR: $n OperatorGroups present but '$RHBK_OG_TO_DELETE' not found." >&2
        echo "Set RHBK_OG_TO_DELETE to the duplicate name. Current:" >&2
        list_ogs | sed 's/^/  /' >&2
        exit 1
      fi
    fi

    if [[ "$DRY_RUN" -ne 1 ]]; then
      n="$(og_count)"
      if [[ "$n" -gt 1 ]]; then
        echo "ERROR: still $n OperatorGroups after delete" >&2
        list_ogs | sed 's/^/  /' >&2
        exit 1
      fi

      csv="$(rhbk_csv_name)"
      if [[ -n "$csv" ]]; then
        reason="$(csv_reason "$csv")"
        if [[ "$(csv_phase "$csv")" != "Succeeded" && "$reason" == "TooManyOperatorGroups" ]]; then
          nudge_csv_reconcile "$csv"
        fi
        wait_csv_succeeded "$csv" || true
      fi
    fi

    SELF="${BASH_SOURCE[0]:-$0}"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[dry-run] Would re-run verify"
      exit 0
    fi
    if ! bash "$SELF" verify; then
      echo "WARNING: post-fix verify did not pass; re-run with: bash $SELF verify" >&2
      exit 1
    fi
    echo "Verify: OK (OperatorGroup + CSV)"
    ;;
  *)
    usage 1
    ;;
esac
