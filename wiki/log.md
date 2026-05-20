# Wiki log

Append-only timeline of wiki work. **Format:** each entry starts with `## [YYYY-MM-DD] type | Title` where `type` is one of `ingest`, `query`, `lint`, `update`, `bootstrap`.

## [2026-05-21] update | IAM NavExpandable host nav (Stefan UX)

Host `AppLayout`: `NavExpandable` “Identity and Access Management” with Overview, My User Access, Users, Roles, Groups; `onpremRemotes.ts` `IAM_NAV_ITEMS`; Cypress `03-iam-sidebar-navigation.cy.ts` (**13/13** live). AC + PLAN + wiki entity updated. No `insights-rbac-ui` edits.

## [2026-05-21] update | Rename live Cypress script to test:cypress:live

Replaced `verify:onprem-e2e` with `test:cypress:live` in koku-ui package scripts and docs; live gate uses `--config specPattern` (Cypress 15).

## [2026-05-20] update | Cypress mocked → integration folder name

Renamed `cypress/e2e/mocked/` to `e2e/integration/` (mocked APIs); `e2e/live/` remains real e2e gate.

## [2026-05-20] update | Cypress live e2e replaces Playwright

`cypress/e2e/live/` (01-app-loads, 02-host-iam-navigation) + `mocked/` move; single `test:cypress:live`; removed Playwright and `e2e/` bash scripts.

## [2026-05-20] update | On-prem Playwright e2e not for CI

Documented: `test:cypress:live` is local-only after `start:onprem:dev` (real cluster APIs); CI uses `verify:onprem` only. Wiki topic `onprem-playwright-e2e.md`; e2e README, host README, pipeline AC, RPI verify topic.

## [2026-05-20] update | FLPATH-4164 Playwright e2e on koku-ui-onprem

Moved `apps/rbac-ui-onprem/e2e/` → `apps/koku-ui-onprem/e2e/`; Playwright devDependency on host app (removed from koku-ui root). `verify:onprem-e2e` / `verify:onprem-nav` run via `@koku-ui/koku-ui-onprem`. Cypress specs untouched.

## [2026-05-20] update | FLPATH-4164 AC only in RPI 40-verify

Removed `apps/rbac-ui-onprem/e2e/ACCEPTANCE_CRITERIA.md`; consolidated checklist in `pipelines/rpi/v1/stages/40-verify/output/flpath-4164/ACCEPTANCE_CRITERIA.md` (UI-modifying gate, preconditions, 3/3 + 5/5). E2E README points to pipeline SoT.

## [2026-05-20] update | FLPATH-4164 rbac-ui-onprem e2e folder

Playwright moved to `apps/rbac-ui-onprem/e2e/`; `verify:onprem-e2e` (3 loads + 5 nav) **8/8** local; acceptance criteria in e2e + pipeline `40-verify`.

## [2026-05-20] update | FLPATH-4164 unified onprem-cloud-deps (lazy Unleash)

Bisect: HCCM TDZ from module-level `parseEnabledFlags()` in feat `unleash/proxy-client-react.ts`. Lazy init + single webpack alias tree; removed dual-shim sync (`sync-onprem-shims-main.sh`, `onprem-shim-roots.cjs`). Pack recipe → single `npm run build:onprem` (**rc17**).

## [2026-05-19] update | FLPATH-4164 rc16 — cluster IAM freeze (SkeletonTableBody barrel)

RolesTable imported SkeletonTableBody from package root; shared PF chunk 6658 on cluster caused ThBase loop. Barrel shim + drop component-groups from rbac sharedModules → `flpath-4164-rc16` deployed.

## [2026-05-19] update | FLPATH-4164 rc15 ship + verify closeout

Hybrid pack `flpath-4164-rc15` deployed on <leased-cluster>; local `verify:onprem-nav` 5/5 after restoring `useChrome` singleton (first rc15 pack missed it). Added `ACCEPTANCE_CRITERIA.md`; updated `VERIFICATION.md`.

## [2026-05-19] update | FLPATH-4164 research consolidated into PLAN.md

`10-research` (SCOPE, RESEARCH, QUESTIONS) + `NAV-DIAGNOSIS` merged into [`pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md`](../../pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md) § Research digest + Phase 8; research files retain facts with pointers.

## [2026-05-19] update | FLPATH-4164 IAM blank page — stable useChrome

On-prem `useChrome` returned a new object every call → `useIdentity`/`IamV1` maximum update depth; fixed singleton API. With `useAppLink` shim + host basename, `verify:onprem-nav` 5/5.

## [2026-05-19] update | FLPATH-4164 IAM nav fix (MemoryRouter + shims)

`rbac-ui-onprem`: MemoryRouter `basename=/iam`; PF skeleton/table shims; host Phase 2 nav. `verify:onprem-nav` 5/5 local.

## [2026-05-19] ingest | FLPATH-4164 IAM nav root-cause diagnosis

Playwright: IAM route freezes main thread (`Maximum update depth` in SkeletonTable/AppPlaceholder); sidebar toggle hangs on `/iam/*` but not on cost. Plan: [`pipelines/rpi/v1/stages/20-plan/output/flpath-4164/NAV-DIAGNOSIS.md`](../../pipelines/rpi/v1/stages/20-plan/output/flpath-4164/NAV-DIAGNOSIS.md).

## [2026-05-19] update | FLPATH-4164 Optimizations↔IAM nav freeze

Host `NavItem`: full page navigation when leaving `/iam/*` for cost routes (IAM catch-all blocked SPA `Link`); reverted sticky remote mount.

## [2026-05-19] update | FLPATH-4164 rc14 verify + hybrid pack recipe

Cluster **Overview + IAM** pass on `flpath-4164-rc14`; `IMPLEMENTATION_LOG.md` hybrid amd64 pack steps; `VERIFICATION.md` and wiki entity updated; koku-ui lazy IAM entry + rbac webpack fixes committed.

## [2026-05-18] ingest | RPI verify UI acceptance gate

`40-verify` / `20-plan` / `pipelines/rpi/SPEC.md`: **`ACCEPTANCE_CRITERIA.md`** human gate before execution; UI streams require E2E exercise; wiki topic `topics/rpi-verify-ui-acceptance.md`.

## [2026-05-18] update | RHBK CSV remediation script

Added `rhbk-fix-csv-too-many-operatorgroups.sh` (`verify` / `fix`) under cost-onprem-chart-install skill; wiki + SKILL.md updated.

## [2026-05-18] ingest | RHBK CSV TooManyOperatorGroups known issue

Documented duplicate OperatorGroup → CSV Failed; non-disruptive fix (delete `rhbk-operator-group`, keep `keycloak-og`); wiki entity + demo-catalog cross-link.

## [2026-05-18] update | sources-ui reference submodule

Added `submodules/sources-ui` (RedHatInsights/sources-ui); constitution + wiki entity; C4 repo map notes **sources-api-go** as SaaS backend (not a submodule).

## [2026-05-18] ingest | C4 architecture docs (workspace docs/)

Added workspace `docs/architecture/c4/` (C4 context, containers, Koku/UI components, data flows, repository map); `docs/README.md` index; wiki Concepts link.

## [2026-05-14] ingest | Jira CLI: change issue link type (unlink + link)

Added `wiki/workspace/jira-cli-issue-links.md` (Blocks → Related for **4180**/**4164**); index row; `flpath-4180` entity Jira line updated to match live link.

## [2026-05-14] update | FLPATH-4164 Phase 1 rbac-ui-onprem wrapper (koku-ui)

`apps/rbac-ui-onprem` + `verify:onprem` / `rbac-ui.version.json`; PLAN rewritten for wrapper model (no upstream RBAC edits); first `build:onprem` produces `insightsRbac` manifest.

## [2026-05-14] update | wiki index + entity FLPATH-4164

Added `wiki/entities/flpath-4164-rbac-mfe-poc.md` and index row (MFE POC + UX vision pointer).

## [2026-05-14] update | FLPATH-4164 research/plan — 4180 complete + UX mock

Refreshed `flpath-4164/RESEARCH.md` (4180 prerequisite **closed**, **UX vision** § + Jira links; fixed `20-plan` relative links); `flpath-4164/PLAN.md` (UX reference, Phase 0/2 nav + success); `flpath-4164/SCOPE.md`; `flpath-4180/RESEARCH.md` Jira status row; `wiki/entities/flpath-4180-fec-rbac-mfe.md` (closed + screenshot pointer).

## [2026-05-14] update | insights-rbac-ui constitution + AGENTS tree

Added `constitutions/insights-rbac-ui/constitution.md`; listed `insights-rbac-ui` under `constitutions/` and `submodules/` in `AGENTS.md`.

## [2026-05-14] update | RPI non-code terminal artifacts + spec (flpath-4180)

Added `30-implement/output/flpath-4180/IMPLEMENTATION_LOG.md` and `40-verify/output/flpath-4180/VERIFICATION.md`; `30-implement` / `40-verify` / `pipelines/rpi/SPEC.md` document Jira/wiki-only delivery; `flpath-4180/PLAN.md` handoff links.

## [2026-05-14] update | FLPATH-4164 Jira carry-forward + scope/PLAN handoff

Digest comment on **FLPATH-4164** (4180 conclusions); `flpath-4164/SCOPE.md` prerequisite note; `flpath-4180/PLAN.md` handoff line.

## [2026-05-14] ingest | Jira handoff without public repo

Added `wiki/workspace/jira-handoff-without-public-repo.md`; linked from `wiki/workspace/overview.md`, `wiki/index.md`, and `wiki/entities/flpath-4180-fec-rbac-mfe.md` (paste summaries + carry-forward to implementation tickets).

## [2026-05-14] update | FLPATH-4180 Jira closeout (RPI plan)

Jira **FLPATH-4180** commented with RPI artifact paths; transitioned **Closed** / resolution **Done**; `flpath-4180/PLAN.md` closeout checkboxes marked.

## [2026-05-14] update | RPI 20-plan FLPATH-4164 + 4180

Added `pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md` (MFE POC phases 0–7, FACTS) and `flpath-4180/PLAN.md` (research closeout); refreshed `flpath-4164/RESEARCH.md` FAR pointer to **`30-implement`**.

## [2026-05-14] update | FLPATH-4180 QUESTIONS resolved (insights-rbac-ui submodule)

`flpath-4180/QUESTIONS.md`: no **ExtensionsPlugin** in `fec.config.js`; enumerated **`useChrome`** APIs + **RBACHook** / Unleash; shell-only **`Route`+`ScalprumComponent`** compatible with RBAC **`Routing.tsx`**. `RESEARCH.md` + wiki entity takeaway updated.

## [2026-05-14] ingest | RPI 10-reresearch FLPATH-4180 (FEC vs on-prem MFE)

Bootstrap `pipelines/rpi/v1/stages/10-research/output/flpath-4180/` (`SCOPE.md`, `RESEARCH.md`, `QUESTIONS.md`): `ExtensionsPlugin` / extension types from frontend-components fed docs vs `DynamicRemotePlugin` + Scalprum in `koku-ui`; wiki entity page + index row.

## [2026-05-12] ingest | FLPATH-4164 QUESTIONS + FLPATH-4180 dependency

Recorded stakeholder answers in `flpath-4164/QUESTIONS.md` (full-surface POC, no insights-rbac-ui edits; chart `main` + branch `feat/flpath-4164`); added **FLPATH-4180** FEC/extension-points prerequisite to `RESEARCH.md` / `SCOPE.md`; linked **FLPATH-4180 Blocks FLPATH-4164** in Jira.

## [2026-05-12] ingest | FLPATH-4164 research resync (Jira MFE ticket)

Refreshed `pipelines/rpi/v1/stages/10-research/output/flpath-4164/RESEARCH.md`, `SCOPE.md`, `QUESTIONS.md` from current Jira (Goal/Context/AC, **FLPATH-4073**, out-of-scope standalone nginx); archived superseded container-only wording; marked URL/API/Quay questions resolved.

## [2026-05-12] update | RPI scope dirs aligned to ticket-id default

Renamed `pipelines/rpi/v1/stages/10-research/output/cost-onprem-chart__flpath-3424` → `flpath-3424` and `cost-onprem-chart__flpath-4164` → `flpath-4164`; updated `SCOPE.md` / `RESEARCH.md` / `QUESTIONS.md` scope keys and cross-links; refreshed prior `wiki/log.md` path references; generalized legacy-scope wording in `pipelines/rpi/SPEC.md`.

## [2026-05-12] update | Remove constitution trackers from workspace contract

Dropped `constitutions/*/tracker.md`, the `constitutions-tracker-format` skill, and pipeline/RPI references; work streams stay under `pipelines/rpi/v1/stages/*/output/<scope>/` and `submodule-git-workflow.mdc` remains the submodule Git SoT.

## [2026-05-12] update | git-submodules-status skill (UC1–UC3)

Rewrote `.cursor/skills/git-submodules-status/`: `references/config.json` (+ JSON Schema `config.schema.json`, gitignored data file), script modes `--show` / `--fix-print` / `--fix-apply`; upstream name per submodule only; drift = local default branch vs `refs/remotes/<upstream>/<default>` (not HEAD).

## [2026-05-11] update | FLPATH-4164 MFE pattern (koku-ui-hccm → koku-ui-onprem)

Expanded `pipelines/rpi/v1/stages/10-research/output/flpath-4164/RESEARCH.md` with codebase-grounded Scalprum/DynamicRemotePlugin/host checklist for embedding insights-rbac-ui vs sibling nginx UI.

## [2026-05-11] ingest | RPI 10-research bootstrap FLPATH-4164

Scope `flpath-4164`: `SCOPE.md`, `RESEARCH.md`, `QUESTIONS.md` under `pipelines/rpi/v1/stages/10-research/output/` (RBAC UI container POC vs chart `/api/rbac/` routing and FLPATH-3424 linkage).

## [2026-05-10] ingest | FLPATH-3424 QUESTIONS.md answers

Recorded stakeholder decisions in `pipelines/rpi/v1/stages/10-research/output/flpath-3424/QUESTIONS.md`; added **Stakeholder decisions** table to `RESEARCH.md` (MFE in koku-ui-onprem, RBAC API chart commit, shared Keycloak realm; FLPATH-4121/4152/4164 pointers).

## [2026-05-07] bootstrap | Initial Karpathy-style scaffold

Added `index.md`, `log.md`, `workspace/overview.md`, `raw/README.md`; Cursor rule `llm-wiki.mdc` for proactive maintenance; extended `AGENTS.md` with wiki schema.

## [2026-05-10] update | Slim AGENTS.md; add docs/

Moved wiki schema, submodule Git workflow, and `@wiki-lint` steps into `docs/*.md`; `AGENTS.md` now five sections only. Cross-links updated in `llm-wiki.mdc` and `wiki/workspace/overview.md`.

## [2026-05-10] update | Submodule Git workflow Cursor rule

Added project `.cursor/rules/submodule-git-workflow.mdc` (applies on `submodules/**`); routing in `AGENTS.md` points to the rule beside `docs/submodule-git-workflow.md`. Repointed normative link in `docs/submodule-git-workflow.md` to `constitutions/.cursor/skills/constitutions-tracker-format/SKILL.md`.

## [2026-05-10] update | Submodule Git workflow centralized in rule

Removed `docs/submodule-git-workflow.md`; agent-facing workflow lives only in `.cursor/rules/submodule-git-workflow.mdc`. Updated `AGENTS.md` routing, `pipelines/rpi/v1/stages/30-implement/CONTEXT.md`, and `wiki/workspace/overview.md` links.

## [2026-05-10] update | LLM wiki layers doc merged into rule

Removed `docs/llm-wiki-in-this-workspace.md`; layers table and operations at-a-glance live in `.cursor/rules/llm-wiki.mdc`. Updated `AGENTS.md` and `wiki/workspace/overview.md` links.

## [2026-05-10] update | constitutions-tracker-format skill at repo `.cursor/skills`

Moved `constitutions-tracker-format` from `constitutions/.cursor/skills/` to `.cursor/skills/constitutions-tracker-format/`; frontmatter `paths: constitutions/**` scopes it to work under `constitutions/`. Tracker and `submodule-git-workflow.mdc` links updated.

## [2026-05-10] update | `@wiki-lint` trigger merged into llm-wiki rule

Removed `docs/trigger-wiki-lint.md`; `@wiki-lint` steps live under **Lint** in `.cursor/rules/llm-wiki.mdc`. Updated `AGENTS.md`, `wiki/workspace/overview.md`, and `wiki/index.md` links; dropped `docs/` from `AGENTS.md` folder map.

## [2026-05-10] update | RPI pipeline Cursor rule (indexed)

Added `.cursor/rules/rpi-pipeline.mdc` (`alwaysApply`): indexes `pipelines/rpi/CONTEXT.md` and per-stage `CONTEXT.md` without inlining them. Updated `AGENTS.md` routing/triggers, `pipelines/rpi/CONTEXT.md` (**Cursor (agents)**), and `wiki/workspace/overview.md`.

## [2026-05-10] update | Pipeline CONTEXT.md → SPEC.md

Renamed `pipelines/rpi/CONTEXT.md` and each `v1/stages/*/CONTEXT.md` to **`SPEC.md`**; updated `pipelines/rpi/SPEC.md` wording (ICM paragraph, future pipelines path), `.cursor/rules/rpi-pipeline.mdc`, `AGENTS.md`, and `wiki/workspace/overview.md`.

## [2026-05-10] ingest | RPI 10-research bootstrap FLPATH-3424

Scope `flpath-3424`: `SCOPE.md`, `RESEARCH.md`, `QUESTIONS.md` under `pipelines/rpi/v1/stages/10-research/output/` (on-prem RBAC UI vs current ENHANCED_ORG_ADMIN + `koku-ui/insights-rbac-ui` tree).

## [2026-05-10] ingest | Demo Catalog cost-onprem install wiki

Added `wiki/entities/demo-catalog-cost-onprem-install.md` (SNO lease, pre-scoped projects, Keycloak, defaults, S3→Kafka→UWM→install order, Kafka vs chart vs script nuances); indexed in `wiki/index.md`; linked from `wiki/workspace/overview.md`.

## [2026-05-10] update | RHBK + cost-onprem install skill

Expanded `wiki/entities/demo-catalog-cost-onprem-install.md` with `deploy-rhbk.sh` section, empty-`keycloak`-project vs RHBK detection, revised install order. Added `.cursor/skills/cost-onprem-chart-install/SKILL.md`; routing in `AGENTS.md` and `wiki/workspace/overview.md`; refreshed `wiki/index.md` entity summary.

## [2026-05-10] update | UI login bounce (Envoy JWT) doc

Documented post-Keycloak “bounce to login” as Envoy/Lua **401** when `org_id` / `account_number` missing from access token; added debug steps and RBAC/hooks note to `wiki/entities/demo-catalog-cost-onprem-install.md` and `.cursor/skills/cost-onprem-chart-install/SKILL.md`; index entity summary tweaked.

## [2026-05-10] update | Keycloak declarative profile JWT workaround

Added `wiki/entities/known-issue-keycloak-declarative-profile-jwt.md`, skill script `.cursor/skills/cost-onprem-chart-install/scripts/keycloak-fix-org-jwt-claims.sh` (`verify`/`fix`), **Known issue** + install-step row in `SKILL.md`; cross-links in `wiki/index.md` and `wiki/entities/demo-catalog-cost-onprem-install.md`.

## [2026-05-18] update | FLPATH-4164 cluster UI image (personal Quay rc2)
Personal Quay `koku-ui-onprem:flpath-4164-rc2` on <leased-cluster>; `/rbac/` manifest 200 in pod; `ui-image-values.yaml` + pull secret `<quay-pull-secret>`.

## [2026-05-18] update | FLPATH-4164 checkpoint (Phases 3, 6, verify)

Host `FlagProvider`, `Containerfile` `./rbac`, plan drift fix; `setup-onprem-env.sh` works with restored metrics CR; `VERIFICATION.md` partial pass.

## [2026-05-17] update | FLPATH-4164 Phase 1 verify + Phase 2 host

`verify-onprem-rbac.sh` finds `Iam` bundle under `dist/exposed-./`; `koku-ui-onprem` static `/rbac/`, `/api/rbac` proxy, `/iam/*` route + nav; PLAN/IMPLEMENTATION_LOG + `wiki/entities/flpath-4164-rbac-mfe-poc.md`.
