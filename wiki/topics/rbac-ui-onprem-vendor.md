# rbac-ui-onprem vendored RBAC remote

**Scope:** [FLPATH-4164](../entities/flpath-4164-rbac-mfe-poc.md) · **App:** [`submodules/koku-ui/apps/rbac-ui-onprem/`](../../submodules/koku-ui/apps/rbac-ui-onprem/)

Hermetic on-prem UI builds (Konflux, isolated `npm ci`, Containerfile) use a **pre-built** federated remote. Upstream **source** is only fetched when a maintainer runs `npm run vendor:rbac-onprem` (or CI with network).

## Layout

| Path | Committed? | Purpose |
|------|------------|---------|
| `rbac-ui.version.json` | Yes | Full git `ref`, `vendorDir` |
| `vendor/insights-rbac-ui@<short>/dist/` | Yes | Webpack output (`plugin-manifest.json`, `./Iam` bundles) |
| `vendor/insights-rbac-ui@<short>/rbac-ui.build.json` | Yes | `builtAt`, wrapper SHA, manifest metadata |
| OS temp (`mktemp`) during vendor | No | Upstream clone + `npm ci --ignore-scripts` |

`<short>` = first 7 characters of `ref`.

## Vendor pipeline

```bash
cd submodules/koku-ui
npm run vendor:rbac-onprem
```

1. Clone `RedHatInsights/insights-rbac-ui` @ `ref` into `$TMPDIR` (or `RBAC_SRC`).
2. `npm ci --ignore-scripts` in clone; link `file:` → `node_modules/insights-rbac-frontend`.
3. `apps/rbac-ui-onprem` webpack build (shims unchanged).
4. Move `dist/` → `vendor/insights-rbac-ui@<short>/dist/`; write `rbac-ui.build.json`.
5. Uninstall transient package; `npm run verify:onprem`.

## Consumer builds

- **Root `build:onprem`:** `scripts/build-rbac-onprem.sh` skips webpack when vendored `dist/` exists.
- **Containerfile:** copies `vendor/` + stages `rbac-static` from `vendorDir` (no GitHub at image `npm ci`).
- **Dev server:** [`koku-ui-onprem` webpack](../../submodules/koku-ui/apps/koku-ui-onprem/webpack.config.ts) serves vendored `dist/` when present.

## Related

- [rbac-ui-onprem shims](rbac-ui-onprem-shims.md)
- [FLPATH-4164 entity](../entities/flpath-4164-rbac-mfe-poc.md)
