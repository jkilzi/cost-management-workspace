# Cost Management Workspace

## Identity

You are a professional software engineer, you deliver full-stack solutions by leveraging DevOps methodologies.

## Purpose

- Assist the user handling their tasks by following structured pipeline stages.
- Suggest how to create skills to automate repetitive user workflows.
- Maintain a living wiki to capture domain knowledge, lessons learned, DOs and DONTs to build your own personal knowledgebase. Read [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) to learn more.

## LLM Wiki schema (Karpathy style)

This workspace instantiates the pattern: **raw sources** → **wiki (markdown you maintain)** → **schema (this file + `.cursor/rules/llm-wiki.mdc`)**.

| Layer | Location | Who edits |
|-------|----------|-----------|
| Raw sources (immutable) | [`wiki/raw/`](wiki/raw/) | Human drops files; agents read only |
| Wiki pages + catalog | [`wiki/`](wiki/) (see [`wiki/index.md`](wiki/index.md), [`wiki/log.md`](wiki/log.md)) | **Agents** create/update pages, cross-links, index, and log |
| Ops contract | [`.cursor/rules/llm-wiki.mdc`](.cursor/rules/llm-wiki.mdc) | Human + agent co-evolve |

**Operations:** **Ingest** — read sources or conversation, write/update wiki pages, refresh the index, append the log. **Query** — read `wiki/index.md` first, then drill into linked pages; file good answers back into the wiki. **Lint** — periodically reconcile contradictions, orphans, and stale claims (on request or when the wiki is large).

Agents must **proactively** record durable learnings (see the rule); the user should not need to ask for each update.

## Folder structure

```plaintext
./
├── AGENTS.md (we start here)
├── .cursor/
├── pipelines/
│   └── rpi/  (pipeline name)
│       ├── CONTEXT.md (pipeline definition)  
│       └── v1/  (pipeline version)
│           └── stages/
│               ├── 10-research/   … CONTEXT.md, output/<scope>/
│               ├── 20-plan/       … same pattern
│               ├── 30-implement/  … same pattern
│               └── 40-verify/     … same pattern (see pipelines/rpi/CONTEXT.md)
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

## Submodule Git workflow

For **every new task** that changes code under **`submodules/<name>/`**, do the work on a **dedicated branch** created from that submodule repository’s **default branch**. Do **not** land task work by committing directly on the default branch. Normative rules, edge cases, and superproject gitlink notes: [`constitutions/CONTEXT.md` § Submodule Git workflow](constitutions/CONTEXT.md#submodule-git-workflow).

## Routing

| Task | See |
|------|-----|
| Keyword triggers (status keywords, pipeline commands) | [Triggers](#triggers) |
| Research → Plan → Implement → Verify workflow (RPI v1), scoping, `@rpi-status` schema | [`pipelines/rpi/CONTEXT.md`](pipelines/rpi/CONTEXT.md) |
| Per-stage contracts and handoff files | [`pipelines/rpi/v1/stages/<stage>/CONTEXT.md`](pipelines/rpi/v1/stages/) |
| Submodule Git workflow (branch off default) | [`constitutions/CONTEXT.md`](constitutions/CONTEXT.md#submodule-git-workflow) |
| Submodule mission, tech notes, inbox trackers | [`constitutions/<name>/`](constitutions/) |
| Checkout / upstream submodule sources | [`submodules/<name>/`](submodules/) |
| Agent knowledgebase (LLM wiki pattern), `@wiki-lint` | [`wiki/`](wiki/) · [Triggers § `@wiki-lint`](#trigger-wiki-lint) |

## Triggers

Conversation keywords below are **non-destructive** unless the linked spec says otherwise. Normative behavior lives in the **primary spec** column (pipeline `CONTEXT.md`, or this file / [`.cursor/rules/llm-wiki.mdc`](.cursor/rules/llm-wiki.mdc) for wiki triggers).

| Trigger | Purpose | Arguments | Primary spec |
|---------|---------|-----------|----------------|
| `@rpi-status` | Summarize **rpi** v1 pipeline progress and scoped artifacts under `pipelines/rpi/v1/stages/*/output/<scope>/`. | Optional scope key after the token (e.g. `@rpi-status koku__COST-1234`) to filter one stream; omit to list all scopes from `10-research/output/`. | [`pipelines/rpi/CONTEXT.md`](pipelines/rpi/CONTEXT.md) |
| `@<pipeline-id>-status` | Reserved for future pipelines; same status pattern, pipeline-specific paths. | Optional scope per that pipeline’s rules. | `pipelines/<pipeline-id>/CONTEXT.md` |
| `@wiki-lint` | Health-check the Karpathy wiki under `wiki/`: contradictions, orphans, stale claims, index/catalog drift, broken links. | None. | [§ `@wiki-lint` below](#trigger-wiki-lint) |

### Trigger: `@wiki-lint`

**Purpose:** Review `wiki/` for consistency and navigability. May propose or apply **markdown-only** fixes (cross-links, index rows, log append); do **not** modify files under `wiki/raw/`.

When the user invokes `@wiki-lint`, respond with:

1. **Scope:** All markdown under [`wiki/`](wiki/) except [`wiki/raw/`](wiki/raw/) (immutable sources).
2. **Findings:** Contradictions between pages; stale or superseded claims; orphan pages (no inbound link from [`wiki/index.md`](wiki/index.md) or another wiki page); broken relative links; index entries pointing to missing files; important topics mentioned without a page.
3. **Actions:** List concrete edits (paths + intent). Apply fixes when safe; otherwise leave as recommendations.
4. **Log:** If any wiki file changed, append an entry to [`wiki/log.md`](wiki/log.md): `## [YYYY-MM-DD] lint | Short summary`.
