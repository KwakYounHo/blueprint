# Specification: reviewer

## Description

Validates documents/code against Gate Aspects. Orchestrator assigns Gate with Aspects to review.

## Platform Topics

None — reviewer does not invoke platform primitives. It is delegated TO, not delegating.

## Delegated Agents

None — reviewer is a leaf agent.

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `aegis` | `--list`, `<gate> <aspect>` |
| `frontis` | `schema <type>` |
| `hermes` | `--list`, `<form>` (response forms) |
| `lexis` | `reviewer` (constitution) |

## Required Capabilities

| Capability | Purpose |
|------------|---------|
| File reading | Read target documents for validation |
| Content search | Search for FrontMatter fields, patterns |
| File search | Find files matching criteria |
| Shell execution | Run `blueprint` CLI commands |

## Special Requirements

- Validates ONLY assigned Aspects (no extras)
- Response compressed based on status: pass=summary only, warning=warning items, fail=full detail
- Violation format: location + expected + actual + suggestion
