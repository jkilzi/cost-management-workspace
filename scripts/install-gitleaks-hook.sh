#!/usr/bin/env bash
# Install a pre-commit hook that runs gitleaks on staged changes.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOOK="${ROOT}/.git/hooks/pre-commit"

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "ERROR: gitleaks not found (brew install gitleaks)" >&2
  exit 1
fi

cat > "$HOOK" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
if ! command -v gitleaks >/dev/null 2>&1; then
  echo "gitleaks: not installed; skip (brew install gitleaks)" >&2
  exit 0
fi
gitleaks protect --staged --config .gitleaks.toml --verbose
EOF

chmod +x "$HOOK"
echo "Installed ${HOOK}"
