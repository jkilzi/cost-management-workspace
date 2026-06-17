---
type: Topic
title: rbac-ui-onprem vendored RBAC upstream
description: insights-rbac-ui git submodule in koku-ui for hermetic Konflux builds; file: devDependency pattern.
tags: [rbac, koku-ui, vendor, submodule, konflux, flpath-4164, npm]
timestamp: 2026-06-17T00:00:00Z
---

# rbac-ui-onprem vendored RBAC upstream

**Scope:** [FLPATH-4164](../entities/flpath-4164-rbac-mfe-poc.md) · **App:** [`submodules/koku-ui/apps/rbac-ui-onprem/`](../../submodules/koku-ui/apps/rbac-ui-onprem/)

Hermetic on-prem UI builds (Konflux, isolated `npm ci`, Containerfile) install upstream RBAC from a **committed git submodule** at the koku-ui root. No GitHub fetch at image build when the submodule tree is present in the build context.

## Layout

| Path | Committed? | Purpose |
|------|------------|---------|
| `.gitmodules` | Yes | Submodule `vendor/insights-rbac-ui` path and remote URL |
| `vendor/insights-rbac-ui/` | Yes (gitlink) | `RedHatInsights/insights-rbac-ui` at pinned commit (`insights-rbac-frontend` package) |
| `apps/rbac-ui-onprem/package.json` | Yes | `devDependencies.insights-rbac-frontend`: `file:../../vendor/insights-rbac-ui` |
| `package-lock.json` | Yes | Lockfile resolution for the `file:` directory |
| `apps/rbac-ui-onprem/dist/` | No (gitignored) | Webpack output; built in Containerfile and locally |

**Pin source of truth:** `.gitmodules` (path/URL) and the **submodule gitlink** in koku-ui (`git add vendor/insights-rbac-ui`).

## Bump upstream

```bash
cd submodules/koku-ui
cd vendor/insights-rbac-ui && git fetch origin && git checkout <full-sha> && cd ../..
git add vendor/insights-rbac-ui
git submodule update --init vendor/insights-rbac-ui
HUSKY=0 npm install -w @koku-ui/rbac-ui-onprem   # refresh package-lock.json if needed
git add package-lock.json   # when changed
```

After `git pull` that changes the gitlink only: `git submodule update --init vendor/insights-rbac-ui` then `npm ci` at koku-ui root.

## Consumer builds

- **Containerfile:** `COPY vendor/` before `npm ci` (submodule sources must be checked out in build context); `ENV HUSKY=0` for upstream lifecycle scripts; after other MFEs, `COPY apps/rbac-ui-onprem` and `npm run build:onprem`; nginx serves `apps/rbac-ui-onprem/dist` at `/rbac/`.
- **Clone:** `git clone --recurse-submodules` or `git submodule update --init vendor/insights-rbac-ui`.
- **Root `build:onprem`:** includes `@koku-ui/rbac-ui-onprem` webpack build.
- **Dev server:** [`koku-ui-onprem` webpack](../../submodules/koku-ui/apps/koku-ui-onprem/webpack.config.ts) serves `../rbac-ui-onprem/dist` (webpack watch in `start:onprem:dev`).

## Related

- [rbac-ui-onprem shims](rbac-ui-onprem-shims.md)
- [FLPATH-4164 entity](../entities/flpath-4164-rbac-mfe-poc.md)
