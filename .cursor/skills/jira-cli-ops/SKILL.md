---
name: jira-cli-ops
description: >-
  Operates Jira only via the jira CLI: list my open Jira issues and backlog or
  sprint work; add comments; create a new Jira ticket like an existing one;
  improve or rewrite ticket descriptions. Triggers: Jira tickets, my assigned
  issues, backlog, sprint tasks, add a Jira comment, create Jira issue, clone
  ticket, update Jira description, command-line Jira, jira CLI. Use when the
  user asks for Jira actions and wants them done with command-line tools only
  (no UI or REST shortcuts).
disable-model-invocation: true
---

# Jira CLI Operations (deterministic)

## Rules

- Jira CLI is the only source of truth; ignore browser/UI for decisions.
- Never run `jira` with `--debug` (security): debug output may expose Authorization credentials in logs.
- After every mutating command, verify with `jira issue view …` (or `--raw`) before declaring success.
- **`list_assigned`:** final answer for the user is **one** Markdown pipe table per the schema in **`list_assigned`** below (CLI-sourced cells only; never dump tab-separated CLI output as the finished reply).

## Intent routing

`list_assigned` | `add_comment` | `create_like` | `enhance_description`

One clarifying question if intent is ambiguous.

## Defaults

- Assignee: `assignee = currentUser()`
- Non-done: `statusCategory != Done`
- Projects (optional): `project = KEY` or `project IN (A,B)`
- Sort: `--order-by updated --reverse`
- Pages: `--paginate OFFSET:100`; advance OFFSET by 100 until a page has `<100` issues.

### Subtasks under a parent (components)

When creating **Sub-task** issues (`-t Sub-task -P PARENT-KEY`), **copy the parent’s Components onto the subtask** unless the user specifies otherwise.

1. Read names from the parent:  
   `jira issue view PARENT-KEY --raw | jq -r '(.fields.components // [])[].name'`
2. On **`jira issue create`**, pass **one `-C <name>` per component** from that list (`--component` replaces the whole set—include every name you want on the child).
3. If the parent has **no** components, leave the child unset unless the user asks for components explicitly.
4. Verify the child matches intent:  
   `jira issue view CHILD-KEY --raw | jq -r '(.fields.components // [])[].name'`  
   Prefer setting components **on create** rather than a follow-up **`issue edit`** (easier to forget; edits have sometimes hung).

---

### `list_assigned`

**Markdown table (mandatory for user replies):** header `| Type | Key | Summary | Status | Priority | Updated |` then `|---|---|---|---|---|---|`. Map `jira issue list --columns TYPE,KEY,…` → those headers; escape literal `|` in cells as `\|`; merge all pages into **one** table; zero rows → say “none” and include JQL.

1. JQL template: `assignee = currentUser() AND statusCategory != Done` plus optional `AND project …`.

2. Fetch (same JQL every page), then render the table above:

```bash
jira issue list -q '<JQL>' \
  --order-by updated --reverse \
  --plain --columns TYPE,KEY,SUMMARY,STATUS,PRIORITY,UPDATED \
  --paginate 0:100
```

`100:100`, `200:100`, … until `<100` rows. Row cells must match CLI output for that query (`--raw` allowed only to assemble rows if values stay identical to CLI).

3. **Machine / hierarchy:** paginate JSON for merging or trees:

```bash
jira issue list -q '<JQL>' \
  --order-by updated --reverse \
  --raw --paginate 0:100
```

Hierarchy from `--raw`: link via `fields.parent.key`; orphans → root + `no parent found`.

**jq (optional):** issue type — `jq -r '.fields.issuetype.name'`. Parent — `jq -r '.fields.parent.key // empty'`. Components — `jq -r '(.fields.components // [])[].name'`.

---

### `add_comment`

```bash
echo "Comment text" | jira issue comment add TICKET-123 --template - --no-input
jira issue view TICKET-123 --comments 5
```

---

### `create_like`

Targets: new issue in `-p TARGETPROJ` modeled on `SOURCE-KEY`. Preserve components from source; omit `-a` and `-y` on create; clear assignee/priority afterward if Jira defaulted them.

```bash
jira issue view SOURCE-KEY --raw
jira issue view SOURCE-KEY --raw | jq -r '(.fields.components // [])[].name'
jira issue create -p TARGETPROJ -t Story -s "…" -b $'…' -C CompOne -C CompTwo --no-input --raw
jira issue view NEWKEY --raw
```

Verify component names match source JSON; assignee and priority absent or cleared.

---

### `enhance_description`

```bash
jira issue view TICKET-123 --raw | jq -r '.fields.description'
printf '%s' "$NEW_BODY" | jira issue edit TICKET-123 --no-input
jira issue view TICKET-123 --raw
```

If descriptions use Atlassian Document Format, parse/update via CLI-fetched JSON only.

---

## Reply shape

Intent · JQL or keys · outcome · verification (writes). For `list_assigned`, include the Markdown table schema above or state clearly if empty.

## Failures

Empty search → print JQL. JQL error → print attempt and message. Write without verified read → partial success only.
