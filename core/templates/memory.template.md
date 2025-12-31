---
type: memory
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [memory]
dependencies: []

source-discussion: null
session-count: 1
last-session: {{date}}
generated-specs: []
---

# Memory: {Feature Name}

## CRITICAL: Specification Principles

### Implementer Rules
- **Deterministic**: Any Implementer MUST produce identical code
- **No Ambiguity**: If two interpretations possible, Spec is incomplete
- **Specifier's Job**: Eliminate all ambiguous points before Spec completion

---

## Session Log

### {{date}} Session 1

User: "{verbatim quote - initial requirement or context}"

Me: {brief acknowledgment or clarification asked}

User: "{response or elaboration}"

Me: {analysis or decision made}

> **D-001**: {decision summary} - {rationale}

---

## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | {decision} | {why} | 1 |

---

## [DECIDE] Items (Pending)

| ID | Question | Options | Status |
|----|----------|---------|--------|
| DECIDE-001 | {question} | A, B, C | pending |

---

## Codebase Analysis

### Existing Patterns
- {pattern discovered}

### File Locations
| Context | Pattern | Example |
|---------|---------|---------|
| {context} | {pattern} | {example path} |

---

## Implementation Plan

### Proposed Specs
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
| Memory | {this file} | active |
| Lib Spec | blueprint/specs/lib/{namespace}/{name}/spec.yaml | draft |
| Feature Spec | blueprint/specs/features/{name}/spec.yaml | draft |
