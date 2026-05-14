# FLPATH-4180 — FEC extension points vs on-prem RBAC MFE

**Jira:** [FLPATH-4180](https://redhat.atlassian.net/browse/FLPATH-4180) (*Research FEC extension points for embedding/delivering RBAC UI*). **Blocks** [FLPATH-4164](https://redhat.atlassian.net/browse/FLPATH-4164).

**Pipeline SoT:** [`pipelines/rpi/v1/stages/10-research/output/flpath-4180/RESEARCH.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4180/RESEARCH.md) (facts, citations, recommendation). **20-plan closeout:** [`pipelines/rpi/v1/stages/20-plan/output/flpath-4180/PLAN.md`](../../pipelines/rpi/v1/stages/20-plan/output/flpath-4180/PLAN.md). **4164 implementation plan:** [`pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md`](../../pipelines/rpi/v1/stages/20-plan/output/flpath-4164/PLAN.md).

**One-line takeaway:** Insights **FEC** documents **`ExtensionsPlugin`** extension objects for Chrome to merge nav/routes; **`insights-rbac-ui`** does **not** use **`ExtensionsPlugin`** in **`fec.config.js`** (`plugins: []`); in-app nav is **React Router**. **`koku-ui-onprem`** should align **4164** with **Scalprum + `DynamicRemotePlugin`** and expand **`useChrome`** stubs per [`flpath-4180/QUESTIONS.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4180/QUESTIONS.md) (resolved 2026-05-14).

**MFE context:** [`flpath-4164/RESEARCH.md`](../../pipelines/rpi/v1/stages/10-research/output/flpath-4164/RESEARCH.md) (HCCM → onprem pattern, chart **`/api/rbac/`**).
