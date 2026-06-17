---
type: Workspace
title: Workspace overview
description: Cost Management meta-workspace structure; Karpathy wiki, constitutions, submodules, and Cursor harness layout.
tags: [workspace, overview, cursor-harness, submodules]
timestamp: 2026-06-17T00:00:00Z
---

# Workspace overview

This repository is a **Cost Management** meta-workspace: the Karpathy wiki, per-submodule constitutions, checkout copies under `submodules/`, and the Cursor harness (`.cursor/rules`, `.cursor/skills`, `.cursor/plans`).

## Wiki role

The wiki is the **compounding layer**: durable, cross-cutting knowledge that should not be re-derived every session. Submodule upstream truth lives in `submodules/<name>/`. The wiki links and summarizes what matters **across** those boundaries.

## Jira without a public repo

Research and status live in **`wiki/entities/`** and Jira comments. **Jira comments that only list file paths are not enough** for most readers. See **[Jira handoff when this workspace is not published](jira-handoff-without-public-repo.md)** for the recommended pattern (self-contained Jira text + carry-forward into the implementation ticket; optional attachments).

**Issue links:** To replace **Blocks** with **Related** (or any type change), Jira has no in-place edit — use **`jira issue unlink`** then **`jira issue link`** — see **[Jira CLI: change issue link type](jira-cli-issue-links.md)**.

**Public sharing:** Redact personal Quay, Demo Catalog, and workshop cluster URLs before publishing; see **[Public repo hygiene](public-repo-hygiene.md)** and **[Public push](public-push.md)** (history scrub + gitleaks).

## Related

- [Entry index](../index.md)
- [Demo Catalog + cost-onprem install](../entities/demo-catalog-cost-onprem-install.md)
- [cost-onprem-chart install skill](../../.cursor/skills/cost-onprem-chart-install/SKILL.md)
- [AGENTS.md](../../AGENTS.md) — identity, routing, triggers
- [`.cursor/rules/workspace-workflow.mdc`](../../.cursor/rules/workspace-workflow.mdc) — scoped work without RPI pipeline
- [UI verification and E2E](../topics/ui-verification-and-e2e.md)
- [`.cursor/rules/llm-wiki.mdc`](../../.cursor/rules/llm-wiki.mdc) — wiki layers, `@wiki-lint`
- Submodule Git: [`.cursor/rules/submodule-git-workflow.mdc`](../../.cursor/rules/submodule-git-workflow.mdc)
