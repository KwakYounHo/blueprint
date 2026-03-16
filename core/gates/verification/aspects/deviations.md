---
type: aspect
status: active
version: 1.0.0
created: 2026-03-13
updated: 2026-03-13
tags: [aspect, verification, deviations, implementation-notes]
dependencies: [../gate.md]

name: deviations
gate: verification
description: "Advisory: checks that implementation deviations are documented in implementation-notes.md"
---

# Aspect: Deviations

## Description

Advisory aspect that checks whether implementation differences from PLAN.md deliverables are properly documented in `implementation-notes.md` Deviations table. This aspect only produces `pass` or `warning` — never `fail`.

## Criteria

### Required

_(none — this aspect is advisory only)_

### Recommended (Should Pass)

#### Deviation Documentation
- [ ] Every implementation difference from PLAN.md Task deliverables has a corresponding entry in `implementation-notes.md` Deviations table
- [ ] Each Deviation entry includes: Date, Phase/Task, Original Plan, Actual Implementation, Reason
- [ ] No undocumented deviations exist

#### Deviation Completeness
- [ ] Deviations table is not placeholder-only (no `- | - | - | - | -` if deviations exist)
- [ ] Reasons are meaningful (not generic "changed during implementation")

## Validation Method

1. **Read PLAN.md** — Extract Task deliverables per Phase
2. **Read implementation-notes.md** — Extract Deviations table entries
3. **Read code diff** — Compare actual implementation against Plan deliverables
4. **Cross-reference**
   - Identify differences between Plan deliverables and actual code
   - For each difference, check if a Deviation entry exists
5. **Report** — List undocumented deviations as warnings

## Error Scenarios

### Undocumented Deviation

```
Issue: Implementation differs from Plan but no Deviation recorded
  - Task: T-2.4
  - Plan: "5 new OBJECTIVE blocks"
  - Actual: 4 OBJECTIVE blocks (after-verify split into two forms)
  - Deviation table: No entry for this change

Severity: warning

Suggestion:
  1. Add entry to implementation-notes.md Deviations table
  2. Include: Date, T-2.4, "5 OBJECTIVE blocks", "4 blocks (after-verify split)", reason
```

### Placeholder Deviations Table

```
Issue: Deviations table has placeholder rows despite actual deviations existing
  - Table: "- | - | - | - | -"
  - Actual deviations detected: 2

Severity: warning

Suggestion:
  1. Replace placeholder rows with actual deviation entries
  2. Document each detected deviation
```

## Output Format

Follow `hermes response:review:verification` form — `checks.deviations` block.
