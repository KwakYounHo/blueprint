---
type: aspect
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [aspect, session, phase, completion, checkpoint, validation]
dependencies: [../gate.md]

name: phase-completion
gate: session
description: "Validates Phase is ready for checkpoint"
---

# Aspect: Phase Completion

## Description

Validates that the current Phase is ready for checkpoint.
Ensures all deliverables are complete, tasks are done, and no uncommitted changes remain.

## Criteria

### Required (Must Pass)

#### ROADMAP Readiness
- [ ] Current phase tasks are substantially complete
- [ ] ROADMAP.md current marker points to phase being checkpointed
- [ ] No future phase work mixed into current phase

#### TODO Completion
- [ ] Current phase tasks in TODO.md are marked complete `[x]`
- [ ] No critical tasks left incomplete
- [ ] "In Progress" section is empty or contains only minor items

#### Git State
- [ ] No uncommitted changes (or explicitly acknowledged by user)
- [ ] Working tree is clean or changes are documented

### Recommended (Should Pass)

#### Blockers Resolved
- [ ] CURRENT.md "Blockers" section shows "none" or resolved items
- [ ] No critical issues preventing phase closure

#### Documentation Updated
- [ ] CURRENT.md reflects final state of phase
- [ ] Key decisions are documented

## Validation Method

1. **Check TODO.md Current Phase**
   ```markdown
   ## Phase {N} - {Name}

   - [x] Task 1 (completed)
   - [x] Task 2 (completed)
   - [ ] Task 3 (incomplete) <- FLAG THIS
   ```

2. **Check ROADMAP.md**
   ```markdown
   - [x] Phase 1: Foundation
   - [ ] Phase 2: Core Implementation <- Current (ready to complete)
   - [ ] Phase 3: Integration
   ```

3. **Check Git Status**
   ```bash
   git status --porcelain
   # Should be empty, or user acknowledges remaining changes
   ```

4. **Check CURRENT.md Blockers**
   ```markdown
   **Blockers:** None
   # or
   **Blockers:** [Resolved] {description}
   ```

## Error Scenarios

### Incomplete Tasks

```
Issue: Current phase has incomplete tasks
  - TODO.md Phase 2: 3 of 5 tasks incomplete
  - Incomplete: Task A, Task B, Task C

Severity: warning

Suggestion:
  1. Complete remaining tasks before checkpoint
  2. Or move incomplete tasks to next phase
  3. Or acknowledge and proceed (tasks will be noted in CHECKPOINT-SUMMARY.md)
```

### Uncommitted Changes

```
Issue: Uncommitted changes detected
  - Modified: src/auth/login.ts
  - Modified: src/api/routes.ts

Severity: warning

Suggestion:
  1. Commit changes: git add . && git commit -m "Phase N completion"
  2. Or stash changes: git stash
  3. Or acknowledge: "Intentional uncommitted changes for Phase N+1"
```

### Unresolved Blockers

```
Issue: Unresolved blockers in CURRENT.md
  - Blocker: "Authentication integration pending external API"

Severity: warning

Suggestion:
  1. Resolve blocker before checkpoint
  2. Or document as known issue in CHECKPOINT-SUMMARY.md
  3. Or move to next phase backlog
```

### Empty Phase

```
Issue: Phase appears to have no completed work
  - TODO.md: No completed tasks for Phase {N}
  - HISTORY.md: No session entries for Phase {N}

Severity: error

Suggestion:
  1. Verify correct phase is being checkpointed
  2. Complete at least one deliverable before checkpoint
```

## Output Format

```yaml
aspect: phase-completion
status: pass | fail | warning
phase_checked: 2
tasks:
  total: 5
  completed: 5
  incomplete: 0
git:
  clean: true | false
  uncommitted_files: []
  acknowledged: true | false
blockers:
  resolved: true | false
  items: []
issues:
  - type: incomplete_tasks | uncommitted_changes | unresolved_blockers | empty_phase
    message: Description
    severity: error | warning
    suggestion: How to resolve
```

## Usage Context

### In `/checkpoint`

Validates before archiving phase:
- Confirms phase work is complete
- Ensures clean state for archive
- Identifies items to document in CHECKPOINT-SUMMARY.md

### User Acknowledgement Flow

When warnings are present:
```
Phase {N} has warnings:
- 2 uncommitted files
- 1 incomplete task

Options:
1. Resolve issues first
2. Acknowledge and proceed (will be documented)
3. Cancel checkpoint

Which option? (1/2/3)
```
