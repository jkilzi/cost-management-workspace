# On-prem Cypress e2e (koku-ui-onprem)

**Location:** [`submodules/koku-ui/apps/koku-ui-onprem/cypress/`](../../submodules/koku-ui/apps/koku-ui-onprem/cypress/)

## Layout

| Folder | Runner | Purpose |
|--------|--------|---------|
| [`cypress/e2e/integration/`](../../submodules/koku-ui/apps/koku-ui-onprem/cypress/e2e/integration/) | `npm run test:cypress` | API mocks via `loadApiInterceptors()` |
| [`cypress/e2e/live/`](../../submodules/koku-ui/apps/koku-ui-onprem/cypress/e2e/live/) | `npm run test:cypress:live` | E2E vs real cluster (FLPATH-4164) |

Live order: `01-app-loads.cy.ts` → `02-host-iam-navigation.cy.ts` (8 tests total).

## Not for CI

**koku-ui** CI must not run `npm run test:cypress:live`:

- Needs `npm run start:onprem:dev` (already runs `setup-onprem-env.sh`) and cluster APIs.
- **Automatable in CI:** `npm run verify:onprem` only.

## Recommended local flow

```bash
cd submodules/koku-ui
oc login …
npm run start:onprem:dev
# other terminal:
npm run test:cypress:live
```

## Related

- [FLPATH-4164 entity](../entities/flpath-4164-rbac-mfe-poc.md)
- [RPI 40-verify UI acceptance](rpi-verify-ui-acceptance.md)
- Pipeline AC: [`pipelines/rpi/v1/stages/40-verify/output/flpath-4164/ACCEPTANCE_CRITERIA.md`](../../pipelines/rpi/v1/stages/40-verify/output/flpath-4164/ACCEPTANCE_CRITERIA.md)
