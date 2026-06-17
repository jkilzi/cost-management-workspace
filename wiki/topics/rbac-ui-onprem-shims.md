---
type: Topic
title: rbac-ui-onprem webpack shims
description: Webpack module replacements for federated RBAC IAM in koku-ui-onprem; useAppLink only after 2026-06-01 removal pass.
tags: [rbac, koku-ui, shims, webpack, flpath-4164, useAppLink]
timestamp: 2026-06-17T00:00:00Z
---

# rbac-ui-onprem webpack shims

**Scope:** [FLPATH-4164](../entities/flpath-4164-rbac-mfe-poc.md) · **App:** [`submodules/koku-ui/apps/rbac-ui-onprem/`](../../submodules/koku-ui/apps/rbac-ui-onprem/)

Webpack replaces upstream modules so federated IAM runs inside **`koku-ui-onprem`** without pathname bugs or (historically) tab freeze on cluster nginx.

## Current state (2026-06-01 removal pass)

| Layer | State |
|-------|--------|
| **Retained** | [`useAppLink.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/insights-rbac/useAppLink.ts) only — strips `/iam` prefix for host `basename="/iam"` |
| **Removed** | `LoaderPlaceholders`, PF `SkeletonTable*`, `component-groups` barrel, `placeholders.tsx` |
| **Branch** | koku-ui `chore/remove-rbac-ui-onprem-shims` @ `cbd4ac211` |
| **Cluster image** | `quay.io/jkilzi/koku-ui-onprem:flpath-4164-no-shim-rc1` (GHA from workspace branch) |
| **PR** | https://github.com/jkilzi/koku-ui/pull/2 |

**Policy kept:** `@patternfly/react-component-groups` **not** in `sharedModules` ([`webpack.config.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/webpack.config.ts)).

### Verification evidence

| Gate | Result |
|------|--------|
| Production `build:onprem` | Pass; **0** `OnpremIamSpinner` in `dist/` (real `SkeletonTable` in bundles — expected) |
| `start:onprem:dev` + Cypress | **21/21** with `useAppLink` only; **19/21** with zero shims (`/iam/iam/my-user-access` on IAM→MUA nav) |
| In-pod manifest | `/rbac/plugin-manifest.json` **200** on `flpath-4164-no-shim-rc1` |
| In-pod bundle audit | **0** files matching `OnpremIamSpinner`; real PF `SkeletonTable` present (no shim stubs) |
| SSO manual IAM nav | **Pass** (2026-06-01, human) — local `start:onprem:dev` + cluster `flpath-4164-no-shim-rc1` behind SSO; no tab freeze, IAM nav OK |

## Necessity analysis (2026-06-01 ablation)

**Baseline pins:** koku-ui `238a666c7`, upstream `b4ca3746`, PF component-groups ^6.4.0.

**Method:** Ablation on cluster-backed dev server; live Cypress with `assertNoDepthConsoleErrors`; production build + cluster image `flpath-4164-no-shim-rc1`.

### Verdict summary

| Shim / policy | Verdict after removal pass |
|---------------|----------------------------|
| `useAppLink` | **Required** — without it, IAM→IAM nav produces `/iam/iam/...` (Cypress `03-iam-sidebar-navigation` fails) |
| `LoaderPlaceholders` | **Removed** — not required on dev or in no-shim-rc1 pod bundles |
| PF `SkeletonTable*` subpaths + barrel | **Removed** — dev **21/21** without them after `useAppLink` restored; rc16 ThBase loop not reproduced on current stack |
| `placeholders.tsx` | **Removed** (only used by deleted PF/loader shims) |
| Omit `component-groups` from `sharedModules` | **Keep** — unchanged; dev tolerated sharing when all shims off, cluster rc16 history cautions |

**Upstream candidates (FLPATH-4152):** federated basename contract for `useAppLink` (would allow dropping the last shim).

## Retained shim

| Shim file | Replaces | Why |
|-----------|----------|-----|
| [`insights-rbac/useAppLink.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/insights-rbac/useAppLink.ts) | `shared/hooks/useAppLink.ts` | Host `BrowserRouter` uses `basename="/iam"`; upstream prepends `/iam` → double prefix on in-app IAM links |

## Removed shims (historical)

| Shim | Former purpose |
|------|----------------|
| `LoaderPlaceholders.tsx` | Avoid `AppPlaceholder` → real `SkeletonTable` |
| `patternfly/SkeletonTable*.tsx` | Stub PF subpath imports |
| `patternfly/component-groups.ts` | Barrel re-export; block chunk **6658** on cluster |
| `placeholders.tsx` | Shared spinner/skeleton for above |

## Webpack wiring

[`webpack.config.ts`](../../submodules/koku-ui/apps/rbac-ui-onprem/webpack.config.ts) — `NormalModuleReplacementPlugin` + aliases for `useAppLink` only; `onprem-cloud-deps` platform aliases unchanged.

## Related

- [rbac-ui-onprem-vendor.md](rbac-ui-onprem-vendor.md)
- [FLPATH-4164 entity](../entities/flpath-4164-rbac-mfe-poc.md)
- [onprem-ui-cluster-image.md](onprem-ui-cluster-image.md)
