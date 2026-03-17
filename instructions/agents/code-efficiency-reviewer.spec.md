# Specification: code-efficiency-reviewer

## Description

Reviews code changes for efficiency issues — unnecessary work, hot-path bloat, runtime risks, side effects, and memory problems.

## Platform Topics

None — code-efficiency-reviewer is a leaf agent, delegated TO by verify.

## Delegated Agents

None.

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `lexis` | `--base` (base constitution) |
| `hermes` | `response:verify:production` (output format) |

## Required Capabilities

| Capability | Purpose |
|------------|---------|
| File reading | Read source files and trace data flow |
| Content search | Search for patterns, N+1 queries, duplicate calls |
| File search | Find related modules for impact analysis |
| Shell execution | Run `blueprint` CLI commands |

## Special Requirements

- Must check all 5 review categories systematically
- Severity must reflect production risk, not theoretical concern
