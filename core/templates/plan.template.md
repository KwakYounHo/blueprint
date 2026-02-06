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

> **[FIXED] Document Immutability**: This document is frozen after implementation begins.
> Do NOT modify during implementation. Record deviations, new decisions, and issues
> in `implementation-notes.md` instead.

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

> Reference **Analysis Results** section for Phase-specific Plan Mode decisions.
> If Analysis Results is empty, inform the user that running `/banalyze` is recommended before starting implementation.

### Task Execution Flow

For each Task (using Selected Plan Mode from Analysis Results):

| Selected Mode | Workflow |
|---------------|----------|
| No Plan Mode | Execute directly → Mark complete → `/save` |
| Phase level | Plan Mode once → Plan all Tasks → Execute all → `/save` |
| Task level | Per Task: Plan Mode → Execute → Mark complete |

---

## Analysis Results

> Populated by `/banalyze`. If empty, remind the user to run `/banalyze` before starting implementation.

### Phase Summaries

| Phase | Task Count | Grade Distribution | Highest Complexity | Plan Mode (Recommended) |
|-------|-----------|-------------------|-------------------|------------------------|

### Selected Strategies

| Phase | Recommended | Selected | Rationale |
|-------|------------|----------|-----------|

### Execution Layers

| Phase | Layer | Tasks | Blocked By |
|-------|-------|-------|------------|

### Independent Tasks (Cross-Phase)

| Task | Phase | Files | Independence Reason |
|------|-------|-------|--------------------|

---

## References

| Type | Path | Description |
|------|------|-------------|
| Brief | `BRIEF.md` | Decisions Made (D-NNN), Background, Discussion |
