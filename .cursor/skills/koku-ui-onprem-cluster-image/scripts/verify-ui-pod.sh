#!/usr/bin/env bash
#
# Verify koku-ui-onprem RBAC static assets in the running UI pod.
#
# Usage:
#   verify-ui-pod.sh
#
# Environment:
#   NAMESPACE  (default: cost-onprem)
#   UI_DEPLOY  Deployment name override (default: cost-onprem-ui)

set -euo pipefail

NAMESPACE="${NAMESPACE:-cost-onprem}"
UI_DEPLOY="${UI_DEPLOY:-cost-onprem-ui}"
MANIFEST_PATH="/rbac/plugin-manifest.json"
APP_CONTAINER="${APP_CONTAINER:-app}"

if ! command -v oc >/dev/null 2>&1; then
  echo "error: oc not found" >&2
  exit 1
fi

if ! oc whoami >/dev/null 2>&1; then
  echo "error: oc not logged in" >&2
  exit 1
fi

if ! oc get deployment "$UI_DEPLOY" -n "$NAMESPACE" >/dev/null 2>&1; then
  echo "error: deployment/${UI_DEPLOY} not found in namespace ${NAMESPACE}" >&2
  exit 1
fi

echo "Checking ${MANIFEST_PATH} in ${UI_DEPLOY} (container ${APP_CONTAINER}, ns ${NAMESPACE})..."

CODE="$(oc exec -n "$NAMESPACE" "deployment/${UI_DEPLOY}" -c "$APP_CONTAINER" -- \
  curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:8080${MANIFEST_PATH}" 2>/dev/null || echo "000")"

echo "HTTP ${CODE}"

if [[ "$CODE" == "200" ]]; then
  echo "OK — RBAC plugin manifest reachable in pod"
  exit 0
fi

echo "FAIL — expected 200 (ImagePullBackOff? wrong tag? rollout still rolling?)" >&2
oc get pods -n "$NAMESPACE" -l "app.kubernetes.io/component=ui" 2>/dev/null || true
exit 1
