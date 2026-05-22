# Secrets (names only — set values in GitHub / Quay UI)

## GitHub repository (`cost-mgmt-onprem-workspace`)

| Secret | Purpose |
| ------ | ------- |
| `QUAY_USERNAME` | Quay robot or account with **push** to `jkilzi/koku-ui-onprem` |
| `QUAY_PASSWORD` | Robot token password |

Configure under **Settings → Secrets and variables → Actions**.

Workflow uses default `GITHUB_TOKEN` for checkout (public repo + public submodules).

## OpenShift (rollout — local)

| Item | Purpose |
| ---- | ------- |
| `<quay-pull-secret>` | `imagePullSecret` in namespace `cost-onprem` if pulls from private Quay fail |

Reference in `ui-image-values.local.yaml` under `global.imagePullSecrets` when needed.
