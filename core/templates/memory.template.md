---
type: memory
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [memory]
dependencies: []

source-discussion: "{discussion-id}.md"
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

## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | {this file} | active |
| Lib Spec | blueprint/specs/lib/{name}/spec.yaml | draft |
| Feature Spec | blueprint/specs/features/{name}/spec.yaml | draft |
