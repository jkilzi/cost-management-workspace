---
name: constitutions-tracker-format
description: >-
  Submodule Git workflow (branch from default in submodules/) and formatting for
  constitutions/*/tracker.md: task checkboxes, ID, Source, Jira, Notes.
  Use when editing constitutions trackers, logging submodule touch work, creating
  branches in submodules, or managing the Inbox for koku, koku-ui, or cost-onprem-chart.
---

# Constitutions (workspace)

Normative rules for work tracked under `constitutions/<project>/` and checkouts under `submodules/`.

## Submodule Git workflow

These rules apply to each **upstream repository** checked out under **`submodules/<name>/`** (for example `koku`, `koku-ui`, `cost-onprem-chart`).

### Branch from default for every new task

1. **Start from default:** Before making changes for a **new** task, ensure the submodule repo is based on its **default branch** (often `main` or `master`—confirm with `git remote show origin` or `git symbolic-ref refs/remotes/origin/HEAD` in that submodule).
2. **Use a dedicated branch:** Create a **separate branch** from that default branch for the task. All commits for that task live on this branch until they are reviewed and merged via the upstream project’s normal process (for example a pull request).
3. **Do not use the default branch for task work:** Do not push task commits directly to the default branch. Reserve the default branch for merges from reviewed branches and for fast-forwarding after upstream integration.

### Superproject (this workspace) gitlink

When a submodule’s checked-out commit changes, **record the new gitlink** in the workspace root: `git add <submodule-path>` and commit at the superproject so other clones pin the same submodule revision.

### Exceptions

If a project needs a different rule (for example an agreed hotfix path), document it in **`constitutions/<name>/constitution.md`** and follow that override; otherwise follow this section.

## Tracker entries

These rules apply to every `tracker.md` under `constitutions/<project>/`.

### Add or update an entry

1. Use **one top-level bullet** per work item in the **Inbox** section (or a later section you add).
2. Start that bullet with a **task checkbox** for status:
   - `[ ]` — open / not done
   - `[x]` — done
3. On **indented lines immediately below** that bullet, include these fields (each on its own line, same indent level):
   - **ID** — optional correlation id (you may reuse a Jira key as the id).
   - **Source** — where the request came from (chat, stakeholder, internal doc, etc.).
   - **Jira** — full URL to the issue when applicable; omit this line or use `N/A` when there is no Jira issue.
   - **Notes** — context, PR links, follow-ups, cross-links to other trackers if work spans submodules.

### Example

```markdown
## Inbox

- [ ] Short summary of the work (this line carries the checkbox status)
  - **ID:** COST-1234
  - **Source:** Team backlog grooming
  - **Jira:** https://redhat.atlassian.net/browse/COST-1234
  - **Notes:** Land in koku first; UI follow-up tracked separately if needed.
```

### Done state

When an item is finished, set the parent bullet to `[x]` and keep the detail lines for history unless you intentionally archive them elsewhere.

### After saving

- **List nesting:** There must be **no blank line** between the `- [ ]` / `- [x]` line and the first `- **ID:**` line. Every detail line must use the **same indent** as in the example (two spaces before each leading `-` on those sub-bullets).
- **Quick scan:** Each work item is one checkbox bullet followed only by indented `- **ID:**` / `- **Source:**` / `- **Jira:**` / `- **Notes:**` lines as applicable (omit **Jira** entirely or use `N/A` per the rules above). No other bullet shapes belong in that block.
- **Duplicate IDs:** If **ID** must be unique among open items, do not reuse the same **ID** value on multiple lines with `[ ]` unless that is intentional.
