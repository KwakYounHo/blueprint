---
type: aspect
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [aspect, session, plan, progress, validation]
dependencies: [../gate.md]

name: plan-progress
gate: session
description: "Validates Phase progress consistency across session documents"
---

# Aspect: Plan Progress

## Description

Validates that Master Plan phase progress is consistent across ROADMAP.md, CURRENT.md, and TODO.md.
Ensures all documents agree on current phase and completion status.

## Criteria

### Required (Must Pass)

#### Phase Consistency
- [ ] Current phase in CURRENT.md matches ROADMAP.md's current marker
- [ ] Phase number in TODO.md header matches CURRENT.md
- [ ] No conflicting phase claims across documents

#### ROADMAP Integrity
- [ ] ROADMAP.md has valid checkbox structure
- [ ] "Current" marker exists and points to uncompleted phase
- [ ] Completed phases are properly marked with [x]

#### TODO Alignment
- [ ] "In Progress" section tasks relate to current phase
- [ ] No tasks from future phases in "In Progress"

### Recommended (Should Pass)

#### Progress Plausibility
- [ ] TODO.md progress roughly matches session count
- [ ] No phase marked complete without corresponding TODO completion

#### Master Plan Reference
- [ ] Current phase exists in master-plan.md
- [ ] Phase objectives match between CURRENT.md and master-plan.md

## Validation Method

1. **Read ROADMAP.md**
   ```markdown
   - [x] Phase 1: Foundation
   - [ ] Phase 2: Core Implementation <- Current
   - [ ] Phase 3: Integration
   ```

2. **Read CURRENT.md**
   ```markdown
   **Current Phase:** Phase 2 - Core Implementation
   **Phase Objective:** Implement core authentication module
   ```

3. **Read TODO.md**
   ```markdown
   **Current Phase:** 2

   ## In Progress (Current Session)
   - [ ] Implement JWT validation
   ```

4. **Cross-validate**
   - Extract current phase from each document
   - Compare for consistency
   - Report discrepancies

## Error Scenarios

### Phase Mismatch

```
Issue: Phase mismatch across documents
  - ROADMAP.md: Phase 2 (current)
  - CURRENT.md: Phase 3
  - TODO.md: Phase 2

Severity: error

Suggestion:
  1. Determine actual current phase
  2. Update inconsistent documents
  3. Run /save to synchronize
```

### Stale ROADMAP

```
Issue: ROADMAP.md appears stale
  - ROADMAP shows: Phase 1 current
  - CURRENT.md shows: Phase 2 completed work
  - TODO.md shows: Phase 2 tasks

Severity: warning

Suggestion:
  1. Update ROADMAP.md to mark Phase 1 complete
  2. Move current marker to Phase 2
```

### Premature Phase Claim

```
Issue: Phase marked current but prerequisites incomplete
  - ROADMAP: Phase 3 (current)
  - TODO Phase 2: 3 tasks still pending

Severity: warning

Suggestion:
  1. Complete Phase 2 tasks first
  2. Or move remaining tasks to Phase 3
  3. Run /checkpoint to properly transition
```

### Missing Current Marker

```
Issue: ROADMAP.md has no current phase marker
  - All phases either [x] complete or [ ] pending
  - No "<- Current" or similar indicator

Severity: warning

Suggestion:
  1. Add current marker to appropriate phase
  2. Format: "- [ ] Phase N: Name <- Current"
```

## Output Format

```yaml
aspect: plan-progress
status: pass | fail | warning
documents_checked:
  roadmap: found | missing
  current: found | missing
  todo: found | missing
current_phase:
  roadmap: 2
  current_md: 2
  todo: 2
  consistent: true | false
issues:
  - type: phase_mismatch | stale_roadmap | premature_claim | missing_marker
    message: Description
    documents: [list of affected documents]
    suggestion: How to resolve
```

## Usage Context

### In `/load`

Validates before resuming work:
- Ensures handoff documents are synchronized
- Detects if previous session didn't complete properly

### In `/checkpoint`

Validates before archiving:
- Confirms phase is actually complete
- Ensures TODO.md shows phase tasks done
- Verifies ROADMAP.md ready for phase transition
