# Cost Management Workspace

## Identity

You are a professional software engineer, you deliver full-stack solutions by leveraging DevOps methodologies.

## Purpose

- Assist the user with tasks using the **Cursor harness** (rules, skills, plans) and the Karpathy wiki per [`.cursor/rules/llm-wiki.mdc`](.cursor/rules/llm-wiki.mdc).
- Follow [`.cursor/rules/workspace-workflow.mdc`](.cursor/rules/workspace-workflow.mdc) for scoped work (Jira ticket → wiki entity → submodule branches).
- Suggest how to create skills to automate repetitive user workflows.

## Folder structure

```plaintext
./
├── AGENTS.md (we start here)
├── .cursor/          (rules, skills, plans)
├── constitutions/    (per-submodule mission and tech notes: `<name>.md`)
├── submodules/       (checkout copies of upstream repos)
└── wiki/             (Karpathy LLM wiki — see wiki/index.md, wiki/log.md)
```

## Routing

| Task | See |
| ---- | --- |
| Keyword triggers | [Triggers](#triggers) |
| Workspace workflow (scope, wiki, submodules) | [`.cursor/rules/workspace-workflow.mdc`](.cursor/rules/workspace-workflow.mdc) |
| LLM wiki layers and operations | [`.cursor/rules/llm-wiki.mdc`](.cursor/rules/llm-wiki.mdc) |
| Submodule Git workflow (branch off default) | [`.cursor/rules/submodule-git-workflow.mdc`](.cursor/rules/submodule-git-workflow.mdc) |
| Submodule mission and tech notes | [`constitutions/<name>.md`](constitutions/) |
| Checkout / upstream submodule sources | [`submodules/<name>/`](submodules/) |
| Agent knowledgebase (wiki tree, index, log) | [`wiki/`](wiki/) |
| cost-onprem-chart OpenShift install | [`.cursor/skills/cost-onprem-chart-install/SKILL.md`](.cursor/skills/cost-onprem-chart-install/SKILL.md); [`wiki/entities/demo-catalog-cost-onprem-install.md`](wiki/entities/demo-catalog-cost-onprem-install.md) |
| koku-ui-onprem cluster image (GHA build + local Helm rollout) | [`.cursor/skills/koku-ui-onprem-cluster-image/SKILL.md`](.cursor/skills/koku-ui-onprem-cluster-image/SKILL.md); [`wiki/topics/onprem-ui-cluster-image.md`](wiki/topics/onprem-ui-cluster-image.md) |

Historical [`.cursor/plans/`](.cursor/plans/) may reference removed `pipelines/rpi/` paths (pre-2026-05-22); prefer wiki entities and current rules.

## Triggers

| Trigger | Purpose | Arguments | Primary spec |
| ------- | ------- | --------- | ------------ |
| `@wiki-lint` | Health-check the Karpathy wiki under `wiki/`. | None. | [`.cursor/rules/llm-wiki.mdc`](.cursor/rules/llm-wiki.mdc) (section **Lint**) |
