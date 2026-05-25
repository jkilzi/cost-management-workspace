# FLPATH-4164 — RBAC UI on-prem MFE (POC)

**Jira:** [FLPATH-4164](https://redhat.atlassian.net/browse/FLPATH-4164) (*POC: RBAC UI as on-prem MFE (koku-ui-onprem + chart RBAC API)*). **Parent:** [FLPATH-3424](https://redhat.atlassian.net/browse/FLPATH-3424).

**Prerequisite (closed):** [FLPATH-4180](https://redhat.atlassian.net/browse/FLPATH-4180) — see [flpath-4180-fec-rbac-mfe.md](flpath-4180-fec-rbac-mfe.md).

**UX vision (product):** On **FLPATH-4164**, Jira **comment +** `ux-vision-my-user-access-cost-onprem.png` (Identity and Access Management shell, **My User Access**); session context: [FLPATH-3424 focused comment](https://redhat.atlassian.net/browse/FLPATH-3424?focusedCommentId=16901888).

**Branch (stakeholder):** `submodules/koku-ui` on **`feat/flpath-4164`**.

## Parent epic (FLPATH-3424)

On-prem Cost Management RBAC UI: reuse HCC direction, Keycloak between IDP and Cost, upstream **insights-rbac-ui** as source of truth with build-time gates for SaaS-only features. Near-term delivery evolved to **MFE inside `koku-ui-onprem`** (this POC), not a separate hostname. **Blocks:** FLPATH-4121 (design). See [FLPATH-3424](https://redhat.atlassian.net/browse/FLPATH-3424).

## Scope and goal

| Field | Value |
|-------|--------|
| **Submodules** | `cost-onprem-chart` (Envoy `/api/rbac/`), `koku-ui` (`koku-ui-onprem` host, `rbac-ui-onprem` remote, `onprem-cloud-deps` shims) |
| **Goal** | Federate **insights-rbac-ui** into **`koku-ui-onprem`** (Scalprum + `DynamicRemotePlugin`), `/rbac/` assets, `/api/rbac/` same-origin, prove IAM on cluster before maintainer sync (**FLPATH-4152**) |

**Constraint:** No edits to **RedHatInsights/insights-rbac-ui** in this POC — wrapper + pin in `apps/rbac-ui-onprem/`.

## Integration constants

| Constant | Value |
|----------|--------|
| Scalprum scope | `insightsRbac` |
| `publicPath` / static | `/rbac/` |
| Federated module | `./Iam` |
| IAM host routes | `/iam/*` |
| Router basename (IAM) | `/iam` when URL under `/iam` |

## Plan (phases)

| Phase | Objective | Status |
|-------|-----------|--------|
| 0 | Preconditions — branch, 4180 read | Done |
| 1 | `apps/rbac-ui-onprem` remote + manifest | Done |
| 2 | Host static, proxy, Scalprum, `/iam/*` | Done |
| 3 | Unleash / `useFlag` stub | Done |
| 4 | Root `build:onprem` / `verify:onprem` | Done |
| 5 | `onprem-cloud-deps` shims | Done (extend as needed) |
| 6 | Production image + chart `/rbac/` nginx | Done |
| 7 | Local + cluster verification | Done |
| 8 | Host ↔ IAM nav freeze fix | Done |
| 9 | Storybook visual parity (MUA-02, tables, OV icon) | Done (rc19–rc21) |

**Deferred:** Upstream RBAC repo edits; `ExtensionsPlugin` parity; Stefan-flagged UX removals until FLPATH-4121 list.

## Implementation status (2026-05-25)

| Layer | State |
|-------|--------|
| Remote | `apps/rbac-ui-onprem` — `insightsRbac`, `/rbac/`, `./Iam`; `npm run verify:onprem` ✅ (2026-05-25) |
| Host e2e | `cypress/e2e/live/` — **`test:cypress:live`** **21/21** after **`start:onprem:dev`** (~31s); not CI |
| Host | `/rbac/`, `/api/rbac` proxy, `/iam/*`, chrome stub |
| Chart | nginx `location /rbac/` — `feat/flpath-4164-ui-rbac-nginx` |
| Cluster image | **`quay.io/jkilzi/koku-ui-onprem:flpath-4164-rc22`** on **`<leased-cluster>`** |
| Branch | `submodules/koku-ui` → `feat/flpath-4164` |
| Verified | **Local pass** (2026-05-25) — build + verify + live Cypress + `/api/rbac/v1/status/` **200** via dev proxy |
| Host nav | `NavExpandable` **Identity and Access Management** → Overview, MUA, Users, Roles, Groups |
| Visual | [visual-compare/cluster/](visual-compare/cluster/) — rc19+ screenshots; live parity screenshots in `cypress/screenshots/04-iam-storybook-parity.cy.ts/` |

**Overall:** POC shell + functional gates satisfied; visual parity must-fix items passed on rc19–rc21. Open: refresh cluster PNGs on rc21+; breadcrumbs/tab title out of POC scope.

## Acceptance criteria (summary)

**UI-modifying:** yes — `submodules/koku-ui/`.

**Preconditions (local):** `npm run build:onprem`; `npm run verify:onprem`; `npm run start:onprem:dev`; optional `/api/rbac/v1/status/` 2xx via `setup-onprem-env.sh`.

**Host IAM nav:** After Settings, `NavExpandable` **Identity and Access Management** with children: Overview → `/iam/user-access/overview`, My User Access → `/iam/my-user-access`, Users, Roles, Groups (full `/iam/...` paths).

**E2E (local, not CI):** From `submodules/koku-ui` root: `npm run start:onprem:dev` then **`npm run test:cypress:live`** (**21** tests — `01`–`03` nav/load, `04` Storybook parity). Specs: `apps/koku-ui-onprem/cypress/e2e/live/`. If Cypress verify fails with `bad option: --no-sandbox`, unset `ELECTRON_RUN_AS_NODE` (set by some IDE sandboxes).

**Cluster (manual, oauth2-proxy):** Deployed tag matches record; in-pod `/rbac/plugin-manifest.json` **200**; manual Chrome for IAM nav behind SSO.

**Out of scope:** Cluster Cypress without auth; full Helm upgrade unblock; pixel-perfect SaaS chrome outside POC slice.

## Cluster redeploy note (2026-05-22)

IAM `/api/rbac/v1/*` calls require Envoy route `prefix: /api/rbac/` (FLPATH-4073). **Published** Helm repo chart **0.2.19** / **0.2.20-rc4** omit it; **`USE_LOCAL_CHART=true`** from `submodules/cost-onprem-chart` (`feat/flpath-4164-ui-rbac-nginx`, chart **0.2.20-rc5**) is required until a published release includes that template. Symptom without route: gateway access log **404** `response_flags=NR`, RBAC API pod healthy in-cluster.

## Nav diagnosis (2026-05-19, resolved)

**Symptoms (fixed):** IAM page freeze; sidebar toggle hang; cannot return to Overview; `Maximum update depth exceeded`.

**Root causes:** (A) federated `SkeletonTable` loop; (B) cross-app nav + IAM catch-all race; (C) unstable `useChrome` object identity.

**Fixes:** Webpack shims (`LoaderPlaceholders`, `TableView`); host full-page nav for cross-app; stable `useChrome` singleton; `remoteKey` on Scalprum; basename `/iam` on host router.

## Cluster deploy

| Item | Value |
|------|--------|
| **Image** | `quay.io/jkilzi/koku-ui-onprem:flpath-4164-rc22` |
| **Cluster** | `<leased-cluster>`, namespace `cost-onprem` |
| **Build** | On-demand GHA — [koku-ui-onprem-cluster-image skill](../../.cursor/skills/koku-ui-onprem-cluster-image/SKILL.md) → `trigger-build.sh <tag>` ([wiki topic](../topics/onprem-ui-cluster-image.md)) |
| **Rollout** | Local Helm — `ui-image-values.local.yaml` + `rollout-ui-image.sh` (not GHA) |
| **Verify in pod** | `verify-ui-pod.sh` or `curl http://127.0.0.1:8080/rbac/plugin-manifest.json` → **200** |

**Quick alternative:** `oc set image deployment/cost-onprem-ui -n cost-onprem app=quay.io/<your-org>/koku-ui-onprem:<tag>` (bypasses Helm values; prefer skill rollout for durable `ui.app.image`).

## Visual compare

Evidence: [visual-compare/VISUAL_SIGNOFF.md](visual-compare/VISUAL_SIGNOFF.md), [visual-compare/cluster/](visual-compare/cluster/), [visual-compare/storybook/](visual-compare/storybook/).
