# Wiki log

Append-only timeline of wiki work. **Format:** each entry starts with `## [YYYY-MM-DD] type | Title` where `type` is one of `ingest`, `query`, `lint`, `update`, `bootstrap`.

## [2026-06-11] update | cost-onprem-chart install prefers local chart

User preference: default `USE_LOCAL_CHART=true` for install/upgrade (not upstream Helm repo). Rule [`.cursor/rules/cost-onprem-chart-install-local.mdc`](../.cursor/rules/cost-onprem-chart-install-local.mdc); skill + [demo-catalog-cost-onprem-install.md](entities/demo-catalog-cost-onprem-install.md) defaults updated.

## [2026-06-01] update | Remove root insights-rbac-ui submodule

Dropped workspace submodule `submodules/insights-rbac-ui`; upstream is vendored at `koku-ui/vendor/insights-rbac-ui`. Updated docs, constitution, and [topics/rbac-ui-onprem-vendor.md](topics/rbac-ui-onprem-vendor.md).

## [2026-06-01] update | PF shim removal manual verification pass

Human sign-off: IAM nav OK on local `start:onprem:dev` and cluster `flpath-4164-no-shim-rc1` (useAppLink-only). Gates closed for partial removal. [rbac-ui-onprem-shims.md](topics/rbac-ui-onprem-shims.md), [flpath-4164-rbac-mfe-poc.md](entities/flpath-4164-rbac-mfe-poc.md).

## [2026-06-01] update | rbac-ui-onprem PF shims removed; useAppLink kept

Partial shim removal on koku-ui `chore/remove-rbac-ui-onprem-shims` (`cbd4ac211`). Cluster `flpath-4164-no-shim-rc1` deployed; in-pod manifest **200**, no `OnpremIamSpinner` in bundles. Cypress **21/21** dev with useAppLink only; full removal fails `/iam/iam/...`. SSO manual nav pending. [rbac-ui-onprem-shims.md](topics/rbac-ui-onprem-shims.md).

## [2026-06-01] ingest | rbac-ui-onprem shim necessity ablation

Cluster-backed `start:onprem:dev` + live Cypress **21/21** with **all app shims disabled** (incl. shared `component-groups`); no depth errors. Verdicts on [topics/rbac-ui-onprem-shims.md](topics/rbac-ui-onprem-shims.md); keep shims until no-shim production/cluster gate. koku-ui `238a666c7`, upstream `b4ca3746`.

## [2026-05-31] ingest | Keycloak org-admin realm role

Wiki [topics/keycloak-org-admin-realm-role.md](topics/keycloak-org-admin-realm-role.md): assign `org-admin` via Admin Console or `deploy-rhbk.sh` + `jwtAuth.realmUsers.orgAdmin`; verify JWT and RBAC `is_org_admin` (My User Access `meta.count`).

## [2026-05-27] update | FLPATH-4164 chart PR 175 nginx on cluster

Helm upgrade with local chart `feat/flpath-4164-ui-rbac-nginx-pr` (PR #175 `/rbac/` location); image rc24 unchanged; `oc rollout restart` needed so UI pod picked up ConfigMap — `/rbac/plugin-manifest.json` returns **application/json**.

## [2026-05-27] update | FLPATH-4164 CI green + cluster rc24

koku-ui PR CI/Cypress pass after `submodules: recursive` in GHA. Built `quay.io/jkilzi/koku-ui-onprem:flpath-4164-rc24` (koku-ui `5ca533010`); Helm rollout cluster-f4rmt; `/rbac/plugin-manifest.json` **200**. Entity [flpath-4164-rbac-mfe-poc.md](entities/flpath-4164-rbac-mfe-poc.md).

## [2026-05-27] update | FLPATH-4164 branch cleanup (host + rbac README)

Removed unused `RBAC_ONPREM_REMOTE.publicPath`, legacy `/openshift/cost-management/rbac/*` redirect, merged Scalprum loading fallback; `rbac-ui-onprem` README links to `koku-ui-onprem` instead of workspace wiki. koku-ui `5a235d41f`; entity [flpath-4164-rbac-mfe-poc.md](entities/flpath-4164-rbac-mfe-poc.md).

## [2026-05-27] update | remove rbac-ui-onprem vendor.sh

Dropped `apps/rbac-ui-onprem/scripts/vendor.sh` and `npm run vendor`; bump is git submodule gitlink + `submodule update` + `npm install`. Wiki [topics/rbac-ui-onprem-vendor.md](topics/rbac-ui-onprem-vendor.md).

## [2026-05-27] update | vendor.sh reads .gitmodules gitlink (no REF)

`vendor.sh` syncs `vendor/insights-rbac-ui` from index/HEAD gitlink per `.gitmodules`; bump is git checkout + `git add` then `npm run vendor`. Wiki [topics/rbac-ui-onprem-vendor.md](topics/rbac-ui-onprem-vendor.md).

## [2026-05-27] update | rbac-ui-onprem vendor → git submodule

Replaced `vendor/manifest.json` + npm pack `.tgz` with `vendor/insights-rbac-ui` submodule and stable `file:../../vendor/insights-rbac-ui` devDependency; `vendor.sh` bumps via `REF=`; Containerfile sets `HUSKY=0`. Wiki [topics/rbac-ui-onprem-vendor.md](topics/rbac-ui-onprem-vendor.md).

## [2026-05-27] update | rbac-ui-onprem webpack-paths inlined

Removed `src/shims/webpack-paths.ts`; shim paths and `insightsRbacModuleReplacements` live in `webpack.config.ts`. Wiki [topics/rbac-ui-onprem-shims.md](topics/rbac-ui-onprem-shims.md).

## [2026-05-27] update | rbac-ui-onprem vendor → npm pack at koku-ui root

Replaced committed federated `dist/` with `vendor/manifest.json` + `vendor/insights-rbac-ui@<full-sha>.tgz` and `insights-rbac-frontend` `file:` devDependency; Containerfile builds RBAC like other MFEs. Removed `verify.sh`. Wiki [topics/rbac-ui-onprem-vendor.md](topics/rbac-ui-onprem-vendor.md).

## [2026-05-27] ingest | rbac-ui-onprem vendored remote (Konflux)

koku-ui: `npm run vendor:rbac-onprem` clones upstream @ ref to OS temp, webpack build → `vendor/insights-rbac-ui@<short>/dist/`; hermetic `npm ci` / Containerfile without `github:insights-rbac-ui`. Wiki [topics/rbac-ui-onprem-vendor.md](topics/rbac-ui-onprem-vendor.md).

## [2026-05-27] update | rbac-ui-onprem shims → wiki

Moved [`apps/rbac-ui-onprem/src/shims/README.md`](../../submodules/koku-ui/apps/rbac-ui-onprem/src/shims/README.md) to [topics/rbac-ui-onprem-shims.md](topics/rbac-ui-onprem-shims.md); linked from FLPATH-4164 entity; webpack comment no longer points at removed README.

## [2026-05-25] update | FLPATH-4164 PRs opened

koku-ui [project-koku/koku-ui#5207](https://github.com/project-koku/koku-ui/pull/5207); chart nginx [insights-onprem/cost-onprem-chart#175](https://github.com/insights-onprem/cost-onprem-chart/pull/175); SSA RFE [#176](https://github.com/insights-onprem/cost-onprem-chart/pull/176) split per plan. Pre-PR `build:onprem` + `verify:onprem` pass on `937935d13`.

## [2026-05-25] update | FLPATH-4164 local verification — 21/21 live Cypress

`build:onprem`, `verify:onprem`, `start:onprem:dev` (cluster-f4rmt), `test:cypress:live` **21/21** (~31s), `/api/rbac/v1/status/` **200** via localhost:9001. Cypress binary reinstalled; `test:cypress:live` unsets `ELECTRON_RUN_AS_NODE` for Cursor/sandbox. Entity page counts updated to 21 tests.

## [2026-05-22] update | Helm SSA fix — HELM_FORCE_CONFLICTS for UI rollout

`install-helm-chart.sh` supports `HELM_FORCE_CONFLICTS=true` (`--force-conflicts`); `rollout-ui-image.sh` enables by default. Verified Helm upgrade revision 11 on cluster after prior `oc set image` conflicts.

## [2026-05-22] ingest | cluster-f4rmt full stack redeploy (local chart 0.2.20-rc5)

`install-helm-chart.sh cleanup --complete` then `USE_LOCAL_CHART=true` + `ui-image-values.local.yaml` (rc22). Root cause of IAM Roles backend failure: published chart **0.2.19** Envoy ConfigMap lacked `/api/rbac/` (404 NR); local chart on `feat/flpath-4164-ui-rbac-nginx` includes FLPATH-4073 routes. `rbac-migrate` Completed; Keycloak JWT `verify` OK.

## [2026-05-22] update | Cluster UI rc22 — MUA PF addons + oc set image

Built `quay.io/jkilzi/koku-ui-onprem:flpath-4164-rc22` (GHA run 26304296887); Helm upgrade failed on SSA conflicts — deployed via `oc set image` on `cost-onprem-ui` app container.

## [2026-05-22] update | Load patternfly-addons.css on koku-ui-onprem host

Host `bootstrap.tsx` imports `@patternfly/patternfly/patternfly-addons.css` (same as insights-rbac-ui Storybook) so MUA `display-*-on-lg` utilities work; fixes dropdown+cards both visible without container-query hack.

## [2026-05-22] update | Remove onprem-iam-host MUA container-query CSS

Dropped `onprem-iam-host.css` and wrapper; IAM federated remote uses upstream PF viewport breakpoints only (`display-*-on-lg` at 992px). Stacked-cards band 824–991px was host-side effect of 768px container override.

## [2026-05-22] ingest | koku-ui-onprem cluster image skill + GHA build

Added `koku-ui-onprem-cluster-image` skill (GHA `workflow_dispatch` build → Quay; local Helm rollout), `.github/workflows/build-koku-ui-onprem.yml`, topic [onprem-ui-cluster-image.md](topics/onprem-ui-cluster-image.md); updated FLPATH-4164 cluster deploy and `AGENTS.md` routing.

## [2026-05-22] update | Flatten constitutions to constitutions/<submodule>.md

Moved five `constitutions/<name>/constitution.md` files to flat `constitutions/<name>.md`; updated `AGENTS.md`, workspace/submodule git rules, and `wiki/entities/sources-ui-reference.md`.

## [2026-05-22] update | public-push: GHAS optional (paid)

Clarified GitHub Secret Protection is optional/paid; gitleaks is required; private personal repos often lack security toggles until public — then **Settings → Security** appears.

## [2026-05-22] update | gitleaks GitHub Actions on main

`gh auth refresh -s workflow`; pushed `.github/workflows/gitleaks.yml` (`081c15f`); Actions run **success**. Pre-commit hook installed via `scripts/install-gitleaks-hook.sh`.

## [2026-05-22] update | History scrub + gitleaks gate (public push prep)

`git filter-repo` removed `pipelines/rpi` and `scripts/rpi` from all commits; redacted Quay/cluster/catalog strings. Added `.gitleaks.toml`, `scripts/gitleaks.workflow.yml.example`, `scripts/install-gitleaks-hook.sh`, [public-push.md](workspace/public-push.md). Force-pushed scrubbed `main` to `origin` (`207af79`); CI workflow deferred until `gh auth refresh -s workflow`.

## [2026-05-22] lint | Public repo hygiene (redact + gitignore)

Added [public-repo-hygiene.md](workspace/public-repo-hygiene.md); gitignore `wiki/**/visual-compare/cluster/`; redacted personal Quay, Demo Catalog URL, and workshop cluster hosts in entity pages, log, and plans; `visual-compare/README.md` for local PNG workflow.

## [2026-05-22] ingest | Remove RPI pipeline (`feat/no-pipelines`)

Migrated `flpath-4164` / `flpath-4180` pipeline outputs into wiki entities; `visual-compare/` → `wiki/entities/flpath-4164/`; renamed `rpi-verify-ui-acceptance` → `ui-verification-and-e2e`; deleted `pipelines/rpi/`, `rpi-pipeline.mdc`, `scripts/rpi/`; added `workspace-workflow.mdc`; rewrote `AGENTS.md`.

## [2026-05-22] update | Remove cluster IAM parity Cypress (koku-ui)

Deleted `04-iam-storybook-parity.cy.ts`, `cluster-live.ts`, `test:cypress:live:parity` / `:cluster`, and [`copy-flpath-4164-cluster-visual-compare.sh`](scripts/rpi/copy-flpath-4164-cluster-visual-compare.sh). Local live suite remains **`test:cypress:live`** (16 tests). Cluster visual evidence is manual; archived PNGs unchanged.

## [2026-05-22] update | cluster visual-compare copy script → workspace

Moved `copy-cluster-visual-compare.sh` out of `submodules/koku-ui/scripts/` to [`scripts/rpi/copy-flpath-4164-cluster-visual-compare.sh`](scripts/rpi/copy-flpath-4164-cluster-visual-compare.sh) — RPI sign-off glue belongs in superproject, not upstream koku-ui.

## [2026-05-22] update | copy-cluster-visual-compare DEST path

`koku-ui/scripts/copy-cluster-visual-compare.sh` used `../pipelines` from submodule root (wrote `submodules/pipelines/`); fixed to `../../pipelines` → workspace `pipelines/rpi/.../visual-compare/cluster/`. Removed accidental `submodules/pipelines/`.

## [2026-05-22] update | FLPATH-4164 OV iam.svg host static

`koku-ui-onprem`: vendored `iam.svg` + `CopyWebpackPlugin` → `/apps/frontend-assets/technology-icons/iam.svg`; Cypress `parity-overview` asserts icon load. [`VISUAL_SIGNOFF.md`](pipelines/rpi/v1/stages/40-verify/output/flpath-4164/visual-compare/VISUAL_SIGNOFF.md).

## [2026-05-21] update | FLPATH-4164 rc19 deploy + cluster parity E2E

Image `flpath-4164-rc19` on `<leased-cluster>`; `test:cypress:live:parity` **11/11**; refreshed `visual-compare/cluster/*.png`; [`VERIFICATION.md`](pipelines/rpi/v1/stages/40-verify/output/flpath-4164/VERIFICATION.md) updated.

## [2026-05-21] update | FLPATH-4164 Phase 9 visual parity implement (koku-ui)

`koku-ui@e8cc28355` on `feat/flpath-4164`: remove `TableView` webpack shim; add `onprem-iam-host.css` container queries for bundle cards. Workspace pins submodule; [`PLAN.md` Phase 9](pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md).

## [2026-05-21] update | FLPATH-4164 visual sign-off cleanup (rc18 POC shell)

Replaced `VISUAL_DIFF_CHECKLIST.md` with [`visual-compare/VISUAL_SIGNOFF.md`](pipelines/rpi/v1/stages/40-verify/output/flpath-4164/visual-compare/VISUAL_SIGNOFF.md); promoted round-2 cluster PNGs; stakeholder accepted IAM nav + five routes; Storybook table/bundle parity tracked as must-fix in intake.

## [2026-05-21] ingest | FLPATH-4164 Storybook vs rc18 visual diff

Local Storybook at `insights-rbac-ui@b4ca3746` vs cluster **rc18**; evidence under `pipelines/rpi/v1/stages/40-verify/output/flpath-4164/visual-compare/` (superseded by sign-off doc).

## [2026-05-21] update | FLPATH-4164 verify partial pass — MUA CSS blocker

Verify downgraded to **partial pass**: functional **rc18** + Cypress **16/16**, but **My User Access** CSS parity vs SaaS open. Added `VERIFICATION_INTAKE.md`, AC visual section, wiki entity.

## [2026-05-21] update | FLPATH-4164 verify stage — rc18, Cypress only

Refreshed `40-verify/output/flpath-4164/VERIFICATION.md` + `ACCEPTANCE_CRITERIA.md`: **rc18** deploy record, Playwright removed, Cypress **16/16** local gate.

## [2026-05-21] update | FLPATH-4164 rc18 — cluster UI (IAM nav)

`flpath-4164-rc18` on `<leased-cluster>` (`oc set image`); single-tree `build:onprem` pack; in-pod `/rbac/plugin-manifest.json` **200**. `ui-image-values.yaml` + IMPLEMENTATION_LOG + wiki entity.

## [2026-05-21] update | IAM nav `/iam` prefix regression tests

Cypress `03-iam-sidebar-navigation`: IAM-to-IAM hops assert full `/iam/...` pathnames and anchor hrefs; fix host nav to use `<a href>` not basename-relative `<Link>`. Live gate **16/16**.

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

Hybrid pack `flpath-4164-rc15` deployed on `<leased-cluster>`; local `verify:onprem-nav` 5/5 after restoring `useChrome` singleton (first rc15 pack missed it). Added `ACCEPTANCE_CRITERIA.md`; updated `VERIFICATION.md`.

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
Personal Quay `koku-ui-onprem:flpath-4164-rc2` on `<leased-cluster>`; `/rbac/` manifest 200 in pod; `ui-image-values.yaml` + pull secret `<quay-pull-secret>`.

## [2026-05-18] update | FLPATH-4164 checkpoint (Phases 3, 6, verify)

Host `FlagProvider`, `Containerfile` `./rbac`, plan drift fix; `setup-onprem-env.sh` works with restored metrics CR; `VERIFICATION.md` partial pass.

## [2026-05-17] update | FLPATH-4164 Phase 1 verify + Phase 2 host

`verify-onprem-rbac.sh` finds `Iam` bundle under `dist/exposed-./`; `koku-ui-onprem` static `/rbac/`, `/api/rbac` proxy, `/iam/*` route + nav; PLAN/IMPLEMENTATION_LOG + `wiki/entities/flpath-4164-rbac-mfe-poc.md`.

## [2026-06-17] update | OKF v0.1 frontmatter + subdirectory indexes

Added OKF-conformant YAML frontmatter (`type`, `title`, `description`, `tags`, `timestamp`) to all 18 concept documents. Created `wiki/entities/index.md`, `wiki/topics/index.md`, `wiki/workspace/index.md` for progressive disclosure. Updated `llm-wiki.mdc` to require frontmatter on all new pages going forward. Root `wiki/index.md` section headings now link to subdirectory indexes.

## [2026-06-17] update | setup-onprem-env.sh CMMO fallback + eza hang RCA

`setup-onprem-env.sh` rewritten: CMMO discovery kept as primary; new fallback reads API URL from `cost-onprem-api` route, token URL from `cost-onprem-keycloak-debug` CM, and credentials from `keycloak-client-secret-cost-management-operator` (keycloak ns) — no CMMO required. eza hang root cause identified: blocks on `read(stdin)` when Cursor shell passes a unix socket; workaround is to avoid `ls`/`eza` in agent Shell calls and use full script paths to skip zsh chpwd hooks.

## [2026-06-17] ingest | COST-7671 RBAC UX alignment — Figma board analysis

Created `wiki/entities/cost-7671-rbac-ui-ux-alignment.md`: extracted UX requirements from 18 Figma board images (file UFM3q6rv3W5lhw0JhmUnl9). Key requirements: cost-scoped role/permission filter on Users detail, Application column, workspace hierarchy screens. Updated entities/index.md and wiki/index.md.

## [2026-06-18] update | start:onprem:auth — oauth2-proxy dev mode

Added `scripts/start-onprem-auth.mts` (TypeScript ESM, zero external deps, runs via `node --experimental-strip-types`) and three `webpack.config.ts` changes to `submodules/koku-ui` to support a new `npm run start:onprem:auth` dev mode that replicates production OIDC auth locally. Script reads `oauth2-proxy` image and args from the live cluster Deployment at runtime (single source of truth). Secrets passed as bare `-e KEY` container flags (never in CLI args). Implemented logging helpers, SRP step functions, and a `try/finally` cleanup strategy.

Key design decisions:
- Cluster Deployment is the single source of truth for `oauth2-proxy` flags/image — script strips cluster-only flags and injects local overrides at runtime.
- Secrets passed as container env vars (`OAUTH2_PROXY_CLIENT_ID`, `OAUTH2_PROXY_CLIENT_SECRET`, `OAUTH2_PROXY_COOKIE_SECRET`), never CLI args.
- `OAUTH2_PROXY_MODE=true` env var gates `TokenRefresher`, `/api/me` header trust, proxy header injection, and `/logout` redirect in `webpack.config.ts`.
- `oauth2-proxy` runs in a Podman/Docker container — no binary install needed; runtime auto-detected.
- Trap-based cleanup kills webpack PID, stops the container, and removes the temp CA cert file on EXIT/INT/TERM.
- Updated `apps/koku-ui-onprem/README.md`, `package.json` (`start:onprem:auth`), and `.cursor/rules/koku-ui-onprem-dev-server.mdc`.
