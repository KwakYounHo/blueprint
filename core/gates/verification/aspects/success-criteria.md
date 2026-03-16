---
type: aspect
status: active
version: 1.0.0
created: 2026-03-13
updated: 2026-03-13
tags: [aspect, verification, success-criteria, plan]
dependencies: [../gate.md]

name: success-criteria
gate: verification
description: "Validates each Success Criterion from PLAN.md is satisfied per its Verification method"
---

# Aspect: Success Criteria

## Description

Validates that every Success Criterion in PLAN.md's `Success Criteria` table is satisfied. Each criterion has an explicit Verification method that defines how to check it.

## Criteria

### Required (Must Pass)

#### Criterion Satisfaction
- [ ] Every numbered Success Criterion from PLAN.md is checked
- [ ] Each Criterion's `Verification` method is applied and passes
- [ ] No Criterion is left unverified

#### Verification Evidence
- [ ] For each Criterion, concrete evidence exists (file exists, command output, structure match)
- [ ] Partial satisfaction is reported as warning, not pass

### Recommended

#### Verification Tests
- [ ] Where applicable, a test or script can reproduce the verification

## Validation Method

1. **Read PLAN.md** — Extract `Success Criteria` table (#, Criterion, Verification)
2. **Apply each Verification method**
   - "File exists" → Check file at specified path
   - "Command returns X" → Run command and verify output
   - "Contains Y" → Search file content for expected patterns
3. **Report** — List each Criterion with pass/fail and evidence

## Error Scenarios

### Criterion Not Met

```
Issue: Success Criterion #2 not satisfied
  - Criterion: "core/gates/verification/ gate with 6 aspects defined"
  - Verification: "blueprint aegis verification --aspects returns 6 aspects"
  - Actual: Only 4 aspect files found

Severity: error

Suggestion:
  1. Create missing aspect files
  2. Verify all 6 aspects listed in gate.md exist as files
```

### Partial Satisfaction

```
Issue: Success Criterion #7 partially met
  - Criterion: "Original /verify functionality preserved"
  - Verification: "All 7 steps present in promoted command"
  - Actual: 6 of 7 steps present; Step 2c (Linear detection) missing

Severity: warning

Suggestion:
  1. Add missing Step 2c to promoted command
  2. Or document intentional omission in implementation-notes.md
```

## Output Format

Follow `hermes response:review:verification` form — `checks.success-criteria` block.
