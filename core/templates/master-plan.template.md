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

### Phase 1: {Phase Name}

**Objective**: {What this phase achieves}

**Deliverables**:
- [ ] {deliverable-1}
- [ ] {deliverable-2}

**Dependencies**: None

---

### Phase 2: {Phase Name}

**Objective**: {What this phase achieves}

**Deliverables**:
- [ ] {deliverable-1}

**Dependencies**: Phase 1

---

### Phase 3: Integration

**Objective**: Connect all components into working feature

**Deliverables**:
- [ ] FEAT-{feature-name}

**Dependencies**: Phase 1, Phase 2

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

## Lib/Feature Classification

> Rule of Three: If used 3+ times OR has standalone value, classify as Lib.

| Spec ID | Type | Justification |
|---------|------|---------------|
| LIB-{ns}/{mod} | lib | {why lib: reused 3+ times / standalone value} |
| FEAT-{name} | feature | {why feature: single-use integration} |

---

## Implementation Order

```
Phase 1: {Name}
├── LIB-{namespace}/{module-a}    [no deps]
└── LIB-{namespace}/{module-b}    [no deps]

Phase 2: {Name}
└── LIB-{namespace}/{module-c}    [deps: Phase 1]

Phase 3: Integration
└── FEAT-{feature-name}           [deps: All libs]
```

---

## Next Steps

1. [ ] Resolve all [DECIDE] markers
2. [ ] Create lib specs in `lib/` directory
3. [ ] Create feature specs in `feature/` directory
4. [ ] Use Claude Code Plan Mode for detailed implementation
