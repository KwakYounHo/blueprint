---
type: lib-spec
status: draft
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [spec, lib]
dependencies: []

spec-id: "LIB-{namespace}/{module}"
name: "{Module Name}"
plan-id: "PLAN-{NNN}"
---

# {Module Name}

## 1. Purpose

{Single sentence describing what this module does.}

## 2. File Location

```
{exact/path/to/file.ts}
```

## 3. Implementation

```typescript
// Complete code - NO placeholders
// Forbidden: "// TODO", "...", "REPLACE_*"

{actual implementation code}
```

## 4. Integration Point

**Called from**: `{file.ts:line}` in `{function/context}`

```typescript
import { xxx } from "{path}";

// How this module is used
{usage example}
```

## 5. Acceptance Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | {criterion} | {how to verify} |
| 2 | {criterion} | {how to verify} |

---

## 6. Prerequisites (Optional)

> Tacit knowledge documentation for new contributors.

### Project Context
- Directory convention: {describe project-specific structure}
- Path alias: {document any path aliases used}

### Existing Dependencies
| Function/Module | Location | Note |
|-----------------|----------|------|
| `{functionName}` | `{path}` | {note if duplicates exist or special usage} |

---

## 7. Invariants (Optional)

> System invariants: violations indicate bugs.

| ID | Description | Assertion | Verification |
|----|-------------|-----------|--------------|
| INV-001 | {what must always be true} | `{formal assertion}` | {how to verify} |

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
