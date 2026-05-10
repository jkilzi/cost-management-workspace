# Cost Management Workspace

## Identity

You are a professional software engineer, you deliver full-stack solutions by leveraging DevOps methodologies.

## Purpose

- Assist the user handling their tasks by following structured pipeline stages per `[.cursor/rules/rpi-pipeline.mdc](.cursor/rules/rpi-pipeline.mdc)`.
- Suggest how to create skills to automate repetitive user workflows.
- Maintain the workspace wiki per `[.cursor/rules/llm-wiki.mdc](.cursor/rules/llm-wiki.mdc)`.

## Folder structure

```plaintext
./
├── AGENTS.md (we start here)
├── .cursor/
├── pipelines/
│   └── rpi/  (pipeline name)
│       ├── SPEC.md (pipeline definition)  
│       └── v1/  (pipeline version)
│           └── stages/
│               ├── 10-research/   … SPEC.md, output/<scope>/
│               ├── 20-plan/       … same pattern
│               ├── 30-implement/  … same pattern
│               └── 40-verify/     … same pattern (see pipelines/rpi/SPEC.md)
├── constitutions/  (per-submodule mission, tech stack, workspace work trackers)
│   ├── cost-onprem-chart/
│   ├── koku/
│   └── koku-ui/
├── submodules/
│   ├── cost-onprem-chart/
│   ├── koku/
│   ├── koku-ui/
│   └── ... (other submodules)
└── wiki/  (Karpathy LLM wiki — agents maintain pages; see wiki/index.md, wiki/log.md; raw drops in wiki/raw/)
```

## Routing


| Task                                                        | See                                                                                                                                                                                                                                      |
| ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Keyword triggers (status keywords, pipeline commands)       | [Triggers](#triggers)                                                                                                                                                                                                                    |
| RPI v1 pipeline (layered specs, scoping, `@rpi-status`) | `[.cursor/rules/rpi-pipeline.mdc](.cursor/rules/rpi-pipeline.mdc)` (index); `[pipelines/rpi/SPEC.md](pipelines/rpi/SPEC.md)` (pipeline spec); `[pipelines/rpi/v1/stages/<stage>/SPEC.md](pipelines/rpi/v1/stages/)` (per-stage) |
| LLM wiki layers and operations (summary)                    | `[.cursor/rules/llm-wiki.mdc](.cursor/rules/llm-wiki.mdc)`                                                                                                                                                                               |
| Submodule Git workflow (branch off default)                 | `[.cursor/rules/submodule-git-workflow.mdc](.cursor/rules/submodule-git-workflow.mdc)`                                                                                                                                                   |
| Submodule mission, tech notes, inbox trackers               | `[constitutions/<name>/](constitutions/)`                                                                                                                                                                                                |
| Checkout / upstream submodule sources                       | `[submodules/<name>/](submodules/)`                                                                                                                                                                                                      |
| Agent knowledgebase (wiki tree, index, log)                 | `[wiki/](wiki/)`                                                                                                                                                                                                                         |
| cost-onprem-chart OpenShift install (order, scripts, pitfalls) | `[.cursor/skills/cost-onprem-chart-install/SKILL.md](.cursor/skills/cost-onprem-chart-install/SKILL.md)`; leased-cluster notes in [`wiki/entities/demo-catalog-cost-onprem-install.md`](wiki/entities/demo-catalog-cost-onprem-install.md) |


## Triggers

Conversation keywords below are **non-destructive** unless the linked spec says otherwise. Normative behavior lives in the **primary spec** column (pipeline: `[.cursor/rules/rpi-pipeline.mdc](.cursor/rules/rpi-pipeline.mdc)` indexes `[pipelines/rpi/SPEC.md](pipelines/rpi/SPEC.md)`; wiki: `[.cursor/rules/llm-wiki.mdc](.cursor/rules/llm-wiki.mdc)` and `@wiki-lint`).


| Trigger                 | Purpose                                                                                                                 | Arguments                                                                                                                                         | Primary spec                                                                                                                                               |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `@rpi-status`           | Summarize **rpi** v1 pipeline progress and scoped artifacts under `pipelines/rpi/v1/stages/*/output/<scope>/`.          | Optional scope key after the token (e.g. `@rpi-status koku__COST-1234`) to filter one stream; omit to list all scopes from `10-research/output/`. | `[pipelines/rpi/SPEC.md](pipelines/rpi/SPEC.md)` (response schema); `[.cursor/rules/rpi-pipeline.mdc](.cursor/rules/rpi-pipeline.mdc)` (layer index) |
| `@<pipeline-id>-status` | Reserved for future pipelines; same status pattern, pipeline-specific paths.                                            | Optional scope per that pipeline’s rules.                                                                                                         | `pipelines/<pipeline-id>/SPEC.md`                                                                                                                       |
| `@wiki-lint`            | Health-check the Karpathy wiki under `wiki/`: contradictions, orphans, stale claims, index/catalog drift, broken links. | None.                                                                                                                                             | `[.cursor/rules/llm-wiki.mdc](.cursor/rules/llm-wiki.mdc)` (section **Lint**)                                                                              |


