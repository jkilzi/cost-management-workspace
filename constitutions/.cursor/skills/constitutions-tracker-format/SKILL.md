---
name: constitutions-tracker-format
description: >-
  Formats new and updated lines in workspace constitutions/*/tracker.md files:
  task checkboxes for status, ID, Source, Jira link when applicable, Notes.
  Use when editing constitutions trackers, logging submodule touch work, or
  managing the Inbox for koku, koku-ui, or cost-onprem-chart.
---

# Constitutions tracker entries

These rules apply to every `tracker.md` under `constitutions/<project>/`.

## Add or update an entry

1. Use **one top-level bullet** per work item in the **Inbox** section (or a later section you add).
2. Start that bullet with a **task checkbox** for status:
   - `[ ]` — open / not done
   - `[x]` — done
3. On **indented lines immediately below** that bullet, include these fields (each on its own line, same indent level):
   - **ID** — optional correlation id (you may reuse a Jira key as the id).
   - **Source** — where the request came from (chat, stakeholder, internal doc, etc.).
   - **Jira** — full URL to the issue when applicable; omit this line or use `N/A` when there is no Jira issue.
   - **Notes** — context, PR links, follow-ups, cross-links to other trackers if work spans submodules.

## Example

```markdown
## Inbox

- [ ] Short summary of the work (this line carries the checkbox status)
  - **ID:** COST-1234
  - **Source:** Team backlog grooming
  - **Jira:** https://redhat.atlassian.net/browse/COST-1234
  - **Notes:** Land in koku first; UI follow-up tracked separately if needed.
```

## Done state

When an item is finished, set the parent bullet to `[x]` and keep the detail lines for history unless you intentionally archive them elsewhere.

## After saving

- **List nesting:** There must be **no blank line** between the `- [ ]` / `- [x]` line and the first `- **ID:**` line. Every detail line must use the **same indent** as in the example (two spaces before each leading `-` on those sub-bullets).
- **Quick scan:** Each work item is one checkbox bullet followed only by indented `- **ID:**` / `- **Source:**` / `- **Jira:**` / `- **Notes:**` lines as applicable (omit **Jira** entirely or use `N/A` per the rules above). No other bullet shapes belong in that block.
- **Duplicate IDs:** If **ID** must be unique among open items, do not reuse the same **ID** value on multiple lines with `[ ]` unless that is intentional.
