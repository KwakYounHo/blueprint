# Specification: banalyze

## Description

Orchestrate Phase Analyzer with parallel execution for all Phases

## Platform Topics

| Topic | Usage |
|-------|-------|
| `agent-delegation` | Step 4: Phase Analyzer agents spawned in parallel (1 per Phase) |
| `user-interaction` | Step 7: User decides Plan Mode per Phase, Step 10: Environment preparation prompts |

## Delegated Agents

| Agent | Count | Mode | Purpose |
|-------|:-----:|------|---------|
| phase-analyzer | 1 per Phase | Parallel, synchronous | 5-dimension evaluation per Phase |

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `plan` | `dir`, `list --status in-progress`, `resolve <id>` |
| `hermes` | `request:phase-analysis`, `response:phase-analysis` |
| `project` | `show <alias>` (environment detection) |

## Agent Requirements (phase-analyzer)

| Capability | Purpose |
|------------|---------|
| File reading | Read PLAN.md, source files for measurement |
| File search | Glob for target files, Grep for patterns |
| Shell execution | Run `blueprint` CLI commands |

## Special Requirements

- ALL Phase Analyzers MUST be spawned in a single message (parallel)
- Results written to PLAN.md "Analysis Results" section after user confirmation
- Environment preparation (worktree/branch) in Step 10
