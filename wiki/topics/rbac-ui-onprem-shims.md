# rbac-ui-onprem webpack shims

**Scope:** [FLPATH-4164](../entities/flpath-4164-rbac-mfe-poc.md) · **App:** [`submodules/koku-ui/apps/rbac-ui-onprem/`](../../submodules/koku-ui/apps/rbac-ui-onprem/)

Webpack replaces upstream modules so federated IAM runs inside **`koku-ui-onprem`** without freezing the tab (nav freeze / `Maximum update depth exceeded` on cluster).

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

[`webpack-paths.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/webpack-paths.ts) — absolute paths for aliases and `NormalModuleReplacementPlugin` targets (`insightsRbacModuleReplacements`, `rbacUiOnpremShims`).

TypeScript alias: `@rbac-ui-onprem/shims/*` → `src/shims/*` ([`tsconfig.json`](../../submodules/koku-ui/apps/rbac-ui-onprem/tsconfig.json)).

## Related

- Vendored upstream build / Konflux — [rbac-ui-onprem-vendor.md](rbac-ui-onprem-vendor.md)
- Host IAM router basename `/iam` — [FLPATH-4164 entity](../entities/flpath-4164-rbac-mfe-poc.md#integration-constants)
- SaaS chrome / flags shims — [`libs/onprem-cloud-deps`](../../submodules/koku-ui/libs/onprem-cloud-deps/) (separate from this app-local tree)
- Historical: `TableView` shim removed (2026-05-22); host CSS for bundle cards instead — [wiki log](../log.md)
