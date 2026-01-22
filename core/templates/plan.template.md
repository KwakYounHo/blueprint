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
> Triggered by: `/plan` completion OR `/load` with `yes` response.

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

1. Review Phase Analyzer's Handoff:
   - Per-Task scores and evidence
   - Aggregated Phase complexity
   - Recommended strategy with rationale

2. Present to user via AskUserQuestion:
   - Summary of analysis
   - Recommended strategy (mark as recommended)
   - Alternative options

3. Execute based on user's choice:

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
