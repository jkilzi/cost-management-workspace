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
| **Submodules** | `cost-onprem-chart` (Envoy `/api/rbac/`), `koku-ui` (`koku-ui-onprem` host, `rbac-ui-onprem` remote + [app shims](../topics/rbac-ui-onprem-shims.md), `onprem-cloud-deps` shims) |
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
| 4 | Root `build:onprem`; RBAC webpack in workspace / image | Done |
| 5 | `onprem-cloud-deps` shims | Done (extend as needed) |
| 6 | Production image + chart `/rbac/` nginx | Done |
| 7 | Local + cluster verification | Done |
| 8 | Host ↔ IAM nav freeze fix | Done |
| 9 | Storybook visual parity (MUA-02, tables, OV icon) | Done (rc19–rc21) |

**Deferred:** Upstream RBAC repo edits; `ExtensionsPlugin` parity; Stefan-flagged UX removals until FLPATH-4121 list.

## Implementation status (2026-05-25)

| Layer | State |
|-------|--------|
| Remote | `apps/rbac-ui-onprem` — `insightsRbac`, `/rbac/`, `./Iam`; upstream submodule `koku-ui/vendor/insights-rbac-ui` @ pinned commit ([vendor topic](../topics/rbac-ui-onprem-vendor.md)); webpack `dist/` at image build |
| Host e2e | `cypress/e2e/live/` — workspace **`test:cypress:live`** **21/21** after root **`start:onprem:dev`** (~31s); not CI |
| Host | `/rbac/`, `/api/rbac` proxy, `/iam/*`, chrome stub |
| Chart | nginx `location /rbac/` — PR [#175](https://github.com/insights-onprem/cost-onprem-chart/pull/175); **deployed locally** via `USE_LOCAL_CHART=true` @ `feat/flpath-4164-ui-rbac-nginx-pr` (2026-05-27); UI pod restart required for ConfigMap reload |
| Cluster image | **`quay.io/jkilzi/koku-ui-onprem:flpath-4164-rc24`** on **cluster-f4rmt** (2026-05-27) |
| Branch | `submodules/koku-ui` → `feat/flpath-4164` @ `5ca533010` |
| **PRs (open)** | **koku-ui:** [project-koku/koku-ui#5207](https://github.com/project-koku/koku-ui/pull/5207) · **chart nginx:** [#175](https://github.com/insights-onprem/cost-onprem-chart/pull/175) · **chart RFE (SSA):** [#176](https://github.com/insights-onprem/cost-onprem-chart/pull/176) (separate from 4164) |
| Verified | **Pre-PR pass** (2026-05-25) — root `build:onprem` ✅; prior live Cypress **21/21** + `/api/rbac/v1/status/` **200** via dev proxy |
| Host nav | `NavExpandable` **Identity and Access Management** → Overview, MUA, Users, Roles, Groups |
| Visual | [visual-compare/cluster/](visual-compare/cluster/) — rc19+ screenshots; live parity screenshots in `cypress/screenshots/04-iam-storybook-parity.cy.ts/` |

**Overall:** POC submitted for review (koku-ui #5207 + chart #175). **CI green** on koku-ui PR (2026-05-27, submodule checkout fix). Cluster **rc24** deployed. Follow-up: FLPATH-4152 maintainer sync after merge.

## Acceptance criteria (summary)

**UI-modifying:** yes — `submodules/koku-ui/`.

**Preconditions (local):** `git submodule update --init vendor/insights-rbac-ui` in koku-ui; root `npm ci`; root `npm run build:onprem`; root `npm run start:onprem:dev`; optional `/api/rbac/v1/status/` 2xx via `setup-onprem-env.sh`. Bump upstream RBAC pin: checkout SHA in `vendor/insights-rbac-ui`, `git add` gitlink, `git submodule update --init`, then `HUSKY=0 npm install -w @koku-ui/rbac-ui-onprem` if lockfile changes (see [rbac-ui-onprem-vendor](../topics/rbac-ui-onprem-vendor.md)).

**Host IAM nav:** After Settings, `NavExpandable` **Identity and Access Management** with children: Overview → `/iam/user-access/overview`, My User Access → `/iam/my-user-access`, Users, Roles, Groups (full `/iam/...` paths).

**E2E (local, not CI):** From `submodules/koku-ui` root: `npm run start:onprem:dev` then **`npm run test:cypress:live -w @koku-ui/koku-ui-onprem`** (**21** tests — `01`–`03` nav/load, `04` Storybook parity). Specs: `apps/koku-ui-onprem/cypress/e2e/live/`. If Cypress verify fails with `bad option: --no-sandbox`, unset `ELECTRON_RUN_AS_NODE` (set by some IDE sandboxes).

**Cluster (manual, oauth2-proxy):** Deployed tag matches record; in-pod `/rbac/plugin-manifest.json` **200**; manual Chrome for IAM nav behind SSO.

**Out of scope:** Cluster Cypress without auth; full Helm upgrade unblock; pixel-perfect SaaS chrome outside POC slice.

## Cluster redeploy note (2026-05-22)

IAM `/api/rbac/v1/*` calls require Envoy route `prefix: /api/rbac/` (FLPATH-4073). **Published** Helm repo chart **0.2.19** / **0.2.20-rc4** omit it; **`USE_LOCAL_CHART=true`** from `submodules/cost-onprem-chart` (`feat/flpath-4164-ui-rbac-nginx`, chart **0.2.20-rc5**) is required until a published release includes that template. Symptom without route: gateway access log **404** `response_flags=NR`, RBAC API pod healthy in-cluster.

## Nav diagnosis (2026-05-19, resolved)

**Symptoms (fixed):** IAM page freeze; sidebar toggle hang; cannot return to Overview; `Maximum update depth exceeded`.

**Root causes:** (A) federated `SkeletonTable` loop; (B) cross-app nav + IAM catch-all race; (C) unstable `useChrome` object identity.

**Fixes:** [rbac-ui-onprem webpack shims](../topics/rbac-ui-onprem-shims.md) (`useAppLink`, `LoaderPlaceholders`, PF `SkeletonTable*`, `component-groups` barrel); host full-page nav for cross-app; stable `useChrome` singleton; `remoteKey` on Scalprum; basename `/iam` on host router.

## Shim necessity (2026-06-01)

Ablation on cluster-backed **`start:onprem:dev`**: live Cypress **21/21** with **all** `src/shims/` webpack replacements disabled (including `component-groups` in `sharedModules`). **No** `Maximum update depth` console errors. Shims **not required for webpack-dev** at koku-ui `238a666c7` / upstream `b4ca3746`; **keep in tree** until a no-shim **production image + cluster SSO** gate passes (historical rc16 ThBase freeze was production nginx). Details: [rbac-ui-onprem-shims analysis](../topics/rbac-ui-onprem-shims.md#necessity-analysis-2026-06-01).

## Cluster deploy

| Item | Value |
|------|--------|
| **Image** | `quay.io/jkilzi/koku-ui-onprem:flpath-4164-rc25` (2026-06-01 in-pod manifest **200**) |
| **Cluster** | `<leased-cluster>`, namespace `cost-onprem` |
| **Build** | On-demand GHA — [koku-ui-onprem-cluster-image skill](../../.cursor/skills/koku-ui-onprem-cluster-image/SKILL.md) → `trigger-build.sh <tag>` ([wiki topic](../topics/onprem-ui-cluster-image.md)) |
| **Rollout** | Local Helm — `ui-image-values.local.yaml` + `rollout-ui-image.sh` (not GHA) |
| **Verify in pod** | `verify-ui-pod.sh` or `curl http://127.0.0.1:8080/rbac/plugin-manifest.json` → **200** |

**Quick alternative:** `oc set image deployment/cost-onprem-ui -n cost-onprem app=quay.io/<your-org>/koku-ui-onprem:<tag>` (bypasses Helm values; prefer skill rollout for durable `ui.app.image`).

## Visual compare

Evidence: [visual-compare/VISUAL_SIGNOFF.md](visual-compare/VISUAL_SIGNOFF.md), [visual-compare/cluster/](visual-compare/cluster/), [visual-compare/storybook/](visual-compare/storybook/).
