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

## Phases

> **IMPORTANT**: Before implementing each phase, enter Claude Code's **Plan Mode** for detailed planning.
> Master Plan defines WHAT to build. Plan Mode defines HOW to build it.

### Phase 1: {Phase Name}

**Objective**: {What this phase achieves}

**Deliverables**:
- {deliverable-1}
- {deliverable-2}

**Dependencies**: None

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

### Phase 2: {Phase Name}

**Objective**: {What this phase achieves}

**Deliverables**:
- {deliverable-1}

**Dependencies**: Phase 1

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

## [FIXED] Constraints

> These constraints are confirmed and MUST NOT be changed without user approval.

| ID | Constraint | Rationale |
|----|------------|-----------|
| C-001 | {constraint} | {why this is fixed} |

---

## [INFER: technical-approach]

<!--
Analysis targets: Codebase patterns, existing implementations
Output: Recommended technical approach based on analysis
-->

{Inferred technical approach - fill after codebase analysis}

---

## [DECIDE: {topic}]

<!--
Question: {Specific question requiring user judgment}
Options:
- Option A: {description}
- Option B: {description}
Recommendation: {if any}
-->

---

## References

| Type | Path | Description |
|------|------|-------------|
| Memory | `memory.md` | Decisions Made (D-NNN), Background, Discussion |
