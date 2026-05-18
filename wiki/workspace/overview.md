# Workspace overview

This repository is a **Cost Management** meta-workspace: orchestration (e.g. RPI pipeline under `pipelines/rpi/`), per-submodule mission under `constitutions/`, and checkout copies under `submodules/`.

## Wiki role

This wiki is the **compounding layer**: durable, cross-cutting knowledge that should not be re-derived every session. Scoped pipeline artifacts live under `pipelines/rpi/v1/stages/*/output/<scope>/`; submodule upstream truth lives in `submodules/<name>/`. The wiki links and summarizes what matters **across** those boundaries.

## Jira without a public repo

Research and plans often live under `pipelines/rpi/…` in this **private** meta-repo. **Jira comments that only list file paths are not enough** for most readers. See **[Jira handoff when this workspace is not published](jira-handoff-without-public-repo.md)** for the recommended pattern (self-contained Jira text + carry-forward into the implementation ticket; optional attachments).

**Issue links:** To replace **Blocks** with **Related** (or any type change), Jira has no in-place edit — use **`jira issue unlink`** then **`jira issue link`** — see **[Jira CLI: change issue link type](jira-cli-issue-links.md)**.

## Related

- [Entry index](../index.md)
- [Demo Catalog + cost-onprem install](../entities/demo-catalog-cost-onprem-install.md) — leased OpenShift, SNO, install streamlining (incl. RHBK / `deploy-rhbk.sh`)
- [cost-onprem-chart install skill](../../.cursor/skills/cost-onprem-chart-install/SKILL.md) — portable OpenShift install order for the submodule chart
- [AGENTS.md](../../AGENTS.md) — identity, purpose, folder map, routing, triggers
- [`.cursor/rules/rpi-pipeline.mdc`](../../.cursor/rules/rpi-pipeline.mdc) — RPI v1 index to `pipelines/rpi/` layered `SPEC.md` files and `@rpi-status`
- [RPI verify: acceptance criteria + UI E2E](../topics/rpi-verify-ui-acceptance.md) — `40-verify` presents **`ACCEPTANCE_CRITERIA.md`** before running checks; UI-modifying streams exercise the app end-to-end
- [`.cursor/rules/llm-wiki.mdc`](../../.cursor/rules/llm-wiki.mdc) — wiki layers, ingest/query/lint ops, `@wiki-lint` procedure
- Submodule Git: [`.cursor/rules/submodule-git-workflow.mdc`](../../.cursor/rules/submodule-git-workflow.mdc)
