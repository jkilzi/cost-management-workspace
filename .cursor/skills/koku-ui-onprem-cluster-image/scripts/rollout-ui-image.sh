#!/usr/bin/env bash
#
# Roll out an existing koku-ui-onprem image tag to the cluster via Helm.
# Does NOT trigger a build — image must already exist on Quay.
#
# Usage:
#   rollout-ui-image.sh
#
# Environment:
#   VALUES_FILE     Override path to ui values (default: skill references/ui-image-values.local.yaml)
#   NAMESPACE       Helm namespace (default: cost-onprem)
#   HELM_RELEASE_NAME  (default: cost-onprem)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../../../" && pwd)"
SKILL_REF="${ROOT}/.cursor/skills/koku-ui-onprem-cluster-image/references"
VALUES_FILE="${VALUES_FILE:-${SKILL_REF}/ui-image-values.local.yaml}"
CHART_DIR="${ROOT}/submodules/cost-onprem-chart"
NAMESPACE="${NAMESPACE:-cost-onprem}"
export NAMESPACE
export HELM_RELEASE_NAME="${HELM_RELEASE_NAME:-cost-onprem}"

if [[ ! -f "$VALUES_FILE" ]]; then
  echo "error: VALUES_FILE not found: ${VALUES_FILE}" >&2
  echo "Copy ${SKILL_REF}/ui-image-values.example.yaml to ui-image-values.local.yaml and set ui.app.image.tag" >&2
  exit 1
fi

if [[ ! -x "${CHART_DIR}/scripts/install-helm-chart.sh" ]]; then
  echo "error: chart script missing: ${CHART_DIR}/scripts/install-helm-chart.sh" >&2
  exit 1
fi

if ! command -v oc >/dev/null 2>&1; then
  echo "error: oc not found — log in to the cluster first" >&2
  exit 1
fi

if ! oc whoami >/dev/null 2>&1; then
  echo "error: oc not logged in" >&2
  exit 1
fi

TAG="$(grep -E '^[[:space:]]*tag:' "$VALUES_FILE" | head -1 | sed -E 's/.*tag:[[:space:]]*"?([^"]+)"?.*/\1/' || true)"
REPO="$(grep -E '^[[:space:]]*repository:' "$VALUES_FILE" | head -1 | sed -E 's/.*repository:[[:space:]]*"?([^"]+)"?.*/\1/' || true)"

echo "Helm upgrade (UI image rollout)"
echo "  VALUES_FILE: ${VALUES_FILE}"
echo "  NAMESPACE:   ${NAMESPACE}"
if [[ -n "$REPO" && -n "$TAG" ]]; then
  echo "  UI image:    ${REPO}:${TAG}"
fi
echo ""

export VALUES_FILE
cd "$CHART_DIR"
./scripts/install-helm-chart.sh

echo ""
echo "Rollout complete. Verify: bash ${ROOT}/.cursor/skills/koku-ui-onprem-cluster-image/scripts/verify-ui-pod.sh"
