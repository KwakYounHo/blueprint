# Specification: verify

## Description

Verify implementation against Plan intent and production readiness

## Platform Topics

| Topic | Usage |
|-------|-------|
| `agent-delegation` | Step 3: Reviewer agent (intent verification, synchronous), Step 5: Three review agents (production readiness, parallel synchronous) |
| `external-service` | Step 2c: Linear issue fetch for source-discussion verification |

## Delegated Agents

| Agent | Count | Mode | Purpose |
|-------|:-----:|------|---------|
| reviewer | 1 | Synchronous | Phase 1: Intent verification against Gate Aspects |
| code-reuse-reviewer | 1 | Parallel, synchronous | Phase 2: Duplicated logic, underutilized utilities |
| code-quality-reviewer | 1 | Parallel, synchronous | Phase 2: Redundant state, parameter sprawl, standards |
| code-efficiency-reviewer | 1 | Parallel, synchronous | Phase 2: Unnecessary work, hot-path bloat, memory |

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `plan` | `resolve <id>`, `list` |
| `frontis` | `show` |
| `aegis` | `verification`, `verification <aspect>` |
| `hermes` | `request:review:verification`, `response:review:verification`, `request:verify:production`, `response:verify:production`, `after-verify` |

## Agent Requirements

**reviewer**: File reading, content search, shell execution (blueprint CLI)
**code-*-reviewer**: File reading, content search, code analysis

## Special Requirements

- Phase 1 MUST pass before Phase 2 begins
- Phase 1 Reviewer is synchronous (NOT background)
- Phase 2 three agents launched in parallel but all synchronous (wait for all)
- `--no-linear` flag skips Linear verification
- Linear integration is optional (skipped if `source-discussion` is null)
