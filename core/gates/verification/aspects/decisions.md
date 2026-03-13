---
type: aspect
status: active
version: 1.0.0
created: 2026-03-13
updated: 2026-03-13
tags: [aspect, verification, decisions, brief]
dependencies: [../gate.md]

name: decisions
gate: verification
description: "Validates each Decision (D-xxx) from BRIEF.md is reflected in code diff"
---

# Aspect: Decisions

## Description

Validates that every Decision recorded in BRIEF.md's `Decisions Made` table is faithfully reflected in the implementation. Each D-xxx entry represents a deliberate design choice that must be visible in the code diff.

## Criteria

### Required (Must Pass)

#### Decision Coverage
- [ ] Every D-xxx from BRIEF.md `Decisions Made` table is checked
- [ ] Each Decision's `Rationale` aligns with how it was implemented
- [ ] No Decision is contradicted by the implementation

#### Decision Traceability
- [ ] For each D-xxx, at least one code change or file structure demonstrates compliance
- [ ] If a Decision was overridden, a corresponding entry exists in `implementation-notes.md` Deviations table

### Recommended

_(none)_

## Validation Method

1. **Read BRIEF.md** — Extract `Decisions Made` table (ID, Decision, Rationale)
2. **Read code diff** — `git diff <base>...HEAD` or provided diff
3. **Cross-reference** — For each D-xxx, locate evidence in the diff
4. **Report** — List each Decision with pass/fail and evidence summary

## Error Scenarios

### Decision Not Reflected

```
Issue: Decision D-003 not reflected in implementation
  - Decision: "Linear integration stays as-is"
  - Expected: No changes to Linear integration code
  - Actual: Linear integration modified in verify.md

Severity: error

Suggestion:
  1. Review if change was intentional
  2. If intentional, add Deviation entry in implementation-notes.md
  3. If unintentional, revert the change
```

### Decision Contradicted

```
Issue: Decision D-005 contradicted by implementation
  - Decision: "Phase 1 delegates to Reviewer synchronously"
  - Expected: Synchronous Task tool call (not background)
  - Actual: run_in_background: true found in verify.md

Severity: error

Suggestion:
  1. Change to synchronous delegation (remove run_in_background)
  2. Or add Deviation entry explaining why async was chosen
```

## Output Format

```yaml
aspect: decisions
status: pass | fail | warning
decisions_checked: 7
issues:
  - decision_id: "D-003"
    status: fail
    message: "Decision not reflected in implementation"
    evidence: "Description of what was expected vs found"
    suggestion: "How to resolve"
```
