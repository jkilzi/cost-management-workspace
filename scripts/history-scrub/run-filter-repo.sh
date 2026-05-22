#!/usr/bin/env bash
# Rewrite git history: drop RPI pipeline trees and redact workspace-specific strings.
# Run from repository root. Requires: git-filter-repo (brew install git-filter-repo).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

if ! command -v git-filter-repo >/dev/null 2>&1; then
  echo "ERROR: git-filter-repo not found (brew install git-filter-repo)" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: working tree must be clean before history rewrite" >&2
  exit 1
fi

ORIGIN_URL=""
if git remote get-url origin >/dev/null 2>&1; then
  ORIGIN_URL="$(git remote get-url origin)"
  echo "NOTE: origin will be removed by filter-repo; re-add after: git remote add origin ${ORIGIN_URL}"
fi

REPLACEMENTS="${ROOT}/scripts/history-scrub/replacements.txt"
if [[ ! -f "$REPLACEMENTS" ]]; then
  echo "ERROR: missing ${REPLACEMENTS}" >&2
  exit 1
fi

echo "Rewriting history (pipelines/rpi, scripts/rpi removed; text replacements applied)..."
git filter-repo \
  --force \
  --invert-paths \
  --path pipelines/rpi \
  --path scripts/rpi \
  --replace-text "$REPLACEMENTS"

if [[ -n "$ORIGIN_URL" ]]; then
  git remote add origin "$ORIGIN_URL"
  echo "Re-added origin → ${ORIGIN_URL}"
fi

echo "Done. Verify:"
echo "  gitleaks detect --log-opts=--all"
echo "  ./scripts/history-scrub/verify-history-clean.sh"
echo "Public push: see wiki/workspace/public-push.md"
