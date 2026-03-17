# Specification: bplan

## Description

Apply Plan workflow for creating structured implementation plans

## Platform Topics

| Topic | Usage |
|-------|-------|
| `plan-mode` | Task Implementation checklist: Plan Mode entry per Task |
| `agent-delegation` | Gate Validation: Reviewer agent for Plan document validation |

## Delegated Agents

| Agent | Count | Mode | Purpose |
|-------|:-----:|------|---------|
| reviewer | 1 | Synchronous | Plan document validation against Gate criteria |

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `plan` | `dir`, `resolve <id>` |
| `forma` | `list`, `copy plan`, `copy brief`, `copy roadmap`, `copy implementation-notes`, `copy current-standard`, `copy todo`, `copy history`, `show` |
| `frontis` | `schema plan` |
| `lexis` | `--base` (project constitution) |
| `hermes` | Reviewer handoff forms |

## Agent Requirements (reviewer)

| Capability | Purpose |
|------------|---------|
| File reading | Read Plan documents for validation |
| Content search | Check FrontMatter fields, search for markers |
| Shell execution | Run `blueprint` CLI commands |

## Special Requirements

- 3-phase progressive planning: Analysis & Brief → Plan → Session Context Init
- Phase transitions REQUIRE user confirmation
- [DECIDE] markers require user input — never auto-resolve
- After Plan approval, guide user to run `banalyze`
