# Public repo hygiene

Guidance when this workspace (or excerpts) may be shared outside a trusted team.

## Do not commit

| Path | Why |
|------|-----|
| `.playwright-mcp/` | MCP browser snapshots/logs; may include cluster hostnames and filled login fields |
| `wiki/**/visual-compare/cluster/*.png` | Workshop cluster UI captures; may show usernames or org context |
| `.cursor/skills/git-submodules-status/references/config.json` | Local git remote mapping (gitignored) |
| Submodule `.env` / `e2e/auth/.env.*.ci` | Lives under `submodules/`; never copy into the superproject |

Storybook baseline PNGs under `wiki/**/visual-compare/storybook/` are lower risk but still optional to commit.

## Redact in wiki and plans

Replace workspace-specific values with placeholders:

| Sensitive pattern | Placeholder |
|-------------------|-------------|
| Personal Quay org (`quay.io/<user>/…`) | `quay.io/<your-org>/…` |
| Demo Catalog user URL | [Demo Catalog](https://catalog.demo.redhat.com/) → your services list |
| `cluster-<id>` hostnames / `*.apps.*.redhatworkshops.io` | `<leased-cluster>` or generic `cost-onprem-ui-*.apps.<cluster>.<domain>` |
| Pull secret name | `<quay-pull-secret>` |
| Absolute home paths (`/Users/…/cost-management-workspace`) | `.gitmodules` or `$WORKSPACE_ROOT` |

Entity pages for scoped work may keep **image tags** and **namespace** (`cost-onprem`) when they are not tied to a personal account.

## History

Scrub workspace-specific strings and drop `pipelines/rpi/` from all commits:

```bash
./scripts/history-scrub/run-filter-repo.sh
gitleaks detect --log-opts=--all
```

Then follow **[public-push.md](public-push.md)** before `git push --force-with-lease`.
