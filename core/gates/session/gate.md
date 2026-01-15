---
type: gate
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [gate, session, continuity]
dependencies: []

name: session
validates: session-context
description: "Validates session continuity and state consistency"
---

# Gate: Session Continuity

## Description

Validates that session context documents are consistent with the actual system state.
Used primarily by `/load` command to verify handoff integrity before resuming work.

## Purpose

- Ensure seamless session handoffs between context windows
- Detect discrepancies between documented state and actual state
- Preserve your context by delegating verification to Reviewer Agent

## Aspects

| Aspect | Description | Consumer |
|--------|-------------|----------|
| git-state | Validates Git status matches CURRENT.md documentation | `/load` |
| file-integrity | Validates Key Files exist and match descriptions | `/load` |
| plan-progress | Validates Phase and Task progress consistency across documents | `/load`, `/checkpoint` |
| phase-completion | Validates all Tasks in Phase are complete before checkpoint | `/checkpoint` |

## Usage

### In `/load` Command

```
Phase 3: State Verification
    ├── [Direct] Main Session performs verification
    └── [Delegated] Spawn Reviewer Agent
        └── aegis session --aspects git-state,file-integrity,plan-progress
```

### In `/checkpoint` Command

```
Step 1: Verify Phase Completion
    └── aegis session --aspects plan-progress
```

## Reviewer Agent Integration

When delegating to Reviewer:

1. Spawn Reviewer Agent with session Gate
2. Reviewer validates specified Aspects
3. Reviewer returns Handoff with validation results
4. You process results and present to user

**Handoff Format:**
```yaml
status: completed | blocked | failed
summary: Validation results summary
aspects:
  git-state: pass | fail | warning
  file-integrity: pass | fail | warning
  plan-progress: pass | fail | warning
issues:
  - aspect: git-state
    severity: error | warning
    message: Description of issue
    suggestion: How to resolve
```
