# Workflows

> Phase and Stage definitions. The temporal structure of work.

---

## Purpose

Workflows define **when things happen** in the development process:

1. **Phases**: Major stages in the workflow lifecycle
2. **Stages**: Logical groupings within a Phase
3. **Transitions**: How to move between Phases (via Gates)

---

## Background

### Hierarchy: Phase → Stage → Task

From project management best practices (WBS):

| Level | Name | Description |
|-------|------|-------------|
| 1 | **Phase** | Major lifecycle stage (Specification, Implementation) |
| 2 | **Stage** | Logical grouping within Phase (Package Init, Configuration) |
| 3 | **Task** | Concrete work unit (dynamically created) |

### Why This Structure?

- **Phase**: Defines "what kind of work"
- **Stage**: Organizes "related work"
- **Task**: Specifies "actual work to do"

Phases are **static** (predefined).
Stages are **semi-static** (predefined but extensible).
Tasks are **dynamic** (created during Specification).

---

## Directory Structure

```
workflows/
├── README.md                # This file
├── phases.md                # Phase definitions and order
└── stages/                  # Stage definitions per Phase
    ├── specification.md     # Stages in Specification Phase
    └── implementation.md    # Stages in Implementation Phase
```

---

## Phase Definition (`phases.md`)

### Front Matter

```yaml
---
type: phase
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [workflow, phases]
related: []
---
```

### Content Structure

```markdown
# Workflow Phases

## Phase Order
1. Specification Phase
2. Implementation Phase

## Phase Definitions

### Specification Phase
- **Purpose**: Analyze requirements, create specifications
- **Entry**: User request received
- **Exit**: Specification Gate passed
- **Artifacts**: spec.md, plan.md

### Implementation Phase
- **Purpose**: Implement code based on plan
- **Entry**: Specification Gate passed
- **Exit**: Implementation Gate passed
- **Artifacts**: code files, task completions

## Phase Transitions

| From | To | Condition |
|------|-----|-----------|
| (start) | Specification | User request |
| Specification | Implementation | Specification Gate Pass |
| Implementation | (complete) | Implementation Gate Pass + User Confirm |
```

---

## Stage Definition (`stages/*.md`)

### Front Matter

```yaml
---
type: stage
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [workflow, stage, {phase-name}]
related: [../phases.md]

# Stage-specific
phase: specification | implementation
order: sequential | parallel
---
```

### Content Structure

```markdown
# Stages: {Phase} Phase

## Stage List

### Stage: {Name}
- **Description**: [What this stage covers]
- **Typical Tasks**: [Examples of tasks in this stage]
- **Dependencies**: [What must be done before]

## Stage Order

| Order | Stage | Parallel? |
|-------|-------|-----------|
| 1 | Stage A | No |
| 2 | Stage B, Stage C | Yes (parallel) |
| 3 | Stage D | No |
```

---

## Planned Phases

### Specification Phase

| Aspect | Description |
|--------|-------------|
| **Purpose** | Analyze requirements, plan implementation |
| **Worker** | Specifier |
| **Gate** | Specification Gate |
| **Artifacts** | spec.md, plan.md |

**Stages**:
- Requirement Analysis
- Feasibility Check
- Stage/Task Breakdown

### Implementation Phase

| Aspect | Description |
|--------|-------------|
| **Purpose** | Implement code based on Tasks |
| **Worker** | Implementer (per Task) |
| **Gate** | Implementation Gate |
| **Artifacts** | Code files |

**Stages** (example for MCP project):
- Package Initialize
- Configuration
- Core Implementation
- Integration

---

## Phase-Gate Relationship

```
┌─────────────────────┐
│ Specification Phase │
│                     │
│ Specifier Worker    │
│ → spec.md           │
│ → plan.md           │
└─────────────────────┘
          │
          ▼
┌─────────────────────┐
│ Specification Gate  │
│ • Completeness      │
│ • Feasibility       │
└─────────────────────┘
          │
          ▼ (Pass)
┌─────────────────────┐
│ Implementation Phase│
│                     │
│ Implementer Workers │
│ (per Task)          │
│ → code files        │
└─────────────────────┘
          │
          ▼
┌─────────────────────┐
│ Implementation Gate │
│ • Code-Style        │
│ • Architecture      │
│ • Component         │
└─────────────────────┘
          │
          ▼ (Pass)
    User Confirmation
```

---

## Task Creation

Tasks are **not predefined** in workflows. They are:

1. **Created by Specifier** during Specification Phase
2. **Stored in** `features/{feature-id}/tasks/`
3. **Executed by Implementer** during Implementation Phase

```
Specifier creates plan.md
    │
    └── Defines Tasks:
        ├── task-001: Define interfaces
        ├── task-002: Implement core logic
        └── task-003: Add tests
    │
    └── Creates task files in features/{id}/tasks/
```

---

## Status Values

| Status | Meaning |
|--------|---------|
| `draft` | Phase/Stage being defined |
| `active` | Currently in effect |
| `deprecated` | Being phased out |
| `archived` | Historical reference |

---

## Best Practices

### Keep Phases Minimal

- 2-3 Phases is usually enough
- More Phases = More Gates = More overhead

### Stages Are Flexible

- Stages can vary by project/feature
- Don't over-specify Stages in the framework
- Let Specifier define appropriate Stages per Feature

### Tasks Are Dynamic

- Never predefine Task lists
- Tasks emerge from Specification
- Task granularity depends on feature complexity

---

## Related

- `../gates/` for Gate definitions
- `../features/` for where Tasks are stored
- `../../claude-agents/` for Worker behavior definitions
