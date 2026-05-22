# Wiki index

Catalog of pages in this workspace wiki. **Agents:** keep this list accurate when you add, rename, or materially change a page (one line per page, link + summary).

## Workspace

| Page | Summary |
|------|---------|
| [workspace/overview.md](workspace/overview.md) | Cost Management workspace: wiki, constitutions, submodules, `.cursor/` harness; links to `AGENTS.md`, `workspace-workflow.mdc`, `llm-wiki.mdc`. |
| [workspace/jira-handoff-without-public-repo.md](workspace/jira-handoff-without-public-repo.md) | How to make research outcomes discoverable in **Jira** when this workspace is not published (paste summary, carry-forward, attachments). |
| [workspace/jira-cli-issue-links.md](workspace/jira-cli-issue-links.md) | Change Jira issue link type with **`jira`**: unlink inward/outward pair, link again (`Related` vs `Relates` on redhat.atlassian.net); verify with `jira issue view`. |
| [workspace/public-repo-hygiene.md](workspace/public-repo-hygiene.md) | **Public sharing:** gitignore for Playwright dumps and cluster screenshots; redact personal Quay/catalog/cluster URLs in wiki. |
| [workspace/public-push.md](workspace/public-push.md) | **Public push:** post–`filter-repo` verification, gitleaks gate, force-push checklist. |

## Concepts

| Page | Summary |
|------|---------|
| [../docs/architecture/c4/README.md](../docs/architecture/c4/README.md) | **C4 architecture** for Cost Management on-prem (context, containers, Koku/UI components, data flows, repo map). |

## Topics

| Page | Summary |
|------|---------|
| [topics/ui-verification-and-e2e.md](topics/ui-verification-and-e2e.md) | **Cursor harness:** acceptance criteria on entity pages; mandatory **UI E2E** when the stream modifies UI. |
| [topics/onprem-playwright-e2e.md](topics/onprem-playwright-e2e.md) | **`koku-ui-onprem/cypress/`:** `integration/` vs `live/` e2e; `test:cypress:live` after `start:onprem:dev` — **not CI**. |
| [topics/onprem-ui-cluster-image.md](topics/onprem-ui-cluster-image.md) | **Cluster UI image:** on-demand GHA amd64 build → Quay; local Helm rollout + in-pod manifest verify (not Mac amd64 podman). |

## Entities

| Page | Summary |
|------|---------|
| [entities/demo-catalog-cost-onprem-install.md](entities/demo-catalog-cost-onprem-install.md) | Demo Catalog SNO install order; RHBK; **UI login bounce** (Envoy JWT + Keycloak declarative profile); RHBK CSV duplicate OG; debug commands; ingress tag expiry note. |
| [entities/known-issue-keycloak-declarative-profile-jwt.md](entities/known-issue-keycloak-declarative-profile-jwt.md) | **Known issue:** Keycloak default user profile drops `org_id`/`account_number` → Envoy 401 → UI re-login; skill script workaround + scenarios. |
| [entities/known-issue-rhbk-csv-too-many-operatorgroups.md](entities/known-issue-rhbk-csv-too-many-operatorgroups.md) | **Known issue:** RHBK CSV **Failed** (`TooManyOperatorGroups`); skill script `rhbk-fix-csv-too-many-operatorgroups.sh` (`verify` / `fix`). |
| [entities/flpath-4180-fec-rbac-mfe.md](entities/flpath-4180-fec-rbac-mfe.md) | **FLPATH-4180:** FEC `ExtensionsPlugin` vs on-prem Scalprum + `DynamicRemotePlugin`; research closeout (unblocks **FLPATH-4164**). |
| [entities/flpath-4164-rbac-mfe-poc.md](entities/flpath-4164-rbac-mfe-poc.md) | **FLPATH-4164:** RBAC MFE POC — plan phases, acceptance criteria, cluster deploy, visual-compare assets. |
| [entities/sources-ui-reference.md](entities/sources-ui-reference.md) | **`sources-ui` submodule:** SaaS Platform Sources UI reference; backend **sources-api-go** (not checked out); vs on-prem `koku-ui-sources`. |

## Sources ingested

*(Link summary pages for material under `wiki/raw/` after ingest.)*
