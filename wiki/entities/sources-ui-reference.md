---
type: Reference
title: Sources UI — reference submodule
description: submodules/sources-ui pins RedHatInsights/sources-ui for SaaS Platform Sources UI reference; not built by cost-onprem-chart.
tags: [sources-ui, koku-ui, submodule, saas, reference]
timestamp: 2026-06-17T00:00:00Z
---

# Sources UI (reference submodule)

## Role in this workspace

**`submodules/sources-ui`** pins **[RedHatInsights/sources-ui](https://github.com/RedHatInsights/sources-ui)** for SaaS Platform Sources UI reference. It is **not** built or deployed by `cost-onprem-chart`; on-prem Integrations live in **`koku-ui`** → **`apps/koku-ui-sources`**.

## Backend (not checked out here)

| Repo | Role |
|------|------|
| [sources-api-go](https://github.com/RedHatInsights/sources-api-go) | Current Platform Sources REST API used by SaaS `sources-ui` |
| [sources-api](https://github.com/RedHatInsights/sources-api) | Legacy Ruby API (archived) |

On-prem **`koku-ui-sources`** calls Koku **`/api/cost-management/v1/sources/`**, not `sources-api-go`.

## When to open this submodule

- Compare SaaS vs on-prem Integrations UX before changing **`koku-ui-sources`**
- Trace how Cost Management connects to a source on HCC (applications on source, pause/resume, etc.)
- Inspect FEC/webpack patterns in a mature Insights app without pulling the whole console

## Related

- Constitution: [`constitutions/sources-ui.md`](../../constitutions/sources-ui.md)
- On-prem app: `submodules/koku-ui/apps/koku-ui-sources/` (package `@koku-ui/koku-ui-sources`)
- RPI / PR context: [project-koku/koku-ui#4977](https://github.com/project-koku/koku-ui/pull/4977) — replaces SaaS Platform Sources dependency for on-prem
