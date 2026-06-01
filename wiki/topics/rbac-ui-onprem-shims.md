# rbac-ui-onprem webpack shims

**Scope:** [FLPATH-4164](../entities/flpath-4164-rbac-mfe-poc.md) · **App:** [`submodules/koku-ui/apps/rbac-ui-onprem/`](../../submodules/koku-ui/apps/rbac-ui-onprem/)

Webpack replaces upstream modules so federated IAM runs inside **`koku-ui-onprem`** without freezing the tab (nav freeze / `Maximum update depth exceeded` on cluster).

## Necessity analysis (2026-06-01)

**Baseline pins:** koku-ui `238a666c7`, `vendor/insights-rbac-ui` `b4ca3746`, `@patternfly/react-component-groups` ^6.4.0.

**Method:** Ablation on cluster-backed dev server (`npm run start:onprem:dev` → http://localhost:9001/, `/api/rbac/v1/status/` **200**); live Cypress **21/21** with `assertNoDepthConsoleErrors` after each variant; production `build:onprem -w @koku-ui/rbac-ui-onprem` with shims ON for bundle baseline.

### Verdict summary

| Shim / policy | Dev-server ablation | Verdict | Notes |
|---------------|---------------------|---------|-------|
| `useAppLink` | Disabled alone → Cypress **16/16** nav specs pass | **Obsolete (dev)** | Pathname chain tests (`03-iam-sidebar-navigation`) stay `/iam/...`; no depth errors. Static diff vs upstream still differs (shim strips `/iam`; upstream prepends). |
| `LoaderPlaceholders` | Disabled alone → **21/21** | **Redundant (dev)** | Upstream `AppPlaceholder` still imports PF `SkeletonTable` subpath; **subpath aliases** stub it without this module replacement. |
| PF `SkeletonTable*` subpath aliases | Disabled (barrel ON) → **21/21** | **Redundant (dev)** when barrel shim ON | Barrel re-exports stub `SkeletonTableBody/Head`. |
| `component-groups` barrel | Disabled (subpaths ON) → **21/21** | **Redundant (dev)** when subpaths ON | Subpath aliases cover `LoaderPlaceholders` + guards; barrel imports get real PF via package root. |
| **All app shims off** | useAppLink + LoaderPlaceholders + barrel + subpaths disabled → **21/21** | **Obsolete (dev)** | Full stack navigates IAM without freeze on webpack-dev. |
| **All shims off + share `component-groups`** | Added to `sharedModules` + all shims off → **21/21** | **Obsolete (dev)** | Original rc16 failure mode not reproduced on dev stack. |
| `placeholders.tsx` | N/A (local) | **Required only if other shims kept** | Spinner/skeleton used by PF and loader shims. |
| Omit `component-groups` from `sharedModules` | Tested with shims on/off | **Uncertain** | Dev passed even when shared; historical cluster chunk **6658** / ThBase loop ([log 2026-05-22](../log.md)). |

**Production / cluster:** Deployed UI `quay.io/jkilzi/koku-ui-onprem:flpath-4164-rc25` (with shims) — in-pod `/rbac/plugin-manifest.json` **200**. **No-shim production image** not built or rolled out in this pass; rc16 freeze was on nginx production chunks, not webpack-dev.

**Recommendation:** Keep shims in tree until a **no-shim production build + cluster SSO smoke** confirms parity. Dev-server ablation suggests **candidate for removal** after that gate. Smallest retained set if trimming: **PF subpath aliases alone** may suffice on dev (covers `LoaderPlaceholders` + direct subpath imports); barrel shim defends barrel imports (`RolesTable`, `TableViewSkeleton`, ~19 upstream files).

**Upstream candidates (FLPATH-4152):** federated basename contract for `useAppLink`; subpath-only PF imports (no barrel for Skeleton*).

## Shim inventory

| Shim file | Replaces (upstream) | Why |
|-----------|---------------------|-----|
| [`insights-rbac/useAppLink.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/insights-rbac/useAppLink.ts) | `insights-rbac-frontend` → `shared/hooks/useAppLink` | Host already uses `basename="/iam"`; strip double `/iam` prefix on `Navigate` |
| [`insights-rbac/LoaderPlaceholders.tsx`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/insights-rbac/LoaderPlaceholders.tsx) | `ui-states/LoaderPlaceholders` | `AppPlaceholder` used real `SkeletonTable` → ThBase loop |
| [`patternfly/SkeletonTable*.tsx`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/patternfly/) | PatternFly `SkeletonTable` subpaths | Same ThBase issue for dynamic / ESM imports |
| [`patternfly/component-groups.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/patternfly/component-groups.ts) | `@patternfly/react-component-groups` (package root) | `RolesTable` imports `{ SkeletonTableBody }` from barrel — must not load shared chunk **6658** on cluster |

**Module federation:** `@patternfly/react-component-groups` is intentionally **omitted** from `sharedModules` in [`webpack.config.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/webpack.config.ts) for the same reason.

## Shared placeholder UI

[`placeholders.tsx`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/placeholders.tsx) — `OnpremIamSpinner`, `OnpremIamSkeletonBox` (used by loader and PF shims).

## Webpack wiring

[`webpack.config.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/webpack.config.ts) — `rbacUiOnpremShims` paths, `insightsRbacModuleReplacements`, aliases, and `NormalModuleReplacementPlugin` targets.

TypeScript alias: `@rbac-ui-onprem/shims/*` → `src/shims/*` ([`tsconfig.json`](../../submodules/koku-ui/apps/rbac-ui-onprem/tsconfig.json)).

## Related

- Vendored upstream build / Konflux — [rbac-ui-onprem-vendor.md](rbac-ui-onprem-vendor.md)
- Host IAM router basename `/iam` — [FLPATH-4164 entity](../entities/flpath-4164-rbac-mfe-poc.md#integration-constants)
- SaaS chrome / flags shims — [`libs/onprem-cloud-deps`](../../submodules/koku-ui/libs/onprem-cloud-deps/) (separate from this app-local tree)
- Historical: `TableView` shim removed (2026-05-22); host CSS for bundle cards instead — [wiki log](../log.md)
