# Sources UI — constitution

## Upstream repository

[https://github.com/RedHatInsights/sources-ui.git](https://github.com/RedHatInsights/sources-ui.git)

## Mission

React application for **Platform Sources** on the Red Hat Hybrid Cloud Console: list and manage cloud/OpenShift integrations, connect platform applications (including Cost Management), pause/resume sources and applications. In this workspace it is a **read/reference** checkout for SaaS UX and behavior when working on **`koku-ui`** **`apps/koku-ui-sources`** (on-prem Integrations MFE against Koku’s `/api/cost-management/v1/sources/`).

## Backend (not a workspace submodule)

SaaS UI talks to **[RedHatInsights/sources-api-go](https://github.com/RedHatInsights/sources-api-go)** (current Platform Sources API). The legacy Ruby **[sources-api](https://github.com/RedHatInsights/sources-api)** repo is archived. Do **not** add the API repo here unless the program explicitly needs it checked out.

## Tech stack

- Node.js and npm per root `engines` (Node >= 20.x)
- JavaScript/TypeScript, webpack, React 18
- PatternFly v6, Data Driven Forms (PF4 mapper)
- Red Hat Insights platform packages (`@redhat-cloud-services/frontend-components*`)
- SaaS build via Insights **FEC** / `frontend-components-config`; deploy repo: [sources-ui-deploy](https://github.com/RedHatInsights/sources-ui-deploy)

## Relation to `koku-ui`

| Surface | Repo / path | API |
|---------|-------------|-----|
| SaaS (HCC) | `sources-ui` (this submodule) | Platform Sources (`sources-api-go`) |
| On-prem | `koku-ui` → `apps/koku-ui-sources` | Koku Cost Management sources REST |

On-prem **`koku-ui-sources`** is a **greenfield** implementation (not a git fork of `sources-ui`); use this submodule when comparing flows, copy, or component patterns.
