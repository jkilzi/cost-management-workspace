# Topics

How-to guides, runbooks, and conceptual references that apply across multiple scopes.

## UI

* [UI verification and E2E (Cursor harness)](ui-verification-and-e2e.md) - Acceptance criteria, Cypress live e2e flow for UI-modifying work.
* [On-prem UI cluster image (build + rollout)](onprem-ui-cluster-image.md) - GHA linux/amd64 build to Quay; local Helm rollout on Apple Silicon.
* [On-prem Cypress e2e (koku-ui-onprem)](onprem-playwright-e2e.md) - Cypress integration and live e2e layout; not run in CI.

## RBAC MFE

* [rbac-ui-onprem webpack shims](rbac-ui-onprem-shims.md) - useAppLink-only shim after 2026-06-01 removal pass.
* [rbac-ui-onprem vendored RBAC upstream](rbac-ui-onprem-vendor.md) - insights-rbac-ui git submodule for hermetic Konflux builds.

## Auth / Keycloak

* [Keycloak org-admin realm role (on-prem)](keycloak-org-admin-realm-role.md) - Assign org-admin realm role; verify JWT and RBAC is_org_admin.
