---
name: RPI scope ticket default
overview: Update the RPI v1 normative docs so `<scope>` defaults to the Jira issue key (normalized for directory names), document the cross-submodule rationale, and require a fixed user prompt when there is no ticket—replacing the old submodule-first and `submodule__ticket` defaults.
todos:
  - id: spec-scope-section
    content: Rewrite Output scoping + @rpi-status example in pipelines/rpi/SPEC.md
    status: completed
  - id: research-spec-process
    content: "Update 10-research/SPEC.md process: ticket default + exact non-Jira prompt"
    status: completed
  - id: agents-example
    content: Refresh @rpi-status scope example in AGENTS.md
    status: completed
  - id: stale-phrase-sweep
    content: Grep and fix any leftover submodule-default / old composite examples
    status: completed
isProject: false
---

# RPI scope: ticket-id default + explicit non-Jira ID

## Goal

Align pipeline output scoping with your intent:

- **Default `<scope>`:** the **Jira ticket id** (normalized to match the existing grammar `[a-z0-9-]+`, e.g. `flpath-4164`). **Rationale (normative text):** one issue often spans multiple [`submodules/`](submodules/); a single scope tree keeps research/plan/verify artifacts unified for the whole task.
- **No Jira ticket:** do **not** invent a scope silently. Ask exactly: **"What scope ID should I assign to this workstream?"** The user’s answer becomes `<scope>` (still must satisfy `[a-z0-9-]+`; if invalid, ask again or suggest a slug).

## Files to change (documentation only)

| File | Change |
|------|--------|
| [`pipelines/rpi/SPEC.md`](pipelines/rpi/SPEC.md) | Rewrite **Output scoping (`<scope>`)** (lines ~25–33): keep collision rationale; replace submodule default and `Parallel work: {submodule}__{work-id}` with ticket-default + non-Jira prompt; keep optional `__` **only** for disambiguation when two concurrent streams need different trees for the **same** ticket—e.g. `{ticket}__{short-suffix}` agreed with the user (supersedes the old `koku__COST-1234` example). Update **`@rpi-status`** example argument (line ~63) to a ticket-style scope (e.g. `@rpi-status flpath-4164`). |
| [`pipelines/rpi/v1/stages/10-research/SPEC.md`](pipelines/rpi/v1/stages/10-research/SPEC.md) | **Process** step 1 (currently “default: submodule folder basename”): require deriving `<scope>` from the Jira key when a ticket is in scope; if there is **no** ticket, **stop and ask** the exact prompt above before creating `output/<scope>/`. Clarify “when ambiguous” = e.g. multiple tickets, or ticket vs ad-hoc id—still user agreement, not silent submodule default. |
| [`AGENTS.md`](AGENTS.md) | Update the `@rpi-status` trigger row example scope to match the new convention (same as SPEC example). |

## What stays the same

- **Path pattern** and **artifact chain** unchanged.
- **[`SCOPE.md`](pipelines/rpi/v1/stages/10-research/SPEC.md)** continues to list **all submodules touched** (and correlation id); only the **directory name** (`<scope>`) policy changes—multi-repo work is captured inside one tree, not by splitting scope per submodule.
- **[`.cursor/rules/rpi-pipeline.mdc`](.cursor/rules/rpi-pipeline.mdc)** already points to SPEC for `<scope>` naming; no edit required unless you want a one-line reminder (optional).

## Legacy directories

Existing scopes such as `cost-onprem-chart__flpath-4164` remain **valid paths** on disk; the spec should state that **older scope directory names are not invalid**, but **new** streams follow the updated default. No mass renames or migration scripts in this pass.

## Optional follow-up (out of plan unless you want it)

- **Wiki:** per [`.cursor/rules/llm-wiki.mdc`](.cursor/rules/llm-wiki.mdc), append [`wiki/log.md`](wiki/log.md) and a short note (e.g. under [`wiki/workspace/overview.md`](wiki/workspace/overview.md) or a dedicated ops page) so future sessions do not re-litigate scope rules.

## Verification

- Grep the repo for stale phrases: `submodule folder basename`, `koku__COST`, `one stream per submodule`, `Parallel work** in the same submodule` and update any remaining hits.
