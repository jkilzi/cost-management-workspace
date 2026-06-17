---
type: KnownIssue
title: Known issue — Keycloak declarative user profile drops org_id / account_number from JWT
description: Modern Keycloak/RHBK default user profile omits custom attributes; Envoy JWT validation fails with 401 and triggers UI re-login loop.
tags: [keycloak, rhbk, jwt, org_id, account_number, envoy, cost-onprem]
timestamp: 2026-06-17T00:00:00Z
---

# Known issue: Keycloak declarative user profile and missing JWT `org_id` / `account_number`

## Summary

On **modern Keycloak / RHBK**, new realms get Keycloak’s **default declarative user profile** (typically `username`, `email`, `firstName`, `lastName` only). Custom user attributes **`org_id`** and **`account_number`** are **not stored** until the realm allows them—either by setting **`unmanagedAttributePolicy: ENABLED`** on the realm user profile or by declaring those attributes explicitly on the profile.

The **cost-onprem** Envoy gateway expects those values as **top-level JWT claims** when calling `/api/*`. If they are absent, Envoy returns **401** (e.g. `Missing org_id in JWT claims`). The UI then **returns to the login screen** even when Keycloak and oauth2-proxy completed the IdP step successfully.

This is **not** primarily “`deploy-rhbk.sh` forgot to set attributes”: the script’s realm import uses **user-attribute mappers** for the UI client, but the **profile** Keycloak applies by default **silently drops** those attributes on create/update (**204** with no persisted attributes).

## Where users are most likely to hit it

- **Fresh `deploy-rhbk.sh` installs** (realm `kubernetes` created via `KeycloakRealmImport` without a custom `userProfile` block).
- **Demo Catalog / SNO** and other lab clusters where RHBK is installed once and the admin user is created or updated before anyone notices missing claims.
- **Re-created realms** after delete/re-import: defaults return until the workaround is re-applied (unless the import is extended upstream).

## Workaround (workspace; no chart edit)

Script (idempotent):

- Path: [`.cursor/skills/cost-onprem-chart-install/scripts/keycloak-fix-org-jwt-claims.sh`](../../.cursor/skills/cost-onprem-chart-install/scripts/keycloak-fix-org-jwt-claims.sh)
- Commands: `verify` (exit 1 if remediation needed), `fix` (apply + self-verify).

Documented in the install skill: [`.cursor/skills/cost-onprem-chart-install/SKILL.md`](../../.cursor/skills/cost-onprem-chart-install/SKILL.md) (**Known issue** + install table).

## Related

- [Demo Catalog install notes](demo-catalog-cost-onprem-install.md) — post-login bounce, Envoy checks.
- Submodule Envoy behavior: `submodules/cost-onprem-chart/cost-onprem/templates/gateway/configmap-envoy.yaml`.
- Realm / mappers (no profile stanza today): `submodules/cost-onprem-chart/scripts/deploy-rhbk.sh` (`KeycloakRealmImport`).
