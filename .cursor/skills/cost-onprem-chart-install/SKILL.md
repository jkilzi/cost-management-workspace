---
name: cost-onprem-chart-install
description: >-
  OpenShift install order and scripts for insights-onprem cost-onprem Helm chart
  from submodules/cost-onprem-chart: Kafka (deploy-kafka.sh or
  KAFKA_BOOTSTRAP_SERVERS), RHBK/JWT (deploy-rhbk.sh before install-helm-chart.sh
  for standard UI OAuth), S3, User Workload Monitoring, install-helm-chart.sh,
  RBAC bootstrap, UI login bounce (Envoy JWT org_id/account_number 401),
  Keycloak declarative user profile workaround (keycloak-fix-org-jwt-claims.sh),
  RHBK CSV TooManyOperatorGroups (rhbk-fix-csv-too-many-operatorgroups.sh).
  Use when deploying cost-onprem, install-helm-chart.sh, deploy-kafka.sh,
  deploy-rhbk.sh, AMQ Streams, Keycloak, UI redirects to login after Keycloak,
  or Demo Catalog SNO cost management on-prem.
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
| 7 | **(Recommended)** JWT claims check: `bash .cursor/skills/cost-onprem-chart-install/scripts/keycloak-fix-org-jwt-claims.sh verify` (then `… fix` if needed) | Prevents **UI bounce** when Keycloak drops `org_id` / `account_number`; see **Known issue** |
| 8 | RBAC: `rbac.bootstrapAdmin` Helm values or `NAMESPACE=cost-onprem ./scripts/sync-rbac-admin.sh` | 403 on APIs without roles |

**CI parity:** submodule `.cursor/rules/testing.mdc` describes CI as RHBK → Kafka → chart — mirror that for local clusters.

## Scripts (quick reference)

| Script | Role |
|--------|------|
| `scripts/deploy-kafka.sh` | AMQ Streams operator + `Kafka` CR (default namespace `kafka`) |
| `scripts/deploy-rhbk.sh` | RHBK operator, Keycloak DB Postgres, Keycloak CR, realm `kubernetes`, clients `cost-management-operator` / `cost-management-ui`, secrets `keycloak-client-secret-*` |
| `scripts/install-helm-chart.sh` | Secrets, S3 buckets (when applicable), `verify_kafka`, Keycloak detect, Helm upgrade --install |
| [scripts/keycloak-fix-org-jwt-claims.sh](scripts/keycloak-fix-org-jwt-claims.sh) (this skill) | **Workaround:** enable Keycloak `unmanagedAttributePolicy` + set user `org_id` / `account_number` when JWT lacks those claims (see **Known issue** below) |
| [scripts/rhbk-fix-csv-too-many-operatorgroups.sh](scripts/rhbk-fix-csv-too-many-operatorgroups.sh) (this skill) | **Workaround:** remove duplicate OperatorGroup so RHBK CSV leaves `TooManyOperatorGroups` Failed state |

## Known issue: Keycloak declarative user profile vs Envoy JWT

**Who is affected:** Anyone using **`deploy-rhbk.sh`** (or an equivalent realm) with **modern Keycloak / RHBK**, then logging into the Cost Management **UI**. Typical cases: **Demo Catalog SNO**, fresh clusters after `deploy-rhbk.sh` + `install-helm-chart.sh`, or re-imported `kubernetes` realms where the realm YAML does **not** define a custom `userProfile`.

**What goes wrong:** Keycloak’s **default declarative user profile** only allows `username`, `email`, `firstName`, `lastName`. The chart’s **Envoy** Lua filter ([`configmap-envoy.yaml`](../../submodules/cost-onprem-chart/cost-onprem/templates/gateway/configmap-envoy.yaml)) requires JWT claims **`org_id`** and **`account_number`**. The realm import maps those from **user attributes**, but Keycloak **accepts** user updates with **`204`** while **dropping** `org_id` / `account_number` until either:

- `PUT /admin/realms/{realm}/users/profile` sets **`unmanagedAttributePolicy: ENABLED`**, or  
- those attributes are declared on the profile.

**Symptom:** Keycloak login succeeds (oauth2-proxy may log `[AuthSuccess]`), then the UI **returns to login** after API calls get **401** (`Missing org_id in JWT claims` / similar in gateway logs).

**Workaround (no chart change):** From the workspace root (or any cwd):

```bash
bash .cursor/skills/cost-onprem-chart-install/scripts/keycloak-fix-org-jwt-claims.sh verify   # exit 1 if fix needed
bash .cursor/skills/cost-onprem-chart-install/scripts/keycloak-fix-org-jwt-claims.sh fix      # idempotent apply
```

Optional env vars: `RHBK_NAMESPACE`, `REALM_NAME`, `KEYCLOAK_USERNAME`, `ORG_ID`, `ACCOUNT_NUMBER` (defaults match `deploy-rhbk.sh` / RBAC bootstrap expectations).

**Durable check:** After `fix`, `verify` should pass; Keycloak pod restarts keep realm DB state. Re-run after **realm delete + re-import** if the import still omits profile policy.

**Wiki:** [entities/known-issue-keycloak-declarative-profile-jwt.md](../../wiki/entities/known-issue-keycloak-declarative-profile-jwt.md).

## Known issue: RHBK CSV `TooManyOperatorGroups`

**Who is affected:** Clusters where RHBK was installed from the **console** (`keycloak-og`) and **`deploy-rhbk.sh`** also created `rhbk-operator-group`, or any namespace `keycloak` with **two** OperatorGroups.

**Symptom:** `oc get csv -n keycloak` shows `rhbk-operator.v*.*` **Failed**, `reason=TooManyOperatorGroups`. Operator Deployment and Keycloak may still be **Running**.

**Workaround:**

```bash
bash .cursor/skills/cost-onprem-chart-install/scripts/rhbk-fix-csv-too-many-operatorgroups.sh verify
bash .cursor/skills/cost-onprem-chart-install/scripts/rhbk-fix-csv-too-many-operatorgroups.sh fix
```

Optional env: `RHBK_NAMESPACE`, `RHBK_OG_TO_DELETE` (default `rhbk-operator-group`).

**Wiki:** [entities/known-issue-rhbk-csv-too-many-operatorgroups.md](../../wiki/entities/known-issue-rhbk-csv-too-many-operatorgroups.md).

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

## Success criterion: UI login must stick (not only “pods green”)

**Symptom:** Keycloak login succeeds, the Cost Management UI flashes, then the browser returns to the **login** page after a few seconds.

**Most common cause in this chart:** API calls go through the **Envoy gateway** (`cost-onprem/templates/gateway/configmap-envoy.yaml`). The Lua filter returns **401** unless the JWT used on `/api/*` contains top-level **`org_id`** and **`account_number`** (see messages like `Unauthorized: Missing org_id in JWT claims`). The SPA then redirects to Keycloak again — oauth2-proxy session can be fine while **gateway** rejects the bearer token.

**Verify:**

1. Browser **Network** tab: failing `/api/...` → status **401** and response body from Envoy.
2. Decode **access token** from the Authorization bearer: check **`iss`**, **`aud`** (must match `jwtAuth.keycloak.audiences`, including `cost-management-ui`), and root-level **`org_id` / `account_number`**. `deploy-rhbk.sh` realm import adds mappers for `cost-management-ui`; realm must stay **`kubernetes`** unless you override `jwtAuth.keycloak.realm` consistently.
3. `oc logs -n <ns> -l app.kubernetes.io/component=gateway -c envoy --tail=200` — grep `Missing org_id`, `JWT auth ok`, JWKS/TLS.
4. `oc logs -n <ns> -l app.kubernetes.io/component=ui -c oauth-proxy --tail=200` — OIDC **refresh** / TLS failures (cookie refresh vs Keycloak token TTL).
5. If Helm was ever upgraded with **`--no-hooks`**, confirm **`cost-onprem-rbac-migrate`** completed; use `sync-rbac-admin.sh` / bootstrap per installation doc if APIs return **403**.

**Ingress image tag:** Quay tags used in `values.yaml` can expire; override `ingress.image.tag` if `cost-onprem-ingress` is **ImagePullBackOff**.

## Submodule Git reminder

Chart changes belong on a **task branch** in `submodules/cost-onprem-chart/` per `.cursor/rules/submodule-git-workflow.mdc`; bump superproject gitlink when committing.
