# Workflows

> The organizational unit for all work. One Workflow = One Branch = One Directory.

---

## Purpose

A **Workflow** is the container for a complete unit of work, answering four key questions:

| Concept | Question | File | Count |
|---------|----------|------|-------|
| **Phase** | "Why" - Background and purpose | `spec.md` | 1 |
| **Stage** | "What" - Requirements to fulfill | `stage-*.md` | N |
| **Task** | "How" - Methods to achieve | `task-*.md` | N per Stage |
| **Progress** | "How much" - Tracking completion | `progress.md` | 1 |

---

## Background

### Why This Structure?

From Work Breakdown Structure (WBS) best practices:

| Level | Concept | Role | Type |
|-------|---------|------|------|
| 1 | **Phase** | Defines purpose and scope | Definition |
| 2 | **Stage** | Organizes requirements | Definition |
| 3 | **Task** | Specifies concrete actions | Definition |
| 4 | **Progress** | Tracks completion status | Task |

### The 100% Rule

From WBS methodology:
> "The sum of the work at the child level must equal 100% of the work represented by the parent"

- All Stages must cover 100% of Phase requirements
- All Tasks must cover 100% of their Stage requirements
- Progress tracks completion against this total

---

## Directory Structure

```
workflows/
├── README.md                              # This file (not copied to projects)
└── {workflow-id}/                         # e.g., 001-initialize-documents
    ├── spec.md                            # Phase: Background and purpose
    ├── stage-01-requirement-analysis.md   # Stage 1
    ├── stage-02-core-implementation.md    # Stage 2
    ├── task-01-01-gather-requirements.md  # Stage 1, Task 1
    ├── task-01-02-validate-scope.md       # Stage 1, Task 2
    ├── task-02-01-define-interfaces.md    # Stage 2, Task 1
    ├── task-02-02-implement-logic.md      # Stage 2, Task 2
    └── progress.md                        # Progress tracking
```

---

## Naming Conventions

### Workflow ID

```
{number}-{short-description}
```

| Component | Format | Example |
|-----------|--------|---------|
| `number` | 3-digit, zero-padded | `001`, `042`, `123` |
| `short-description` | lowercase, hyphen-separated | `initialize-documents` |

**Examples**: `001-initialize-documents`, `002-user-authentication`, `003-api-rate-limiting`

### File Naming (WBS Style)

| Type | Pattern | Example |
|------|---------|---------|
| Phase | `spec.md` | `spec.md` |
| Stage | `stage-{SS}-{name}.md` | `stage-01-requirement-analysis.md` |
| Task | `task-{SS}-{TT}-{name}.md` | `task-01-02-validate-scope.md` |
| Progress | `progress.md` | `progress.md` |

- `SS`: Stage number (01-99)
- `TT`: Task number within Stage (01-99)

### Branch Naming

Workflow directory name equals Git branch name:

| Workflow Directory | Git Branch |
|--------------------|------------|
| `workflow/001-user-auth/` | `001-user-auth` |
| `workflow/002-payment/` | `002-payment` |

---

## Dependency Flow

```
Phase (spec.md)
  dependencies: []
       │
       ▼
Stage (stage-*.md)
  dependencies: [spec.md]
       │
       ▼
Task (task-*.md)
  dependencies: [stage-XX-*.md]
       │
       ▼
Progress (progress.md)
  dependencies: [task-*.md, ...]
```

Each level depends on its immediate parent, creating a clear chain of accountability.

---

## Document Definitions

### Phase (`spec.md`)

The **single source of truth** for why this workflow exists.

#### Front Matter

```yaml
---
type: phase
status: active
version: 1.0.0
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [workflow-tag-1, workflow-tag-2]
dependencies: []

workflow-id: "{workflow-id}"
---
```

#### Content Structure

```markdown
# Phase: {Workflow Name}

## Background
[Why this workflow is needed - problem statement]

## Purpose
[What this workflow aims to achieve - goals]

## Scope
### In Scope
- [What is included]

### Out of Scope
- [What is explicitly excluded]

## Success Criteria
- [Measurable outcomes that define completion]
```

---

### Stage (`stage-{SS}-{name}.md`)

Defines **requirements to fulfill** within the Phase.

#### Front Matter

```yaml
---
type: stage
status: active
version: 1.0.0
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [stage, {stage-name}]
dependencies: [spec.md]

name: "{stage-identifier}"
order: 1
---
```

#### Content Structure

```markdown
# Stage: {Stage Name}

## Description
[What this stage covers]

## Requirements
- [Requirement 1]
- [Requirement 2]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Dependencies
[What must be completed before this stage]
```

---

### Task (`task-{SS}-{TT}-{name}.md`)

Defines **how to achieve** Stage requirements.

#### Front Matter

```yaml
---
type: task
status: active
version: 1.0.0
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [task, {stage-name}]
dependencies: [stage-{SS}-{stage-name}.md]

name: "{task-identifier}"
stage: "{stage-name}"
order: 1
parallel-group: null  # or "group-name" for parallel execution
---
```

#### Content Structure

```markdown
# Task: {Task Name}

## Objective
[What this task accomplishes]

## Approach
[How to complete this task]

## Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Deliverables
- [Expected outputs]
```

---

### Progress (`progress.md`)

Tracks **completion status** across all Tasks.

#### Front Matter

```yaml
---
type: progress
status: in-progress
version: 1.0.0
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [progress, tracking]
dependencies: [task-01-01-*.md, task-01-02-*.md, ...]
---
```

#### Content Structure

```markdown
# Progress: {Workflow Name}

## Overview
| Stage | Tasks | Completed | Status |
|-------|-------|-----------|--------|
| Stage 1 | 3 | 2 | 67% |
| Stage 2 | 2 | 0 | 0% |
| **Total** | **5** | **2** | **40%** |

## Stage 1: {Stage Name}
- [x] task-01-01: {Task Name} - Completed YYYY-MM-DD
- [x] task-01-02: {Task Name} - Completed YYYY-MM-DD
- [ ] task-01-03: {Task Name} - In Progress

## Stage 2: {Stage Name}
- [ ] task-02-01: {Task Name} - Pending
- [ ] task-02-02: {Task Name} - Pending

## Notes
[Any blockers, decisions, or observations]
```

---

## Status Values

### Definition Documents (Phase, Stage, Task)

| Status | Meaning |
|--------|---------|
| `draft` | Being defined, not ready for use |
| `active` | Current and in use |
| `deprecated` | Being phased out |
| `archived` | Historical reference |

### Task Documents (Progress)

| Status | Meaning |
|--------|---------|
| `pending` | Not yet started |
| `in-progress` | Currently being worked on |
| `completed` | Successfully finished |
| `failed` | Did not complete successfully |

---

## Workflow Lifecycle

```
1. Workflow Created
   └── spec.md created (Phase)
   └── Branch created: {workflow-id}

2. Planning
   └── Stages defined (stage-*.md)
   └── Tasks created (task-*.md)
   └── progress.md initialized

3. Execution
   └── Tasks executed in order
   └── progress.md updated continuously

4. Gate Validation
   └── Specification Gate (after planning)
   └── Implementation Gate (after execution)

5. Completion
   └── progress.md status: completed
   └── Branch merged to main
```

---

## Stage-Task Relationship

Each Stage can have multiple Tasks (1:N relationship):

```
stage-01-requirement-analysis.md
├── task-01-01-gather-requirements.md
├── task-01-02-validate-scope.md
└── task-01-03-document-constraints.md

stage-02-core-implementation.md
├── task-02-01-define-interfaces.md
└── task-02-02-implement-logic.md
```

Tasks reference their parent Stage via the `stage` field:

```yaml
# In task-01-02-validate-scope.md
stage: "requirement-analysis"
```

---

## Best Practices

### Keep Phase Focused

- One clear purpose per Workflow
- Defined scope boundaries
- Measurable success criteria

### Stages Should Be Independent

- Each Stage represents a logical grouping
- Minimize cross-Stage dependencies
- Clear acceptance criteria per Stage

### Tasks Should Be Atomic

- Single responsibility per Task
- Estimable effort
- Clear deliverables

### Update Progress Continuously

- Mark Tasks complete as you go
- Note blockers immediately
- Keep percentage tracking current

---

## Related

- `../front-matters/` for Schema definitions (phase, stage, task, progress)
- `../gates/` for Gate validation criteria
- `../constitutions/` for Worker principles
- `../../claude-agents/` for Worker behavior definitions
