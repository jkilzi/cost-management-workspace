# Cost Management workspace documentation

Workspace-level architecture and integration docs for the Cost Management on-prem program. These pages synthesize material from git submodules; they do not replace upstream operational guides.

## Architecture (C4)

The [C4 model](https://c4model.com/) views describe the on-prem platform drilled down from the Helm chart:

| Document | C4 level | Audience |
|----------|----------|----------|
| [architecture/c4/README.md](architecture/c4/README.md) | — | How to read and maintain these diagrams |
| [architecture/c4/01-system-context.md](architecture/c4/01-system-context.md) | 1 — Context | New engineers, stakeholders |
| [architecture/c4/02-containers.md](architecture/c4/02-containers.md) | 2 — Containers | Platform, SRE, security |
| [architecture/c4/03-components-koku.md](architecture/c4/03-components-koku.md) | 3 — Components | Backend developers |
| [architecture/c4/03-components-ui.md](architecture/c4/03-components-ui.md) | 3 — Components | Frontend developers |
| [architecture/c4/data-flows.md](architecture/c4/data-flows.md) | — | Ingest and auth debugging |
| [architecture/c4/repository-map.md](architecture/c4/repository-map.md) | — | Submodule contributors |

## Related sources of truth

| Location | Contents |
|----------|----------|
| [submodules/cost-onprem-chart/docs/](../submodules/cost-onprem-chart/docs/) | Installation, configuration, Helm reference, SVG diagrams |
| [submodules/koku/docs/](../submodules/koku/docs/) | Backend data flow, API, on-prem mode |
| [submodules/koku/AGENTS.md](../submodules/koku/AGENTS.md) | Koku ecosystem developer guide |
| [wiki/index.md](../wiki/index.md) | Workspace knowledge base (install pitfalls, POCs) |
| [constitutions/](../constitutions/) | Per-submodule mission notes |

## Submodules in this workspace

- `cost-onprem-chart` — Helm chart and deploy scripts
- `koku` — Cost Management API and data pipeline
- `koku-ui` — On-prem UI shell and federated apps
- `insights-rbac-ui` — IAM UI reference (federated into `koku-ui-onprem`)
