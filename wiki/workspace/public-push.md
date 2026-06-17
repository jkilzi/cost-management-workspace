---
type: Workspace
title: Public push checklist
description: Post-history-scrub and gitleaks verification checklist before force-pushing to a public remote.
tags: [git, public, gitleaks, security, history-scrub]
timestamp: 2026-06-17T00:00:00Z
---

# Public push checklist

Use after [history scrub](../../scripts/history-scrub/run-filter-repo.sh) and a clean **gitleaks** scan.

## 1. Verify locally

```bash
gitleaks detect --log-opts=--all
./scripts/history-scrub/verify-history-clean.sh
```

Install the pre-commit gate (optional but recommended):

```bash
./scripts/install-gitleaks-hook.sh
```

## 2. Understand rewrite impact

- **All commit SHAs change** — prior signatures on old SHAs are invalid.
- Anyone with an old clone must **re-clone** or `git fetch --force` + hard reset to the new `main`.
- If `origin` already has the pre-scrub history, you must **force-push** once.

## 3. Push to GitHub (first public publish)

After history rewrite, replace remote `main` (adjust the lease SHA if `origin/main` moved):

```bash
git fetch origin
git push --force-with-lease=refs/heads/main:$(git rev-parse origin/main) origin main
```

If the remote was never pushed or is empty: `git push -u origin main`.

### GitHub Actions workflow (optional second step)

Pushing `.github/workflows/*.yml` requires OAuth **`workflow`** scope. If push is rejected:

```bash
gh auth refresh -h github.com -s workflow
cp scripts/gitleaks.workflow.yml.example .github/workflows/gitleaks.yml
git add .github/workflows/gitleaks.yml
git commit -S -s -m "ci: add gitleaks workflow"
git push origin main
```

Or create the workflow in the GitHub UI (Actions → New workflow → paste from `scripts/gitleaks.workflow.yml.example`).

## 4. GitHub repository settings

### Required for this workspace (free)

- Confirm the **gitleaks** workflow is green on `main` (Actions tab). That is the primary secret gate for this repo.
- Set visibility to **Public** in **Settings → General** only after steps 1–3 pass. After going public, security controls usually show up under **Settings → Security** (wording may be **Code security and analysis**, **Advanced Security**, or **Secret protection** depending on GitHub’s UI).

### Optional: GitHub Advanced Security (GHAS) — paid

GitHub’s full **secret scanning** + **push protection** product is **[GitHub Secret Protection](https://docs.github.com/en/get-started/learning-about-github/about-github-advanced-security)** (paid on **private** repos; requires Team/Enterprise or an org license). **Not required** for this workspace — **gitleaks** remains the primary gate.

| Repo type | What you see |
|-----------|----------------|
| **Private personal** | Often **no** repo-level secret-scanning / push-protection toggles (GHAS not licensed). |
| **Public** | **Settings → Security** (or similar) — enable what GitHub offers for public repos; some features are free/limitied, **full Secret Protection** on private repos is still a **paid** SKU. |
| **Team / Enterprise / org with GHAS** | **Settings → Security → Advanced Security** → **Secret protection**, **Push protection**. |

Enabling GitHub-native scanning is **optional** if gitleaks is green. Useful as defense-in-depth after the repo is public.

## 5. Re-scrub if leaks return

Edit [`scripts/history-scrub/replacements.txt`](../../scripts/history-scrub/replacements.txt), re-run `./scripts/history-scrub/run-filter-repo.sh` on a **backup clone**, then force-push again.

See also [public-repo-hygiene.md](public-repo-hygiene.md).
