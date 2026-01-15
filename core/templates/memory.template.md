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

### Affected Files
| File | Change Type | Notes |
|------|-------------|-------|
| {path} | create/modify | {notes} |

---

## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | {PLANS_DIR}/{plan-id}/memory.md | active |
| Master Plan | {PLANS_DIR}/{plan-id}/master-plan.md | draft |
