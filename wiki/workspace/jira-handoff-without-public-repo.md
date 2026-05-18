# Jira handoff when this workspace is not published

Pipeline research (`pipelines/rpi/v1/stages/10-research/output/<scope>/`) is authoritative for agents and for humans who have the git checkout. **Jira users without repo access** cannot follow raw paths in comments.

## Ranked options

| Approach | Discoverability | Drift risk | Effort |
|----------|-----------------|------------|--------|
| **A. Self-contained Jira text** — paste executive summary + bullet facts + “next steps” in the ticket **description** (or a **closing comment**) | High for anyone with Jira | Update Jira when conclusions change | Low |
| **B. Jira attachments** — export `RESEARCH.md` / `QUESTIONS.md` (or a single PDF) at closeout | High; works offline | Snapshot only; label with date | Low |
| **C. Downstream ticket (e.g. FLPATH-4164)** — copy the **minimum** implementer-facing block into the **active** story so builders never open 4180 | High for the team doing work | Duplicate; trim to essentials | Low |
| **D. Internal Confluence / team wiki** — one page per stream, link from Jira | High if org uses it | Two places to edit | Medium |
| **E. Publish only pipeline subtree** — e.g. gist, read-only mirror, or docs repo with copied markdown | Medium (link rot / sync) | Medium unless automated | Medium–High |

**Practical default:** **A + C** for every closed research ticket: (1) a **short closing comment** in Jira that fully answers the ticket goals without repo paths, and (2) the **implementation ticket** carries a **“Research conclusions (4180)”** subsection so **FLPATH-4164** is self-sufficient. Add **B** when legal/compliance wants an immutable snapshot.

## What to paste (checklist)

- One-line outcome (“FEC ExtensionsPlugin not used by rbac-ui webpack; on-prem uses Scalprum + explicit routes”).
- Bullet **facts** (chrome APIs, nav model, no second hostname).
- **Authoritative external links** only (e.g. `frontend-components` `docs/fed/consuming-module.md` on GitHub) — not paths inside this workspace.
- **Next steps** as prose tied to **FLPATH-4164** (MFE phases), not `PLAN.md` paths.

## Example stream

- **FLPATH-4180** — see closing comment on [FLPATH-4180](https://redhat.atlassian.net/browse/FLPATH-4180) and entity [FLPATH-4180 — FEC vs MFE](../entities/flpath-4180-fec-rbac-mfe.md) (links git for people who *do* have the repo).

## Close the RPI loop (no empty stages)

Even when **Jira** is the primary deliverable, add **`pipelines/rpi/v1/stages/30-implement/output/<scope>/IMPLEMENTATION_LOG.md`** (what you did: comments, transitions, wiki edits) and **`40-verify/output/<scope>/ACCEPTANCE_CRITERIA.md`** + **`VERIFICATION.md`** (**Pass** + human/Jira evidence) so **`@rpi-status`** shows **Done** through verify. Get human sign-off on acceptance criteria **before** writing final verification outcomes. See **`pipelines/rpi/v1/stages/30-implement/SPEC.md`** and **`40-verify/SPEC.md`** — *Non-code* / *Jira-primary* paragraphs; UI E2E gate: [RPI verify UI acceptance](../topics/rpi-verify-ui-acceptance.md).

