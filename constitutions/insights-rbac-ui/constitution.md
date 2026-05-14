# Insights RBAC UI — constitution

## Upstream repository

[https://github.com/RedHatInsights/insights-rbac-ui.git](https://github.com/RedHatInsights/insights-rbac-ui.git)

## Mission

React application for Red Hat’s IAM / role-based access control surfaces in the Hybrid Cloud Console: user access and access-management flows against the RBAC APIs (`@redhat-cloud-services/rbac-client` and related platform clients). In this workspace it is the **upstream source of truth** for the RBAC admin UI that **FLPATH-4164** federates into **`koku-ui-onprem`**, served same-origin with the chart’s **`/api/rbac/`** admin API (see **`cost-onprem-chart`** constitution and RPI scopes **flpath-4164** / **flpath-4180**).

## Tech stack

- Node.js and npm per root `engines` (Node >= 22.12.x)
- TypeScript, webpack, React 18
- PatternFly v6 (`@patternfly/react-core`, tables, data-view, component groups, quickstarts, icons)
- React Router v6, React Intl, TanStack Query
- Red Hat Insights platform packages (`@redhat-cloud-services/frontend-components*`, `rbac-client`, notifications, utilities, types)
- Feature flags via `@unleash/proxy-client-react`
- Data-driven forms (PF4 mapper) where forms are built declaratively
- Storybook with MSW-backed interaction tests; Playwright for E2E against staging
- SaaS build uses Insights **FEC** / `frontend-components-config`; **on-prem** packaging in this program adds a **module-federation remote** (OpenShift **DynamicRemotePlugin**) consumed by **`koku-ui-onprem`** — see upstream `src/docs/ModuleFederation.mdx` and submodule **`AGENTS.md`** for architecture, V1/V2 boundaries, and contribution rules
