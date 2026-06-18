---
type: Entity
title: COST-7671 — Align RBAC UI with UX Requirements
description: UX requirements from Figma for adapting the RBAC MFE POC (COST-7654) to match the Cost Management UX design specs.
tags: [rbac, ux, figma, cost-management, koku-ui, flpath-4164]
timestamp: 2026-06-17T00:00:00Z
---

# COST-7671 — Align RBAC UI with UX Requirements

**Jira:** https://redhat.atlassian.net/browse/COST-7671  
**Type:** Sub-task | **Status:** In Progress | **Assignee:** Jonathan Kilzi  
**Parent chain:** COST-7589 → COST-7654 → **COST-7671**  
**Figma board:** https://www.figma.com/design/UFM3q6rv3W5lhw0JhmUnl9/RBAC?node-id=0-1&m=dev

## Context

Follows up on the RBAC MFE POC ([FLPATH-4164](flpath-4164-rbac-mfe-poc.md) / COST-7654). The POC federated `insights-rbac-ui` into `koku-ui-onprem`. This ticket adapts that POC output to meet Cost Management UX requirements captured in the Figma board above.

## UX Requirements (from Figma board — "RBAC images" page)

### 1. Users page — scope to Cost roles/permissions only

The User detail view must **only show roles and permissions belonging to the Cost application**. The upstream RBAC UI shows all roles across all apps — Cost scopes this down.

> Figma annotation (verbatim): *"Only showing cost roles and permission in the User detail"*

### 2. Application column in roles/permissions tables

Add an **"Application" column** to role/permission tables. The designer noted:

> *"I believe we'll need application column, cause there would be one for cost, integrations and rbac I think"*

This column disambiguates which app a role belongs to when multiple applications (cost, integrations, RBAC) share the same table view.

### 3. Users list page (image 17 — main annotated screen)

- Table columns: **Username**, **Email**, **Last login**, **Org admin** (badge/indicator).
- Clicking a user opens a detail panel/drawer — shows that user's roles and permissions **filtered to Cost**.

### 4. Roles list & detail views (images 1–6)

- Roles list: table with **Role name**, **Description**, and **Permission count** columns.
- Role detail: permission breakdown with **Resource type** and **Operation** columns.
- Role create/edit: multi-step wizard (existing upstream flow, style-adapted to PF6).

### 5. Groups / Workspaces views (images 7–15)

- Later screens show **Groups** or **Workspaces** — organizational units that roles are assigned to.
- Wider layout (~1800 px) used for workspace screens (images 11–14); these render in the main content area, not a drawer.
- Screens show **nested workspace hierarchies** with roles assignable at each level.

## Screens inventory

| # | Figma node | Screen | Key delta from POC |
|---|------------|--------|--------------------|
| 17 | `3:57` | Users page (annotated) | Show only Cost roles; add App column |
| 1 | `3:3` | Roles list | App column; Cost filter |
| 2 | `3:6` | Role detail | App column; Cost filter |
| 3 | `3:13` | Role detail (alt state) | App column; Cost filter |
| 4 | `3:18` | Permission detail / wizard | PF6 style alignment |
| 5 | `3:21` | Roles wizard step | PF6 style alignment |
| 6 | `3:24` | Roles wizard step | PF6 style alignment |
| 7 | `3:27` | Group/workspace list | Potentially new |
| 8 | `3:30` | Group/workspace list (alt) | Potentially new |
| 9 | `3:33` | Group detail | Potentially new |
| 10 | `3:36` | Workspace overview | Potentially new |
| 11–14 | `3:39`–`3:48` | Workspace role assignment (wide) | Wider layout, nested hierarchy |
| 15 | `3:51` | Final confirmation screen | TBD |

## Acceptance criteria (TBD — pending detailed review)

- [ ] Users page shows only Cost-scoped roles/permissions in the user detail panel
- [ ] All roles/permission tables include an "Application" column
- [ ] Role wizard UX matches Figma screens 4–6 (PF6 styles)
- [ ] Workspace/Group screens (7–15) implemented if in scope for this ticket

## Related

- [FLPATH-4164 — RBAC MFE POC](flpath-4164-rbac-mfe-poc.md)
- [rbac-ui-onprem shims](../topics/rbac-ui-onprem-shims.md)
- [rbac-ui-onprem vendor submodule](../topics/rbac-ui-onprem-vendor.md)
