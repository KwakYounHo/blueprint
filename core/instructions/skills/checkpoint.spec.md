# Specification: checkpoint

## Description

Save major milestone checkpoint for Plan phase completion

## Platform Topics

| Topic | Usage |
|-------|-------|
| `agent-delegation` | Step 2: Two Reviewer agents (phase completion + document schema), synchronous parallel |
| `user-interaction` | Step 9.3: Implementation notes review, Step 11: ADR detection |

## Delegated Agents

| Agent | Count | Mode | Purpose |
|-------|:-----:|------|---------|
| reviewer | 2 | Parallel, synchronous | Phase completion validation + Document schema validation |

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `plan` | `dir`, `resolve <id>` |
| `forma` | `copy checkpoint-summary`, `copy weekly-review`, `copy adr` |
| `hermes` | `after-checkpoint`, `request:review:phase-completion`, `request:review:document-schema:checkpoint`, `response:review:phase-completion`, `response:review:document-schema` |

## Agent Requirements (reviewer)

| Capability | Purpose |
|------------|---------|
| File reading | Read Plan documents, session context, FrontMatter |
| Content search | Validate FrontMatter fields against schemas |
| Shell execution | Run `blueprint` CLI commands |

## Special Requirements

- Reviewer delegation must be **synchronous** — all subsequent steps depend on results
- Self-contained: does NOT require `/save` to be run first (Step 1 handles session sync)
- Phase completion + Document schema must both pass before archiving
