---
type: plan
status: draft
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [plan]
dependencies: [BRIEF.md]

plan-id: "PLAN-{NNN}"
name: "{Plan Name}"
source-brief: "BRIEF.md"
phase-count: 0
---

# Plan: {Plan Name}

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

## File Context

> Modifications must respect stated purpose and constraint.

| File | Purpose | Constraint |
|------|---------|------------|
| `{path}` | {why this file exists} | {what NOT to do} |

---

## Phases

### Phase 1: {Phase Name}

**Objective**: {What this phase achieves}

#### T-1.1: {Task Name}
**Deliverable**: {Specific deliverable for this task}
**Files**: `{file1}`, `{file2}` (or `None` if no file modifications)

#### T-1.2: {Task Name}
**Deliverable**: {Specific deliverable for this task}
**Files**: `{file1}`, `{file2}` (or `None` if no file modifications)

**Dependencies**: None

---

### Phase 2: {Phase Name}

**Objective**: {What this phase achieves}

#### T-2.1: {Task Name}
**Deliverable**: {Specific deliverable for this task}
**Files**: `{file1}`, `{file2}` (or `None` if no file modifications)

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
> Triggered by: `/bplan` completion OR `/load` with `yes` response.

### Invocation

At Phase start, invoke Phase Analyzer Agent:

```
Task tool:
  subagent_type: "phase-analyzer"
  prompt: |
    Analyze Phase {N} of Plan.

    Plan: {path to PLAN.md}
    Phase: {N}

    Perform 5-dimension evaluation for each Task.
    Return Plan Mode Strategy recommendation.
```

### After Receiving Recommendation

1. **Review Phase Analyzer's Handoff** (internal)

2. **Present Analysis Summary to User** (MANDATORY before AskUserQuestion):

   Output the following information:

   **A. Task List with Complexity**

   | Task | Description | Score | Grade |
   |------|-------------|-------|-------|
   | T-N.1 | {task description} | {5-20} | Simple/Moderate/Complex/Critical |

   **B. Scoring Method Summary**

   - 5 dimensions: Change Volume, Structural Complexity, Dependency, Precedent, Change Type
   - Each dimension: 1-4 points (total 5-20)
   - Grade thresholds: Simple(5-8), Moderate(9-12), Complex(13-16), Critical(17+)

   **C. Task Dependency Graph** (if inter-task dependency exists)

   ```
   T-1.1 → T-1.2 → T-1.4
   T-1.3 ────────↗
   ```

   **D. Phase Summary**

   - Grade distribution: {N} Simple, {M} Moderate, ...
   - Highest complexity: T-N.M ({reason})
   - Inter-task dependency: low/medium/high

3. **Ask User via AskUserQuestion**:
   - Recommended strategy (mark as recommended)
   - Alternative options

4. Execute based on user's choice:

| Choice | Workflow |
|--------|----------|
| No Plan Mode | Execute directly → Mark complete → `/save` |
| Phase level | Plan Mode once → Plan all Tasks → Execute all → `/save` |
| Task level | Per Task: Plan Mode → Execute → Mark complete |

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
| Brief | `BRIEF.md` | Decisions Made (D-NNN), Background, Discussion |
