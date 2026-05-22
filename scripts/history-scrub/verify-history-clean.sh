#!/usr/bin/env bash
# Fail if pre-scrub identifiers appear in git history outside scripts/history-scrub/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

EXCLUDE='scripts/history-scrub'
FORBIDDEN=(
  'quay.io/jkilzi'
  'quay-jkilzi'
  'cluster-f4rmt'
  'cluster-tkd2v'
  'user-jkilzi-redhat-com'
)

fail=0
for needle in "${FORBIDDEN[@]}"; do
  if hits="$(git log --all -S "$needle" --oneline -- . ":(exclude)${EXCLUDE}" 2>/dev/null)" && [[ -n "$hits" ]]; then
    echo "FAIL: found \"${needle}\" in history outside ${EXCLUDE}:" >&2
    echo "$hits" >&2
    fail=1
  fi
done

if [[ -n "$(git log --all --oneline -- pipelines/rpi 2>/dev/null)" ]]; then
  echo "FAIL: pipelines/rpi still in history" >&2
  fail=1
fi

if [[ $fail -ne 0 ]]; then
  exit 1
fi

echo "OK: history clean (outside ${EXCLUDE})"
