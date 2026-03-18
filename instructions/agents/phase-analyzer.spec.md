# Specification: phase-analyzer

## Description

Analyzes Plan Phases to recommend Plan Mode Strategy based on codebase measurement.

## Platform Topics

None — phase-analyzer does not invoke platform primitives. It is delegated TO, not delegating.

## Delegated Agents

None — phase-analyzer is a leaf agent.

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `lexis` | `phase-analyzer` (constitution) |
| `hermes` | `request:phase-analysis`, `response:phase-analysis` |

## Required Capabilities

| Capability | Purpose |
|------------|---------|
| File reading | Read PLAN.md, source files for measurement |
| File search | Glob for target files matching deliverables |
| Content search | Grep for patterns, imports, dependencies |
| Shell execution | Run `blueprint` CLI commands (read-only) |

## Special Requirements

- Must measure ALL 5 dimensions for every Task with specific evidence
- External dependency rule: automatic High (3) minimum for dependency dimension
- Conservative scoring when uncertain (round up)
- Shell execution restricted to read-only operations
- Handoff format must match `hermes response:phase-analysis` schema
