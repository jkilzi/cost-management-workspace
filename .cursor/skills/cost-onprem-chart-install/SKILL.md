---
name: cost-onprem-chart-install
description: >-
  OpenShift install order and scripts for insights-onprem cost-onprem Helm chart
  from submodules/cost-onprem-chart: Kafka (deploy-kafka.sh or
  KAFKA_BOOTSTRAP_SERVERS), RHBK/JWT (deploy-rhbk.sh before install-helm-chart.sh
  for standard UI OAuth), S3, User Workload Monitoring, install-helm-chart.sh,
  RBAC bootstrap. Use when deploying cost-onprem, install-helm-chart.sh,
  deploy-kafka.sh, deploy-rhbk.sh, AMQ Streams, Keycloak, or Demo Catalog SNO
  cost management on-prem.
disable-model-invocation: true
---

# cost-onprem-chart installation (OpenShift)

## Authority and paths

- **Submodule (clone / scripts / chart):** `submodules/cost-onprem-chart/`
- **Normative docs:** `submodules/cost-onprem-chart/docs/operations/installation.md`, `configuration.md`
- **Workspace Demo Catalog notes:** `wiki/entities/demo-catalog-cost-onprem-install.md`

Run shell scripts from **`submodules/cost-onprem-chart/`** so relative paths (e.g. default `LOCAL_CHART_PATH=../cost-onprem`) resolve.

```bash
cd submodules/cost-onprem-chart
```

## Install order (do not reorder without reason)

| Step | Action | Hard fail if missing? |
|------|--------|------------------------|
| 1 | `oc login`; verify ability to install operators if using bundled scripts | `deploy-kafka.sh` / `deploy-rhbk.sh` need `subscriptions.operators.coreos.com` create (cluster admin or equivalent) |
| 2 | S3-compatible storage path (OBC, `S3_*` env vars, pre-created secret + values, etc.) | Install script fails on storage credential path when required |
| 3 | **Kafka:** `./scripts/deploy-kafka.sh` **or** export `KAFKA_BOOTSTRAP_SERVERS=host:9092` **or** set `kafka.bootstrapServers` in values | **`install-helm-chart.sh` exits** — chart does not deploy Kafka |
| 4 | **RHBK (JWT + UI OAuth):** `./scripts/deploy-rhbk.sh` when not BYO Keycloak | Install may **complete** but JWT/UI OAuth **broken** — `install-helm-chart.sh` warns; `KEYCLOAK_FOUND` needs `Keycloak` CR or `app=keycloak` service |
| 5 | **User Workload Monitoring** enabled (`cluster-monitoring-config` / doc § UWM) | **Silent** ROS metrics failure if skipped |
| 6 | `./scripts/install-helm-chart.sh` (optional `NAMESPACE`, `USE_LOCAL_CHART`, `VALUES_FILE`, `S3_*`, `CHART_VERSION`, …) | See script `help` |
| 7 | RBAC: `rbac.bootstrapAdmin` Helm values or `NAMESPACE=cost-onprem ./scripts/sync-rbac-admin.sh` | 403 on APIs without roles |

**CI parity:** submodule `.cursor/rules/testing.mdc` describes CI as RHBK → Kafka → chart — mirror that for local clusters.

## Scripts (quick reference)

| Script | Role |
|--------|------|
| `scripts/deploy-kafka.sh` | AMQ Streams operator + `Kafka` CR (default namespace `kafka`) |
| `scripts/deploy-rhbk.sh` | RHBK operator, Keycloak DB Postgres, Keycloak CR, realm `kubernetes`, clients `cost-management-operator` / `cost-management-ui`, secrets `keycloak-client-secret-*` |
| `scripts/install-helm-chart.sh` | Secrets, S3 buckets (when applicable), `verify_kafka`, Keycloak detect, Helm upgrade --install |

## RHBK nuances

- Default **`RHBK_NAMESPACE`** / target: **`keycloak`**. **`COST_MGMT_NAMESPACE`** / **`COST_MGMT_RELEASE_NAME`** default to **`cost-onprem`** — used for UI redirect URIs; script can **construct** the UI URL before the UI Route exists.
- **`install-helm-chart.sh help`** says RHBK is “optional”; for **standard OpenShift JWT + oauth2-proxy UI login**, treat **`deploy-rhbk.sh` as required** unless Keycloak realm/clients/secrets are replicated manually.
- Missing UI client secret: `create_ui_secrets` **warns** and continues — do not treat green Helm as proof of working login.

## Kafka nuances

- Chart **`values.yaml`** states Kafka is **not** managed by Helm — only `kafka.bootstrapServers` is configured.
- External Kafka: **`KAFKA_BOOTSTRAP_SERVERS`** bypasses AMQ Streams verification; **PLAINTEXT** limitation per `configuration.md` § External Kafka.

## Defaults (prefer unless overridden)

- `NAMESPACE` / Helm target: **`cost-onprem`**
- `HELM_RELEASE_NAME`: **`cost-onprem`**
- Kafka discovery namespace: **`kafka`** (override with `KAFKA_NAMESPACE`)

## After install

- `./scripts/install-helm-chart.sh health`
- Routes: `oc get routes -n cost-onprem`
- Doc pointers: installation.md § Verification, § RBAC, § Troubleshooting

## Submodule Git reminder

Chart changes belong on a **task branch** in `submodules/cost-onprem-chart/` per `.cursor/rules/submodule-git-workflow.mdc`; bump superproject gitlink when committing.
