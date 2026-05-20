# FLPATH-4164 — RBAC UI on-prem MFE (POC)

**Jira:** [FLPATH-4164](https://redhat.atlassian.net/browse/FLPATH-4164) (*POC: RBAC UI as on-prem MFE (koku-ui-onprem + chart RBAC API)*). **Parent:** [FLPATH-3424](https://redhat.atlassian.net/browse/FLPATH-3424).

**Pipeline SoT:** [`pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md`](../../pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md) — consolidated scope, research digest, phases 0–8 (nav fix). Facts-only research: [`RESEARCH.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4164/RESEARCH.md).

**Prerequisite (closed):** [FLPATH-4180](https://redhat.atlassian.net/browse/FLPATH-4180) — see [`flpath-4180-fec-rbac-mfe.md`](flpath-4180-fec-rbac-mfe.md).

**UX vision (product):** On **FLPATH-4164**, Jira **comment +** `ux-vision-my-user-access-cost-onprem.png` (Identity and Access Management shell, **My User Access**); session context: [FLPATH-3424 focused comment](https://redhat.atlassian.net/browse/FLPATH-3424?focusedCommentId=16901888).

## Implementation status (2026-05-19)

| Layer | State |
|-------|--------|
| Remote | `apps/rbac-ui-onprem` — `insightsRbac`, `/rbac/`, `./Iam` (lazy entry); `RBACHook` shim; `npm run verify:onprem` ✅ |
| Host e2e | `apps/koku-ui-onprem/cypress/e2e/live/` — Cypress smoke via **`test:cypress:live`** after **`start:onprem:dev`**; **not CI** — [onprem-playwright-e2e](../topics/onprem-playwright-e2e.md) |
| Host | static `/rbac/`, proxy `/api/rbac`, `/iam/*`, `FlagProvider` under `ScalprumProvider`, chrome stub |
| Chart | nginx `location /rbac/` — branch `feat/flpath-4164-ui-rbac-nginx` in `cost-onprem-chart` |
| Cluster image | `quay.io/<your-org>/koku-ui-onprem:flpath-4164-rc16` (cluster); **rc17** = single-tree pack after unified shims (see IMPLEMENTATION_LOG **2026-05-20**) |
| Branch | `submodules/koku-ui` → `feat/flpath-4164` |
| Verified | Overview + **My User Access** on cluster; local Cypress **13/13** with `start:onprem:dev` + `test:cypress:live` (not CI) |
| Host nav | **`NavExpandable` “Identity and Access Management”** after Settings → Overview, My User Access, Users, Roles, Groups; `basename=/iam`, Phase 8 shims — [`ACCEPTANCE_CRITERIA.md`](../../pipelines/rpi/v1/stages/40-verify/output/flpath-4164/ACCEPTANCE_CRITERIA.md) |
| Next | Cluster image with nav parity; manual SSO spot-check; PRs (koku-ui + chart) |
