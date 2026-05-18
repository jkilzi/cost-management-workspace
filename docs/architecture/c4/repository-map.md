# Repository and image map

Which git repositories contribute to the on-prem platform, what they build, and how chart workloads consume those artifacts.

## Workspace submodules

| Submodule | Upstream / role | Builds | Runs in cluster as |
|-----------|-----------------|--------|-------------------|
| [`cost-onprem-chart`](../../../submodules/cost-onprem-chart/) | [insights-onprem/cost-onprem-chart](https://github.com/insights-onprem/cost-onprem-chart) | Helm manifests, install scripts, pytest e2e | All Kubernetes resources (no app bytecode) |
| [`koku`](../../../submodules/koku/) | Cost Management backend | Container image from root `Dockerfile` | Koku API, Masu, listener, Celery beat/workers, migration Jobs |
| [`koku-ui`](../../../submodules/koku-ui/) | Frontend monorepo | `koku-ui-onprem` image + embedded remote bundles | UI Deployment (app container); static paths for MFEs |
| [`insights-rbac-ui`](../../../submodules/insights-rbac-ui/) | IAM UI reference | Federated via `apps/rbac-ui-onprem` in koku-ui | Static assets under `/rbac/` in UI pod |
| [`sources-ui`](../../../submodules/sources-ui/) | [RedHatInsights/sources-ui](https://github.com/RedHatInsights/sources-ui) — SaaS Platform Sources UI (**reference only**) | Not deployed on-prem | — (on-prem Integrations: `koku-ui` → `koku-ui-sources`) |

**SaaS backend for `sources-ui` (not a submodule):** [RedHatInsights/sources-api-go](https://github.com/RedHatInsights/sources-api-go).

Constitution summaries: [`constitutions/`](../../../constitutions/).

## Chart images (from default values)

Values change per release; pins below reflect [`cost-onprem/values.yaml`](../../../submodules/cost-onprem-chart/cost-onprem/values.yaml) at documentation time. Treat **values.yaml** as authoritative for tags.

| Workload | Image repository | Values key |
|----------|------------------|------------|
| Koku (all roles) | `quay.io/redhat-services-prod/cost-mgmt-dev-tenant/koku` | `costManagement.api.image` |
| ROS (all roles) | `quay.io/redhat-services-prod/insights-management-tenant/insights-ocp-resource-optimization/ros-ocp-backend` | `ros.image` |
| insights-rbac | `quay.io/cloudservices/rbac` | `rbac.image` |
| Ingress | `quay.io/redhat-user-workloads/hcc-integrations-tenant/ingress` | `ingress.image` |
| UI app | `quay.io/insights-onprem/koku-ui-onprem` | `ui.app.image` |
| OAuth2 proxy | `registry.redhat.io/rhceph/oauth2-proxy-rhel9` | `ui.oauthProxy.image` |
| Envoy gateway | `registry.redhat.io/openshift-service-mesh/proxyv2-rhel9` | `jwtAuth.envoy.image` (gateway section) |
| PostgreSQL | `registry.redhat.io/rhel10/postgresql-16` | `database.server.image` |
| Valkey | `registry.redhat.io/rhel10/valkey-8` | `valkey.image` |
| Kruize | `quay.io/redhat-services-prod/kruize-autotune-tenant/autotune` | `kruize.image` |

## Source repo → deployment matrix

| Source | Artifact in image/registry | Kubernetes workload(s) | Template path |
|--------|------------------------------|--------------------------|---------------|
| **koku** | `koku` image | API Deployment | `cost-management/api/` |
| **koku** | same image | Masu Deployment | `cost-management/masu/` |
| **koku** | same image | Listener Deployment | `cost-management/` (listener) |
| **koku** | same image | Celery beat + workers | `cost-management/celery/` |
| **koku-ui** | `koku-ui-onprem` + built remotes | UI Deployment app container | `ui/` |
| **koku-ui** (`rbac-ui-onprem`) | static files in UI image | same pod (`/rbac/`) | `ui/` |
| **insights-rbac** (upstream service) | `rbac` image | API + worker Deployments | `rbac/` |
| **ros-ocp-backend** (upstream) | ROS image | api, processor, poller, housekeeper | `ros/**` |
| **insights-ingress-go** (upstream) | ingress image | Ingress Deployment | `ingress/` |
| **kruize/autotune** (upstream) | autotune image | Kruize Deployment | `kruize/` |
| **cost-onprem-chart** | — | Gateway, DB, Valkey, Routes, NetworkPolicies | `gateway/`, `infrastructure/`, etc. |

## Prerequisites (scripts only)

| Component | Install script | Not in chart templates |
|-----------|----------------|------------------------|
| Kafka (AMQ Streams) | `scripts/deploy-kafka.sh` | Connection via `kafka.bootstrapServers` |
| Keycloak RHBK | `scripts/deploy-rhbk.sh` | `jwtAuth.keycloak.*`, oauth2-proxy issuer |
| S3 credentials Secret | `scripts/install-helm-chart.sh` | `infrastructure/storage/`, `objectStorage` values |
| Metrics Operator | OLM on each OCP cluster | Upload client only |

## API surface by owning service

| Path prefix | Owning service | Source repo for behavior |
|-------------|----------------|--------------------------|
| `/api/cost-management/` | Koku | `koku` |
| `/api/cost-management/v1/recommendations/openshift` | ROS | ros-ocp-backend (upstream) |
| `/api/rbac/` | insights-rbac | insights-rbac (upstream) |
| `/api/ingress/` | insights-ingress-go | ingress (upstream) |
| `/` (UI) | koku-ui-onprem | `koku-ui` |

## Local development vs cluster

| Mode | Koku | UI |
|------|------|-----|
| **Cluster** | Chart-managed Deployments | Chart UI + oauth2-proxy |
| **Local dev** | `docker compose` in koku repo | `webpack serve` for `koku-ui-onprem` with `API_PROXY_URL` |

See [koku/AGENTS.md](../../../submodules/koku/AGENTS.md) and chart [development docs](../../../submodules/cost-onprem-chart/docs/development/).

## Related

- [02-containers.md](02-containers.md) — logical containers
- [docs/README.md](../../README.md) — workspace doc index
