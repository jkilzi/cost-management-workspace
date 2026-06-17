---
type: Entity
title: FLPATH-4180 — FEC extension points vs on-prem RBAC MFE
description: Research closeout comparing FEC ExtensionsPlugin vs on-prem Scalprum + DynamicRemotePlugin; unblocks FLPATH-4164.
tags: [flpath-4180, flpath-4164, rbac, fec, scalprum, research, closed]
timestamp: 2026-06-17T00:00:00Z
---

# FLPATH-4180 — FEC extension points vs on-prem RBAC MFE

**Jira:** [FLPATH-4180](https://redhat.atlassian.net/browse/FLPATH-4180) (*Research FEC extension points for embedding/delivering RBAC UI*) — **Closed** / **Done**. Linked to [FLPATH-4164](https://redhat.atlassian.net/browse/FLPATH-4164) as **Related** (was **Blocks**; changed 2026-05-14 — see [jira-cli-issue-links.md](../workspace/jira-cli-issue-links.md)).

**UX mock** for **4164:** comment + **`ux-vision-my-user-access-cost-onprem.png`** on [FLPATH-4164](https://redhat.atlassian.net/browse/FLPATH-4164).

**Jira discoverability:** This repo is not published; use **self-contained ticket text** per [jira-handoff-without-public-repo.md](../workspace/jira-handoff-without-public-repo.md). Copy minimum conclusions into **FLPATH-4164**.

## Research conclusions

**FEC / federation:** Insights **FEC** documents **`ExtensionsPlugin`** extension objects for Chrome to merge nav/routes ([frontend-components `consuming-module.md`](https://github.com/RedHatInsights/frontend-components/blob/master/docs/fed/consuming-module.md)).

**insights-rbac-ui (facts):**

- **`fec.config.js`:** `plugins: []` — **no `ExtensionsPlugin`** in webpack.
- **Nav/routes:** In-app **React Router** (`v1/Routing.tsx`); SaaS platform registration via `deploy/frontend.yaml` (orthogonal to ExtensionsPlugin).
- **Chrome surface:** `usePlatformAuth`, `usePlatformEnvironment`, `usePlatformTracking`, quickstarts — host must stub `window.insights.chrome` / `useChrome` for on-prem.
- **Flags:** `useFlag` from `@unleash/proxy-client-react` — separate from chrome; on-prem uses stub `FlagProvider`.

**Recommendation for 4164:** **`koku-ui-onprem`** uses **Scalprum + `DynamicRemotePlugin`** (HCCM/ROS/Sources pattern), explicit host `Route` + `ScalprumComponent` at `/iam/*` — **not** ExtensionsPlugin merge. Expand chrome stubs per resolved questions in research closeout.

**MFE vs sibling app:** Embedding via same-origin MFE + `/api/rbac/` preferred over separate UI hostname for POC acceptance.

## Delivery log (2026-05-14 closeout)

| Step | Outcome |
|------|---------|
| Jira **FLPATH-4180** | Self-contained digest comment; transitioned **Closed** (Done) |
| Jira **FLPATH-4164** | Same digest carry-forward for implementers without repo access |
| Wiki | [jira-handoff-without-public-repo.md](../workspace/jira-handoff-without-public-repo.md), entity pages updated |

**Verification:** **Pass** — research + Jira deliverables; no `submodules/` code changes. Residual: **4164** implementation tracked on [flpath-4164-rbac-mfe-poc.md](flpath-4164-rbac-mfe-poc.md).

**One-line takeaway:** FEC **ExtensionsPlugin** is not how **insights-rbac-ui** ships today; on-prem aligns **4164** with **Scalprum** and host chrome stubs.
