# Wiki log

Append-only timeline of wiki work. **Format:** each entry starts with `## [YYYY-MM-DD] type | Title` where `type` is one of `ingest`, `query`, `lint`, `update`, `bootstrap`.

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

Scope `cost-onprem-chart__flpath-3424`: `SCOPE.md`, `RESEARCH.md`, `QUESTIONS.md` under `pipelines/rpi/v1/stages/10-research/output/` (on-prem RBAC UI vs current ENHANCED_ORG_ADMIN + `koku-ui/insights-rbac-ui` tree).

## [2026-05-10] ingest | Demo Catalog cost-onprem install wiki

Added `wiki/entities/demo-catalog-cost-onprem-install.md` (SNO lease, pre-scoped projects, Keycloak, defaults, S3→Kafka→UWM→install order, Kafka vs chart vs script nuances); indexed in `wiki/index.md`; linked from `wiki/workspace/overview.md`.

## [2026-05-10] update | RHBK + cost-onprem install skill

Expanded `wiki/entities/demo-catalog-cost-onprem-install.md` with `deploy-rhbk.sh` section, empty-`keycloak`-project vs RHBK detection, revised install order. Added `.cursor/skills/cost-onprem-chart-install/SKILL.md`; routing in `AGENTS.md` and `wiki/workspace/overview.md`; refreshed `wiki/index.md` entity summary.
