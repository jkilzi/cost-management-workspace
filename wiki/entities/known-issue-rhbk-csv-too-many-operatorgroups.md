---
type: KnownIssue
title: Known issue — RHBK CSV Failed (TooManyOperatorGroups)
description: RHBK ClusterServiceVersion shows Failed when more than one OperatorGroup exists in the keycloak namespace; fix removes duplicate OperatorGroup.
tags: [rhbk, keycloak, olm, operatorgroup, csv, openshift]
timestamp: 2026-06-17T00:00:00Z
---

# Known issue: RHBK CSV Failed (`TooManyOperatorGroups`)

## Summary

The RHBK **ClusterServiceVersion** (CSV) in namespace `keycloak` can show **Failed** with `status.reason=TooManyOperatorGroups` when **more than one OperatorGroup** exists in that namespace. OLM cannot pick which OperatorGroup owns the install.

**Important:** The **operator Deployment** and **Keycloak CR** may still be **Running** — SSO and JWT can work while the CSV is Failed. The failure is an **OLM bookkeeping** problem, not necessarily a down Keycloak instance.

## Symptom

```bash
oc get csv -n keycloak | grep rhbk
# PHASE=Failed

oc get csv rhbk-operator.v26.4.11-opr.2 -n keycloak \
  -o jsonpath='{.status.reason}{"\n"}{.status.message}{"\n"}'
# TooManyOperatorGroups
# csv created in namespace with multiple operatorgroups, can't pick one automatically
```

Past CSV conditions may also show `ComponentUnhealthy` if `rhbk-operator` was briefly unavailable; check the **current** `status.reason` before acting.

## Diagnosis

```bash
oc get operatorgroup -n keycloak
```

Expect **two** rows, for example:

| Name | Typical origin |
|------|----------------|
| `keycloak-og` | OLM / OpenShift console install (often has `olm.providedAPIs` annotation) |
| `rhbk-operator-group` | [`deploy-rhbk.sh`](../../submodules/cost-onprem-chart/scripts/deploy-rhbk.sh) when it created a second OG because the script only checked for that **name**, not “any OG in namespace” |

## Root cause

1. RHBK was installed via console or an earlier flow → OLM created `keycloak-og`.
2. `deploy-rhbk.sh` ran later → created `rhbk-operator-group` in the same namespace.
3. OLM marks the CSV **Failed** until exactly **one** OperatorGroup remains.

## Workaround (workspace script)

Idempotent script (same pattern as JWT profile fix):

```bash
bash .cursor/skills/cost-onprem-chart-install/scripts/rhbk-fix-csv-too-many-operatorgroups.sh verify
bash .cursor/skills/cost-onprem-chart-install/scripts/rhbk-fix-csv-too-many-operatorgroups.sh fix
```

Optional env: `RHBK_NAMESPACE` (default `keycloak`), `RHBK_OG_TO_DELETE` (default `rhbk-operator-group`), `RHBK_CSV_WAIT_SECONDS` (default `120`).

**What `fix` does:** deletes the duplicate OperatorGroup (default `rhbk-operator-group`), keeps the original (e.g. `keycloak-og`); if the CSV still shows stale `TooManyOperatorGroups`, annotates `operators.coreos.com/force=true` on the rhbk CSV and waits for `Succeeded`. Does **not** delete Subscription, Keycloak CR, or Keycloak pods.

Documented in the install skill: [`.cursor/skills/cost-onprem-chart-install/SKILL.md`](../../.cursor/skills/cost-onprem-chart-install/SKILL.md).

## Fix (manual)

**Keep** the original OperatorGroup (usually `keycloak-og`). **Delete** the duplicate (usually `rhbk-operator-group`):

```bash
oc get operatorgroup -n keycloak
oc delete operatorgroup rhbk-operator-group -n keycloak
```

Then verify (or use the script above):

```bash
oc get operatorgroup -n keycloak          # single row
oc get csv -n keycloak | grep rhbk        # PHASE=Succeeded
oc get deployment rhbk-operator -n keycloak
```

If the CSV stays **Failed** with a **stale** `TooManyOperatorGroups` message while only one OG remains:

```bash
oc annotate csv rhbk-operator.v26.4.11-opr.2 -n keycloak \
  operators.coreos.com/force=true --overwrite
```

Do **not** delete the Subscription or Keycloak CR unless a **new** error appears after the OG fix.

## Prevention

Avoid a **second** OperatorGroup in `keycloak`: if RHBK was installed from the console first (`keycloak-og`), do **not** let [`deploy-rhbk.sh`](../../submodules/cost-onprem-chart/scripts/deploy-rhbk.sh) create `rhbk-operator-group` — the script only checks for that name, not “any OG in namespace”. Prefer one install path (console **or** script), or delete the duplicate OG before relying on CSV health.

`deploy-rhbk.sh cleanup` deletes only `rhbk-operator-group`; console installs may leave `keycloak-og` — that is expected.

## Related

- [Demo Catalog + cost-onprem install](demo-catalog-cost-onprem-install.md) — RHBK install order
- [Known issue: Keycloak declarative profile vs JWT](known-issue-keycloak-declarative-profile-jwt.md) — separate post-login / JWT claim problem
- Skill: [`.cursor/skills/cost-onprem-chart-install/SKILL.md`](../../.cursor/skills/cost-onprem-chart-install/SKILL.md)
