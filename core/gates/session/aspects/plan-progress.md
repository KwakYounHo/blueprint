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

Validates that Plan phase progress is consistent across ROADMAP.md, CURRENT.md, and TODO.md.
Ensures all documents agree on current phase and completion status.

## Criteria

### Required (Must Pass)

#### Phase Consistency
- [ ] Current phase in CURRENT.md matches ROADMAP.md's current marker
- [ ] Phase number in TODO.md header matches CURRENT.md
- [ ] No conflicting phase claims across documents

#### Task Consistency
- [ ] `current-task` in CURRENT.md matches TODO.md's current task
- [ ] `current-task` in TODO.md matches CURRENT.md
- [ ] Current Task belongs to current Phase (T-{N}.x where N = current phase)
- [ ] No future Phase Tasks in progress

#### ROADMAP Integrity
- [ ] ROADMAP.md has valid checkbox structure
- [ ] "Current" marker exists and points to uncompleted phase
- [ ] Completed phases are properly marked with [x]
- [ ] Task checkboxes exist under each Phase

#### TODO Alignment
- [ ] "In Progress" section tasks relate to current phase
- [ ] No tasks from future phases in "In Progress"
- [ ] Current Task (T-N.M) is in "In Progress" or next pending

### Recommended (Should Pass)

#### Progress Plausibility
- [ ] TODO.md progress roughly matches session count
- [ ] No phase marked complete without corresponding TODO completion

#### Plan Reference
- [ ] Current phase exists in PLAN.md
- [ ] Phase objectives match between CURRENT.md and PLAN.md

## Validation Method

1. **Read ROADMAP.md**
   ```markdown
   - [x] Phase 1: Foundation
     - [x] T-1.1: Setup
     - [x] T-1.2: Config
   - [ ] Phase 2: Core Implementation <- Current
     - [x] T-2.1: Auth module
     - [ ] T-2.2: Validation <- Current Task
     - [ ] T-2.3: Tests
   ```

2. **Read CURRENT.md Frontmatter**
   ```yaml
   current-phase: 2
   current-task: "T-2.2"
   ```

3. **Read TODO.md Frontmatter**
   ```yaml
   current-phase: 2
   current-task: "T-2.2"
   ```

4. **Cross-validate Phase and Task**
   - Extract current phase from each document
   - Extract current task from CURRENT.md and TODO.md
   - Verify Task ID matches current Phase (T-2.x for Phase 2)
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

### Task Mismatch

```
Issue: current-task mismatch across documents
  - CURRENT.md: T-2.3
  - TODO.md: T-2.1

Severity: error

Suggestion:
  1. Determine actual current task
  2. Update inconsistent documents
  3. Run /save to synchronize
```

### Task Phase Mismatch

```
Issue: Current task does not belong to current phase
  - Current Phase: 2
  - Current Task: T-3.1 (belongs to Phase 3)

Severity: error

Suggestion:
  1. Complete Phase 2 tasks before starting Phase 3
  2. Or update current phase to 3
  3. Run /checkpoint if Phase 2 is complete
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
current_task:
  current_md: "T-2.2"
  todo: "T-2.2"
  consistent: true | false
  belongs_to_phase: true | false
issues:
  - type: phase_mismatch | stale_roadmap | premature_claim | missing_marker | task_mismatch | task_phase_mismatch
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
