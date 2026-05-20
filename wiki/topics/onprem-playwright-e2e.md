# On-prem Playwright e2e (koku-ui-onprem)

**Location:** [`submodules/koku-ui/apps/koku-ui-onprem/e2e/`](../../submodules/koku-ui/apps/koku-ui-onprem/e2e/)

## Purpose

FLPATH-style smoke: federated IAM inside the on-prem **host** (`localhost:9001`), full remotes, real API proxy — not mocked like [`cypress/`](../submodules/koku-ui/apps/koku-ui-onprem/cypress/) specs.

## Not for CI

Standard **koku-ui** CI does **not** (and should not) run `npm run verify:onprem-e2e`:

- No full on-prem dev stack + cluster APIs in PR jobs.
- Playwright hits live routes (`/iam/*`, `/api/rbac`, cost federates) that need **`start:onprem:dev`** after `source scripts/setup-onprem-env.sh`.

**Automatable in CI:** `npm run verify:onprem` (RBAC manifest/build script).

**Local integration only:** `verify:onprem-e2e` / `verify:onprem-nav` after `start:onprem:dev`.

## Recommended local flow

```bash
cd submodules/koku-ui
oc login …
source scripts/setup-onprem-env.sh
npm run start:onprem:dev
# other terminal:
npm run verify:onprem-e2e
```

## Related

- [FLPATH-4164 entity](../entities/flpath-4164-rbac-mfe-poc.md)
- [RPI 40-verify UI acceptance](rpi-verify-ui-acceptance.md) — Playwright here is **manual/local** evidence, not a CI substitute
- Pipeline AC: [`pipelines/rpi/v1/stages/40-verify/output/flpath-4164/ACCEPTANCE_CRITERIA.md`](../../pipelines/rpi/v1/stages/40-verify/output/flpath-4164/ACCEPTANCE_CRITERIA.md)
