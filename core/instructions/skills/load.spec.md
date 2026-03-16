# Specification: load

## Description

Load session state from Plan (adaptive)

## Platform Topics

| Topic | Usage |
|-------|-------|
| `agent-delegation` | Phase 1.5: Two Reviewer agents spawned in parallel, background preferred |

## Delegated Agents

| Agent | Count | Mode | Purpose |
|-------|:-----:|------|---------|
| reviewer | 2 | Parallel, background | Session state validation + Document schema validation |

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `plan` | `dir`, `list --status in-progress`, `resolve <id>` |
| `frontis` | `search`, `show` |
| `hermes` | `request:review:session-state`, `request:review:document-schema:session`, `response:review:session-state`, `response:review:document-schema`, `after-load:{mode}` |
| `project` | `show` (environment verification) |

## Agent Requirements (reviewer)

The delegated reviewer agents need:

| Capability | Purpose |
|------------|---------|
| File reading | Read Plan documents, session context, FrontMatter |
| Content search | Search for specific fields in FrontMatter |
| Shell execution | Run `blueprint` CLI commands |

## Special Requirements

- Reviewer delegation must be **non-blocking** — proceed to Phase 2 without waiting
- Phase 3 requires **yielding the turn** — end response to receive Reviewer signals
- Do NOT poll delegated agents' output at any point
