---
type: spec
status: draft
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [spec, feature]
dependencies:
  - LIB-{namespace}/{module-a}
  - LIB-{namespace}/{module-b}

spec-type: feature
spec-id: "FEAT-{name}"
name: "{Feature Name}"
source-discussion: "{path/to/discussion.md}"
source-memory: "{path/to/memory.md}"
---

# {Feature Name}

## 1. Summary

### What
{What this feature does.}

### Why
- {Reason 1}
- {Reason 2}

### Scope
- **Include**: {what's in scope}
- **Exclude**: {what's out of scope}

## 2. Lib Dependencies

| Lib Spec | Role |
|----------|------|
| LIB-{namespace}/{module-a} | {role in this feature} |
| LIB-{namespace}/{module-b} | {role in this feature} |

## 3. Integration Points

### 3.1 {Integration Point Name}

**File**: `{path/to/file.ts}` (Line {N})

```typescript
// Code change required
{before → after}
```

### 3.2 {Integration Point Name}

**File**: `{path/to/file.ts}` (Line {N})

```typescript
{code change}
```

## 4. Implementation Order

```
Phase 1: {Phase Name}
├── LIB-{namespace}/{module-a}
└── LIB-{namespace}/{module-b}

Phase 2: {Phase Name}
└── LIB-{namespace}/{module-c}

Phase 3: Integration (This Spec)
├── {integration point 1}
└── {integration point 2}
```

## 5. Acceptance Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | {criterion} | {how to verify} |
| 2 | {criterion} | {how to verify} |

---

## 6. Dependency Graph (Optional)

> Transitive dependency analysis for scope prediction.

| Level | Count | Key Files |
|-------|-------|-----------|
| 0 (Direct) | {N} | {list key files} |
| 1 (Import) | {N} | {list key files} |
| 2 (Type) | {N} | {list key files} |
| **Predicted Total** | **{N}** | |

### Duplicates Detected
| Name | Locations | Resolution |
|------|-----------|------------|
| {name} | {paths} | {action: consolidate/document difference} |

---

## 7. Architecture Decisions (Optional)

> Key architectural decisions for this feature.

| ADR | Decision | Rationale |
|-----|----------|-----------|
| {ADR-NNN} | {what was decided} | {why} |

---

## 8. External Contracts (Optional, Required if external integration)

> Environmental constraints from external systems.

### External APIs
| API | Constraint | Value |
|-----|------------|-------|
| {API name} | {constraint type} | {value} |

### Downstream Requirements
| System | Requirement | Implication |
|--------|-------------|-------------|
| {system} | {requirement} | {what this means for implementation} |
