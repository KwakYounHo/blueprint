---
type: master-plan
status: draft
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [master-plan]
dependencies: [memory.md]

plan-id: "PLAN-{NNN}"
name: "{Plan Name}"
source-memory: "memory.md"
phase-count: 0
---

# Master Plan: {Plan Name}

## Overview

### Goal

{Single sentence describing the end state}

### Success Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | {criterion} | {how to verify} |

---

## ID Formats

| Type | Format | Example |
|------|--------|---------|
| Phase | `Phase {N}` | Phase 1, Phase 2 |
| Task | `T-{phase}.{task}` | T-1.1, T-2.3 |

---

## Phases

### Phase 1: {Phase Name}

**Objective**: {What this phase achieves}

#### T-1.1: {Task Name}
**Deliverable**: {Specific deliverable for this task}

#### T-1.2: {Task Name}
**Deliverable**: {Specific deliverable for this task}

**Dependencies**: None

---

### Phase 2: {Phase Name}

**Objective**: {What this phase achieves}

#### T-2.1: {Task Name}
**Deliverable**: {Specific deliverable for this task}

**Dependencies**: Phase 1

---

## [FIXED] Constraints

> These constraints are confirmed and MUST NOT be changed without user approval.

| ID | Constraint | Rationale |
|----|------------|-----------|
| C-001 | {constraint} | {why this is fixed} |

---

## Plan Mode Strategy

> **When to use this section**: Before starting each Phase implementation (after `/master` or `/load`).

### How to Determine Plan Mode Entry Level

**Step 1**: Analyze Phase scope (number of Tasks, complexity, dependencies)

**Step 2**: Use `AskUserQuestion` to ask user with analysis summary:

```
"Phase {N} has {X} Tasks (T-N.1 ~ T-N.X).

Analysis:
- T-N.1: {Simple/Moderate/Complex} ({reason})
- T-N.2: {Simple/Moderate/Complex} ({reason})

How should we approach Plan Mode?"

Options:
A: Phase level - One Plan Mode for entire Phase
B: Task level - Plan Mode per Task
C: No Plan Mode - Direct implementation
```

**Step 3**: Execute based on user choice

| Choice | Workflow |
|--------|----------|
| Phase level | Plan Mode once → Plan all Tasks → Execute all → `/save` |
| Task level | Per Task: Plan Mode → Execute → Mark complete |
| No Plan Mode | Execute directly → Mark complete → `/save` |

### Task Execution Flow

For each Task (regardless of Plan Mode choice):

1. Review Task deliverables in this document
2. Execute the Task
3. Mark Task complete in TODO.md
4. Continue to next Task or `/save`

---

## References

| Type | Path | Description |
|------|------|-------------|
| Memory | `memory.md` | Decisions Made (D-NNN), Background, Discussion |
