# Demo Catalog OpenShift: cost-onprem-chart install notes

Workspace-specific runbook for deploying **[cost-onprem-chart](../../submodules/cost-onprem-chart/)** on a **Red Hat Demo Platform** leased cluster (personal service catalog). **Canonical procedures** remain in the submodule: [`docs/operations/installation.md`](../../submodules/cost-onprem-chart/docs/operations/installation.md) and [`docs/operations/configuration.md`](../../submodules/cost-onprem-chart/docs/operations/configuration.md).

For a **portable** install checklist (any OpenShift, not only Demo Catalog), use the Cursor skill [`.cursor/skills/cost-onprem-chart-install/SKILL.md`](../../.cursor/skills/cost-onprem-chart-install/SKILL.md).

## Environment (this workspace)

| Item | Detail |
|------|--------|
| Lease / catalog | [Demo Catalog — user service list](https://catalog.demo.redhat.com/services/<your-demo-catalog-user>) |
| Cluster template | **Single-node OpenShift (SNO)** |
| Shape | ~**32** vCPU, **128** GiB RAM, **~100** GB storage (template-dependent; treat as planning baseline) |
| Pre-created **user-scoped** projects | `assisted-installer`, `cert-manager`, `cert-manager-operator`, **`keycloak`** |
| Auth for chart | A project named **`keycloak` does not imply RHBK is installed** — see [RHBK below](#rhbk-red-hat-build-of-keycloak-deploy-rhbksh). Chart defaults assume Keycloak in that namespace when JWT is wired. |

## Defaults to prefer (minimal typing)

Use chart/script defaults unless you have a reason to override:

| Variable / concept | Default |
|--------------------|---------|
| Target namespace | `cost-onprem` (`NAMESPACE`) |
| Helm release | `cost-onprem` (`HELM_RELEASE_NAME`) |
| Chart source | Helm repo `https://insights-onprem.github.io/cost-onprem-chart` (`USE_LOCAL_CHART=false`) |
| Local chart (dev) | `USE_LOCAL_CHART=true`, chart at `submodules/cost-onprem-chart/cost-onprem` — run scripts from `submodules/cost-onprem-chart/` so `install-helm-chart.sh` resolves `../cost-onprem` correctly |
| Kafka namespace (script discovery) | `kafka` unless `KAFKA_NAMESPACE` is set |
| RHBK namespace | `keycloak` (`RHBK_NAMESPACE` for [`deploy-rhbk.sh`](../../submodules/cost-onprem-chart/scripts/deploy-rhbk.sh)) |
| Install entrypoint | [`submodules/cost-onprem-chart/scripts/install-helm-chart.sh`](../../submodules/cost-onprem-chart/scripts/install-helm-chart.sh) |

## Streamlined order of operations

1. **`oc login`** — context pointing at the leased cluster. **`deploy-rhbk.sh`** and **`deploy-kafka.sh`** need permission to install **OLM Subscriptions** (cluster admin or equivalent); confirm `oc auth can-i create subscriptions.operators.coreos.com -A`.
2. **S3-compatible storage** — choose one path from installation doc (OBC, AWS env vars, S4, etc.). Without a working endpoint + credentials secret in the install namespace, behavior degrades even if pods start.
3. **Kafka before Helm install** — the chart **does not** deploy Kafka; [`install-helm-chart.sh`](../../submodules/cost-onprem-chart/scripts/install-helm-chart.sh) **fails** if AMQ Streams + `Kafka` CR are missing and **`KAFKA_BOOTSTRAP_SERVERS`** / values `kafka.bootstrapServers` are not set. Run [`scripts/deploy-kafka.sh`](../../submodules/cost-onprem-chart/scripts/deploy-kafka.sh), wait for `Kafka` Ready; set `STORAGE_CLASS` on SNO if there is no default SC.
4. **RHBK before Helm install (JWT + UI OAuth)** — run [`scripts/deploy-rhbk.sh`](../../submodules/cost-onprem-chart/scripts/deploy-rhbk.sh) unless you already have a Keycloak deployment that exposes the **same realm/clients/secrets** the chart expects (see [RHBK section](#rhbk-red-hat-build-of-keycloak-deploy-rhbksh)). May run **before** the first chart install (script constructs UI redirect URL from `COST_MGMT_NAMESPACE` / `COST_MGMT_RELEASE_NAME` when the UI route does not exist yet).
5. **User Workload Monitoring** — enable for ROS metrics (installation doc § User Workload Monitoring); otherwise ServiceMonitors exist but nothing scrapes them (**silent** pipeline failure).
6. **Install** — from `submodules/cost-onprem-chart`: `./scripts/install-helm-chart.sh` (set `S3_*` or use OBC auto-detection per doc).
7. **RBAC post-install** — bootstrap admin or `sync-rbac-admin.sh` per [installation.md — Verification / RBAC](../../submodules/cost-onprem-chart/docs/operations/installation.md). Defaults for `rbac.bootstrapAdmin` match the user **`deploy-rhbk.sh`** creates.

## RHBK (Red Hat Build of Keycloak): `deploy-rhbk.sh`

- **Purpose:** Installs the RHBK **operator** (OLM), **PostgreSQL** for Keycloak’s DB in the Keycloak namespace, the **Keycloak** CR (`k8s.keycloak.org/v2alpha1`), realm **`kubernetes`**, OAuth clients **`cost-management-operator`** and **`cost-management-ui`**, and Kubernetes secrets **`keycloak-client-secret-<client-id>`** that [`install-helm-chart.sh`](../../submodules/cost-onprem-chart/scripts/install-helm-chart.sh) uses for JWT Helm `--set`s and **UI OAuth** (`create_ui_secrets`).
- **Why an empty `keycloak` project is not enough:** `install-helm-chart.sh` sets `KEYCLOAK_FOUND` from a **`Keycloak` CR** or a service labeled **`app=keycloak`**. An empty namespace → detection fails → Helm runs with **chart defaults** for Keycloak and **no** auto-injected `jwtAuth.keycloak.*`; UI OAuth secret creation is skipped or warns. **Helm can still “succeed” while login/JWT is broken** — treat **`deploy-rhbk.sh` as required** for the standard OpenShift JWT+UI path.
- **`install-helm-chart.sh help`** still lists RHBK as “optional”; for **UI + Envoy JWT**, that is **misleading** unless you fully BYO Keycloak.
- **Commands:** `./deploy-rhbk.sh` · `./deploy-rhbk.sh validate` · `./deploy-rhbk.sh cleanup`. See script `help` for env vars (`RHBK_NAMESPACE`, `STORAGE_CLASS`, `COST_MGMT_NAMESPACE`, `COST_MGMT_RELEASE_NAME`, `COST_MGMT_UI_BASE_URL`, etc.).
- **SNO:** RHBK adds operator + DB + Keycloak — account for extra CPU/RAM alongside Kafka and cost-onprem.

## Nuances (do not repeat mistakes)

- **Kafka is documented** under installation **§ OpenShift Prerequisites → Kafka (AMQ Streams)** and configuration **§ Kafka**; it is **omitted** from the short “What the script does” bullet list in the same doc — easy to skim past. **install-helm-chart.sh does not run deploy-kafka.sh** for you.
- **External Kafka:** set `KAFKA_BOOTSTRAP_SERVERS` (or values `kafka.bootstrapServers`) so the script skips AMQ Streams CR discovery. **PLAINTEXT only** for app connectivity today (see configuration doc — known limitation).
- **SNO resource pressure:** installation doc already calls out SNO (extra RAM/CPU vs baseline); Kafka + RHBK + PostgreSQL + Valkey + full worker set is heavy — watch `oc describe node` / pending pods if throttled.
- **Keycloak CA:** direct `helm install` paths require the Keycloak CA secret in the app namespace; the install script automates several secrets — prefer the script unless you are GitOps-only.

## Related

- [Workspace overview](../workspace/overview.md)
- Skill: [`.cursor/skills/cost-onprem-chart-install/SKILL.md`](../../.cursor/skills/cost-onprem-chart-install/SKILL.md)
- Submodule testing/CI context: [`submodules/cost-onprem-chart/.cursor/rules/testing.mdc`](../../submodules/cost-onprem-chart/.cursor/rules/testing.mdc) (CI order: RHBK → Kafka → chart — same idea locally)
