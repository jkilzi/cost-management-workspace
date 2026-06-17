---
type: Workspace
title: Jira CLI — change issue link type
description: Pattern for changing Jira link types using ankitpokhrel/jira-cli; unlink then re-link with desired type.
tags: [jira, jira-cli, workflow, issue-links]
timestamp: 2026-06-17T00:00:00Z
---

# Jira CLI: change issue link type (`jira` / ankitpokhrel/jira-cli)

Jira does **not** support editing a link’s type in place. The reliable pattern is **unlink the old relationship**, then **link again** with the desired type.

**Tooling:** [`jira issue unlink`](https://github.com/ankitpokhrel/jira-cli) and `jira issue link`. **Never** pass `--debug` to `jira` in this workspace (credentials can leak into logs) — see `.cursor/rules/jira-cli-no-debug.mdc`.

## 1. Confirm inward / outward keys (Blocks)

`jira issue unlink` and `jira issue link` take **inward issue** first, **outward issue** second — matching Jira’s link API.

For the standard **Blocks** type:

| Role | Usual meaning | Example (4180 blocked 4164) |
|------|----------------|-----------------------------|
| **Inward** | Issue that **is blocked by** the other | `FLPATH-4164` |
| **Outward** | Issue that **blocks** the other | `FLPATH-4180` |

Check the UI or plain view: `jira issue view FLPATH-4164 --plain` and read the **Linked Issues** section (e.g. `IS BLOCKED BY` → inward is `FLPATH-4164`, outward is `FLPATH-4180`).

## 2. Remove the old link

```bash
jira issue unlink FLPATH-4164 FLPATH-4180
```

If unlink fails, swap keys once — the CLI resolves the link id from the pair; direction must match how the link was created.

## 3. Add the new link type

```bash
jira issue link FLPATH-4164 FLPATH-4180 Related
```

The third argument must be the **exact link type name** returned by your Jira instance. On **redhat.atlassian.net** the symmetric “relates to” link is named **`Related`** (not `Relates`). If the name is wrong, the CLI prints **all** allowed names:

```text
Error: invalid issue link type "Relates"
Available issue link types are: 'Account', 'Blocks', ... 'Related', ...
```

**Interactive fallback:** run `jira issue link FLPATH-4164 FLPATH-4180` with **no** third argument — the CLI fetches types and prompts with `Name: inward description` options.

## 4. Verify

```bash
jira issue view FLPATH-4164 --plain
```

Under **Linked Issues**, **Blocks** / **IS BLOCKED BY** should be gone; **Related** / **RELATES TO** should appear for the same peer issue.

## Example: FLPATH-4180 ↔ FLPATH-4164 (2026-05-14)

Replaced **Blocks** (4164 was blocked by 4180) with **Related** so automation is not blocked by a closed issue while keeping traceability:

1. `jira issue unlink FLPATH-4164 FLPATH-4180`
2. `jira issue link FLPATH-4164 FLPATH-4180 Related`

See also: [jira-handoff-without-public-repo.md](jira-handoff-without-public-repo.md) (comments and carry-forward), entity [FLPATH-4180 — FEC vs MFE](../entities/flpath-4180-fec-rbac-mfe.md).
