# Specification: code-quality-reviewer

## Description

Reviews code changes for quality issues — redundant state, parameter sprawl, copy-paste, leaky abstractions, stringly-typed code, and standards violations.

## Platform Topics

None — code-quality-reviewer is a leaf agent, delegated TO by verify.

## Delegated Agents

None.

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `lexis` | `--base` (base constitution for standards check) |
| `hermes` | `response:verify:production` (output format) |

## Required Capabilities

| Capability | Purpose |
|------------|---------|
| File reading | Read source files and surrounding context |
| Content search | Search for patterns, duplications |
| File search | Find related files for context |
| Shell execution | Run `blueprint` CLI commands |

## Special Requirements

- Must check all 6 review categories systematically
- Constitution standards (via `lexis --base`) must be loaded and checked
