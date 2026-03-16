---
type: aspect
status: active
version: 1.0.0
created: 2026-03-13
updated: 2026-03-13
tags: [aspect, verification, constraints, plan]
dependencies: [../gate.md]

name: constraints
gate: verification
description: "Validates each Constraint (C-xxx) from PLAN.md is not violated by implementation"
---

# Aspect: Constraints

## Description

Validates that every Constraint in PLAN.md's `[FIXED] Constraints` table is respected by the implementation. Constraints are immutable rules that must not be violated without explicit user approval.

## Criteria

### Required (Must Pass)

#### Constraint Compliance
- [ ] Every C-xxx from PLAN.md `[FIXED] Constraints` table is checked
- [ ] No Constraint is violated by any code change in the diff
- [ ] If a Constraint was relaxed, explicit user approval is documented in `implementation-notes.md`

#### Constraint Completeness
- [ ] All changed files are checked against relevant Constraints
- [ ] Append-only constraints (e.g., C-006) verified via diff direction (additions only, no deletions in protected sections)

### Recommended

_(none)_

## Validation Method

1. **Read PLAN.md** — Extract `[FIXED] Constraints` table (ID, Constraint, Rationale)
2. **Read code diff** — `git diff <base>...HEAD` or provided diff
3. **Cross-reference** — For each C-xxx, verify the diff does not violate it
4. **Report** — List each Constraint with pass/fail and evidence

## Error Scenarios

### Constraint Violated

```
Issue: Constraint C-006 violated
  - Constraint: "Existing hermes forms must not be modified"
  - Rationale: "Append-only; other commands depend on existing forms"
  - Actual: Existing OBJECTIVE[after-save] block modified in handoff.schema.md

Severity: error

Suggestion:
  1. Revert changes to existing forms
  2. Only append new OBJECTIVE blocks
  3. Verify diff shows additions only in handoff.schema.md
```

### Constraint Relaxed Without Approval

```
Issue: Constraint C-001 appears relaxed
  - Constraint: "Original /verify functionality must be fully preserved"
  - Evidence: Step 4 from original workflow missing in promoted command

Severity: error

Suggestion:
  1. Add missing workflow step
  2. Or document user-approved relaxation in implementation-notes.md
```

## Output Format

Follow `hermes response:review:verification` form — `checks.constraints` block.
