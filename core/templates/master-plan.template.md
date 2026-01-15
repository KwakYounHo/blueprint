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

> **IMPORTANT**: This section MUST be followed before starting Phase implementation.
> Triggered by: `/master` completion OR `/load` with `yes` response.

### Step 1: Identify Next Work Unit

From ROADMAP.md and this document:
- Find first unchecked Phase/Task
- Get Phase objective and Task list

### Step 2: Codebase Exploration for Scope Analysis

> Purpose: Determine if Phase can be planned at once, or needs Task-level planning.

**Exploration Method** (choose based on complexity):
- **Simple Phase** (1-3 Tasks, known files): Direct exploration (Glob/Grep/Read)
- **Complex Phase** (4+ Tasks, unknown scope): Task tool with Explore subagent

| Analysis Target | Method |
|-----------------|--------|
| Files to modify | Glob/Grep for files mentioned in Phase deliverables |
| Change scope | Estimate lines/sections affected per Task |
| Complexity | Dependencies, cross-file changes, new patterns needed |
| Risk areas | External APIs, state management, breaking changes |

### Step 3: Synthesize Analysis

Based on exploration, determine:
- **Phase-level viable?**: Can all Tasks be planned coherently in one Plan Mode session?
- **Task-level needed?**: Are individual Tasks complex enough to warrant separate planning?
- **No Plan Mode?**: Are all Tasks straightforward edits?

Produce recommendation:
```
Phase {N}: {Phase Name}
Tasks: {X} (T-N.1 ~ T-N.X)

Scope Analysis:
- Files affected: {list or count}
- Estimated complexity: Simple / Moderate / Complex
- Key considerations: {brief notes}

Recommendation: {Phase level / Task level / No Plan Mode}
Reason: {why this recommendation}
```

### Step 4: Present to User

Use `AskUserQuestion`:

| Field | Content |
|-------|---------|
| Header | "Plan Mode" |
| Question | "{Analysis summary}\n\nHow should we approach Plan Mode?" |
| Option A | "{Recommended option} (Recommended)" |
| Option B | "{Alternative 1}" |
| Option C | "{Alternative 2}" |

### Step 5: Execute Based on Choice

| Choice | Workflow |
|--------|----------|
| Phase level | Plan Mode once → Plan all Tasks → Execute all → `/save` |
| Task level | Per Task: Plan Mode → Execute → Mark complete |
| No Plan Mode | Execute directly → Mark complete → `/save` |

### Task Execution Flow

For each Task (regardless of Plan Mode choice):

1. Review Task deliverables in this document
2. Execute the Task
3. Mark Task complete in TODO.md and ROADMAP.md
4. Continue to next Task or `/save`

---

## References

| Type | Path | Description |
|------|------|-------------|
| Memory | `memory.md` | Decisions Made (D-NNN), Background, Discussion |
