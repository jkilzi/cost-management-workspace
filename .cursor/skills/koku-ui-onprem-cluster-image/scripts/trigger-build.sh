#!/usr/bin/env bash
#
# Dispatch GHA build for koku-ui-onprem (amd64 on ubuntu-latest → Quay).
#
# Usage:
#   trigger-build.sh <image_tag> [ref]
#
#   image_tag  Required tag pushed to quay.io/jkilzi/koku-ui-onprem
#   ref        Optional workspace ref (branch or SHA on origin); default main
#
# Prerequisites: gh CLI authenticated; workflow file on origin; gitlink pushed.

set -euo pipefail

WORKFLOW_FILE="build-koku-ui-onprem.yml"
QUAY_IMAGE="quay.io/jkilzi/koku-ui-onprem"

IMAGE_TAG="${1:-}"
REF="${2:-main}"

if [[ -z "$IMAGE_TAG" ]]; then
  echo "Usage: $(basename "$0") <image_tag> [ref]" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh CLI not found" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/../../../../" && pwd)"
cd "$ROOT"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "error: not inside workspace git repo" >&2
  exit 1
fi

echo "Dispatching ${WORKFLOW_FILE}"
echo "  image_tag: ${IMAGE_TAG}"
echo "  ref:       ${REF}"
echo "  target:    ${QUAY_IMAGE}:${IMAGE_TAG}"
echo ""

gh workflow run "$WORKFLOW_FILE" \
  -f "image_tag=${IMAGE_TAG}" \
  -f "ref=${REF}"

echo "Waiting for workflow run to appear..."
sleep 3

RUN_ID=""
for _ in $(seq 1 30); do
  RUN_ID="$(gh run list --workflow="$WORKFLOW_FILE" --limit 1 --json databaseId,status --jq '.[0].databaseId' 2>/dev/null || true)"
  if [[ -n "$RUN_ID" && "$RUN_ID" != "null" ]]; then
    break
  fi
  sleep 2
done

if [[ -z "$RUN_ID" || "$RUN_ID" == "null" ]]; then
  echo "Workflow dispatched. Check: gh run list --workflow=${WORKFLOW_FILE}" >&2
  exit 0
fi

echo "Run: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions/runs/${RUN_ID}"
echo ""
echo "Watching run (Ctrl+C to detach; build continues on GitHub)..."
if gh run watch "$RUN_ID"; then
  echo ""
  echo "Done. Image (if push succeeded): ${QUAY_IMAGE}:${IMAGE_TAG}"
else
  echo "Run finished with failure. Logs: gh run view ${RUN_ID} --log-failed" >&2
  exit 1
fi
