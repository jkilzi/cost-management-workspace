# FLPATH-4180 — FEC extension points vs on-prem RBAC MFE

**Jira:** [FLPATH-4180](https://redhat.atlassian.net/browse/FLPATH-4180) (*Research FEC extension points for embedding/delivering RBAC UI*). **Blocks** [FLPATH-4164](https://redhat.atlassian.net/browse/FLPATH-4164).

**Pipeline SoT (git checkout only):** [`pipelines/rpi/v1/stages/10-research/output/flpath-4180/RESEARCH.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4180/RESEARCH.md) (facts, citations, recommendation). **20-plan closeout:** [`pipelines/rpi/v1/stages/20-plan/output/flpath-4180/PLAN.md`](../../pipelines/rpi/v1/stages/20-plan/output/flpath-4180/PLAN.md). **30-implement / 40-verify (non-code):** [`IMPLEMENTATION_LOG.md`](../../pipelines/rpi/v1/stages/30-implement/output/flpath-4180/IMPLEMENTATION_LOG.md) · [`VERIFICATION.md`](../../pipelines/rpi/v1/stages/40-verify/output/flpath-4180/VERIFICATION.md) (**Pass**). **4164 implementation plan:** [`pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md`](../../pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md).

**Jira discoverability:** This repo is not published; Jira readers should rely on **self-contained ticket text** (see closing comment on **FLPATH-4180**) and the pattern in [`../workspace/jira-handoff-without-public-repo.md`](../workspace/jira-handoff-without-public-repo.md). Copy the **minimum** conclusions into **FLPATH-4164** description or a pinned comment there.

**One-line takeaway:** Insights **FEC** documents **`ExtensionsPlugin`** extension objects for Chrome to merge nav/routes; **`insights-rbac-ui`** does **not** use **`ExtensionsPlugin`** in **`fec.config.js`** (`plugins: []`); in-app nav is **React Router**. **`koku-ui-onprem`** should align **4164** with **Scalprum + `DynamicRemotePlugin`** and expand **`useChrome`** stubs per [`flpath-4180/QUESTIONS.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4180/QUESTIONS.md) (resolved 2026-05-14).

**MFE context:** [`flpath-4164/RESEARCH.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4164/RESEARCH.md) (HCCM → onprem pattern, chart **`/api/rbac/`**).
