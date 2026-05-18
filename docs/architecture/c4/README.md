# C4 architecture — Cost Management on-prem

Structured views of the Red Hat Cost Management on-prem platform deployed via the [`cost-onprem`](../../../submodules/cost-onprem-chart/cost-onprem/) Helm chart on OpenShift.

## C4 levels in this set

| Level | Question answered | Files |
|-------|-------------------|-------|
| **1 — System context** | Who uses the system and what external systems does it depend on? | [01-system-context.md](01-system-context.md) |
| **2 — Containers** | What are the major deployable units and how do they communicate? | [02-containers.md](02-containers.md) |
| **3 — Components** | What are the main parts inside Koku and the UI stack? | [03-components-koku.md](03-components-koku.md), [03-components-ui.md](03-components-ui.md) |

Level 4 (code/classes) is intentionally omitted. Use submodule source and `AGENTS.md` files for implementation detail.

## Supplements

- [data-flows.md](data-flows.md) — Sequence diagrams for metrics upload and authorized API reads
- [repository-map.md](repository-map.md) — Git repository → container image → Kubernetes workload

## Diagram conventions

- Diagrams use [Mermaid C4 syntax](https://mermaid.js.org/syntax/c4.html) (`C4Context`, `C4Container`, `C4Component`) embedded in Markdown.
- Sequence diagrams use standard Mermaid `sequenceDiagram`.
- **System under design** is named `CostManagementOnPrem` at context level; child containers live inside the OpenShift namespace boundary described in level 2.

### Visual companions (chart repo)

The Helm chart maintains SVG overviews that complement (but do not replace) these C4 views:

| SVG | Chart path |
|-----|------------|
| Architecture overview | [cost-onprem-architecture-diagram.svg](../../../submodules/cost-onprem-chart/docs/cost-onprem-architecture-diagram.svg) |
| Data processing | [data-processing-flow.svg](../../../submodules/cost-onprem-chart/docs/data-processing-flow.svg) |
| Gateway routing | [gateway-routing-diagram.svg](../../../submodules/cost-onprem-chart/docs/gateway-routing-diagram.svg) |
| UI login | [ui-login-flow.svg](../../../submodules/cost-onprem-chart/docs/ui-login-flow.svg) |

## Sources of truth (avoid drift)

| Concern | Authoritative location |
|---------|------------------------|
| What gets deployed, images, values | [`cost-onprem/values.yaml`](../../../submodules/cost-onprem-chart/cost-onprem/values.yaml), [`cost-onprem/templates/`](../../../submodules/cost-onprem-chart/cost-onprem/templates/) |
| Envoy routes and JWT | [`templates/gateway/configmap-envoy.yaml`](../../../submodules/cost-onprem-chart/cost-onprem/templates/gateway/configmap-envoy.yaml), [helm-templates-reference.md](../../../submodules/cost-onprem-chart/docs/architecture/helm-templates-reference.md) |
| Install order (Kafka, RHBK, S3) | [installation.md](../../../submodules/cost-onprem-chart/docs/operations/installation.md), [wiki demo-catalog install](../../../wiki/entities/demo-catalog-cost-onprem-install.md) |
| Koku on-prem data path | [onprem_data_flow.md](../../../submodules/koku/docs/onprem_data_flow.md) |
| RBAC authorization flow | [rbac-setup.md](../../../submodules/cost-onprem-chart/docs/operations/rbac-setup.md) |

When chart behavior changes, update the C4 pages that reference affected containers or paths, then adjust the repository-map table if images or repos change.

## Navigation

- Up: [docs/README.md](../../README.md)
- Next: [01-system-context.md](01-system-context.md)
