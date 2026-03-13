---
type: gate
status: active
version: 1.0.0
created: 2026-03-13
updated: 2026-03-13
tags: [gate, verification, implementation, intent]
dependencies: []

name: verification
validates: implementation
description: "Validates implementation against Plan intent and documented decisions"
---

# Gate: Verification

## Description

Validates that a completed implementation faithfully reflects the BRIEF decisions, PLAN constraints, success criteria, and declared scope. Used by `/verify` command Phase 1 to ensure intent alignment before production readiness review.

## Purpose

- Ensure implementation matches documented decisions and constraints
- Detect scope creep or missing deliverables before code review
- Preserve main context by delegating verification to Reviewer Agent

## Aspects

| Aspect | Description | Consumer |
|--------|-------------|----------|
| decisions | Validates each Decision (D-xxx) from BRIEF.md is reflected in code diff | `/verify` Phase 1 |
| constraints | Validates each Constraint (C-xxx) from PLAN.md is not violated | `/verify` Phase 1 |
| success-criteria | Validates each Success Criterion from PLAN.md is satisfied | `/verify` Phase 1 |
| scope | Validates changed files are within declared scope; no out-of-scope work | `/verify` Phase 1 |
| deviations | Advisory: checks deviation completeness in implementation-notes.md | `/verify` Phase 1 |
| linear-alignment | Optional: validates Linear issue alignment with Plan scope | `/verify` Phase 1 |

## Usage

### In `/verify` Command

```
Phase 1: Intent Verification
    └── [Delegated] Spawn Reviewer Agent (synchronous)
        └── aegis verification --aspects decisions,constraints,success-criteria,scope,deviations,linear-alignment
```

## Reviewer Agent Integration

When delegating to Reviewer:

1. Spawn Reviewer Agent with verification Gate (synchronous — not background)
2. Reviewer validates all 6 Aspects against code diff + plan documents
3. Reviewer returns Handoff with per-aspect results
4. On FAIL: stop before Phase 2. On WARNING: ask user. On PASS: proceed.

**Handoff Format:**
```yaml
status: completed | blocked | failed
summary: Verification results summary
aspects:
  decisions: pass | fail | warning
  constraints: pass | fail | warning
  success-criteria: pass | fail | warning
  scope: pass | fail | warning
  deviations: pass | warning
  linear-alignment: pass | fail | warning | skip
issues:
  - aspect: decisions
    severity: error | warning
    message: Description
    suggestion: How to resolve
```
