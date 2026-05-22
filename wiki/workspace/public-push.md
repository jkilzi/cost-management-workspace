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

- Enable **secret scanning** and **push protection** (org/repo Settings → Code security).
- Confirm the **gitleaks** workflow runs green on `main` after it is added.
- Set visibility to **Public** only after steps 1–3 pass.

## 5. Re-scrub if leaks return

Edit [`scripts/history-scrub/replacements.txt`](../../scripts/history-scrub/replacements.txt), re-run `./scripts/history-scrub/run-filter-repo.sh` on a **backup clone**, then force-push again.

See also [public-repo-hygiene.md](public-repo-hygiene.md).
