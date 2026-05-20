# FLPATH-4164 — RBAC UI on-prem MFE (POC)

**Jira:** [FLPATH-4164](https://redhat.atlassian.net/browse/FLPATH-4164) (*POC: RBAC UI as on-prem MFE (koku-ui-onprem + chart RBAC API)*). **Parent:** [FLPATH-3424](https://redhat.atlassian.net/browse/FLPATH-3424).

**Pipeline SoT:** [`pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md`](../../pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md) — consolidated scope, research digest, phases 0–8 (nav fix). Facts-only research: [`RESEARCH.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4164/RESEARCH.md).

**Prerequisite (closed):** [FLPATH-4180](https://redhat.atlassian.net/browse/FLPATH-4180) — see [`flpath-4180-fec-rbac-mfe.md`](flpath-4180-fec-rbac-mfe.md).

**UX vision (product):** On **FLPATH-4164**, Jira **comment +** `ux-vision-my-user-access-cost-onprem.png` (Identity and Access Management shell, **My User Access**); session context: [FLPATH-3424 focused comment](https://redhat.atlassian.net/browse/FLPATH-3424?focusedCommentId=16901888).

## Implementation status (2026-05-21)

| Layer | State |
|-------|--------|
| Remote | `apps/rbac-ui-onprem` — `insightsRbac`, `/rbac/`, `./Iam` (lazy entry); `RBACHook` shim; `npm run verify:onprem` ✅ |
| Host e2e | `apps/koku-ui-onprem/cypress/e2e/live/` — **`test:cypress:live`** (**16/16**) after **`start:onprem:dev`**; **not CI**; Playwright removed |
| Host | static `/rbac/`, proxy `/api/rbac`, `/iam/*`, `FlagProvider` under `ScalprumProvider`, chrome stub |
| Chart | nginx `location /rbac/` — branch `feat/flpath-4164-ui-rbac-nginx` in `cost-onprem-chart` |
| Cluster image | `quay.io/<your-org>/koku-ui-onprem:flpath-4164-rc18` (<leased-cluster>; IAM NavExpandable + `/iam` prefix nav) |
| Branch | `submodules/koku-ui` → `feat/flpath-4164` |
| Verified | [`VERIFICATION.md`](../../pipelines/rpi/v1/stages/40-verify/output/flpath-4164/VERIFICATION.md) **Partial pass** — rc18 functional; **MUA CSS vs SaaS open** (blocker) |
| Host nav | **`NavExpandable` “Identity and Access Management”** after Settings → Overview, My User Access, Users, Roles, Groups — [`ACCEPTANCE_CRITERIA.md`](../../pipelines/rpi/v1/stages/40-verify/output/flpath-4164/ACCEPTANCE_CRITERIA.md) |
| CSS / layout | **Open** — `/iam/my-user-access` differs from SaaS; intake [`VERIFICATION_INTAKE.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4164/VERIFICATION_INTAKE.md); layers **H** host / **C** chrome / **M** MUA body |
| Next | Collect SaaS vs on-prem evidence → research refresh → plan CSS phase → implement → re-verify |
