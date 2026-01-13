---
type: memory
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [memory]
dependencies: []

plan-id: "PLAN-{NNN}"
source-discussion: null
session-count: 1
last-session: {{date}}
---

# Memory: {Feature Name}

## CRITICAL: Specification Principles

### Implementer Rules
- **Deterministic**: Any Implementer MUST produce identical code
- **No Ambiguity**: If two interpretations possible, Spec is incomplete
- **Specifier's Job**: Eliminate all ambiguous points before Spec completion

---

## Background

{Brief description of the feature/task and its purpose}

### Goals
- {Goal 1}
- {Goal 2}

---

## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | {decision} | {why} | 1 |

---

## [DECIDE] Items

| ID | Question | Options | Decision | Status |
|----|----------|---------|----------|--------|
| DECIDE-001 | {question} | A: {opt1}, B: {opt2} | - | pending |

---

## Codebase Analysis

### Existing Patterns
- {pattern discovered}

### File Locations
| Context | Pattern | Example |
|---------|---------|---------|
| {context} | {pattern} | {example path} |

---

## Scope Summary

### Proposed Structure
| ID | Type | Purpose | Dependencies |
|----|------|---------|--------------|
| LIB-{namespace}/{name} | lib | {purpose} | none |
| FEAT-{name} | feature | {purpose} | LIB-{namespace}/{name} |

### Implementation Order
1. LIB-{namespace}/{name} - {reason}
2. FEAT-{name} - {reason}

### Affected Files
| File | Change Type | Notes |
|------|-------------|-------|
| {path} | create/modify | {notes} |

---

## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | blueprint/plans/{plan-id}/memory.md | active |
| Master Plan | blueprint/plans/{plan-id}/master-plan.md | draft |
| Lib Spec | blueprint/plans/{plan-id}/lib/{namespace}/{name}.md | draft |
| Feature Spec | blueprint/plans/{plan-id}/feature/{name}.md | draft |
