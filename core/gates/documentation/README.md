# Documentation Gate

> Validates document format compliance. Runs in parallel with Phase Gates.

---

## Purpose

The Documentation Gate ensures **all documents conform to their schema**:

1. **Format Validation**: Front matter follows schema definition
2. **Parallel Execution**: Runs alongside Phase Gates simultaneously
3. **Required for Pass**: Must pass together with Phase Gates for overall success

---

## Background

### Why a Separate Gate?

| Aspect | Code Gates | Documentation Gate |
|--------|------------|-------------------|
| **Focus** | Work quality | Format quality |
| **Examples** | Specification, Implementation | Schema Validation |
| **Execution** | Parallel with other required gates | Parallel with other required gates |

### How It Works

Documentation Gate is typically included in `required-gates` alongside Code Gates:

```yaml
# Orchestrator → Reviewer Handoff
required-gates:
  - specification    # Code Gate
  - documentation    # Document Gate (parallel)
```

- **Both gates run in parallel**
- **Both must pass** for overall review success
- Reviewer aggregates results from all gates

---

## Directory Structure

```
documentation/
├── README.md                    # This file
├── gate.md                      # Gate metadata
└── aspects/
    └── schema-validation.md     # Schema Validation Aspect
```

---

## Gate Definition (`gate.md`)

```yaml
---
type: gate
status: active
version: 1.0.0
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [gate, documentation]
dependencies: []

name: documentation
validates: document
description: "Validates document format compliance against schema definitions"
---
```

---

## Aspects

### Schema Validation (Minimal Start)

The only Aspect for Documentation Gate at launch:

| Aspect | Focus | Criteria |
|--------|-------|----------|
| **Schema Validation** | Front matter compliance | Required fields, valid values, correct types |

Future Aspects (optional expansion):
- Completeness: Required sections exist
- Consistency: Terminology alignment
- Formatting: Markdown style compliance

---

## Validation Flow

```
Orchestrator sends Handoff:
  document: spec.md
  required-gates: [specification, documentation]
        │
        ▼
┌─────────────────────────────────────────────────────────────┐
│ REVIEWER                                                    │
│                                                             │
│   ┌───────────────────┐       ┌───────────────────┐        │
│   │ Specification     │       │ Documentation     │        │
│   │ Gate              │ 병렬   │ Gate              │        │
│   │ (Work quality)    │       │ (Format quality)  │        │
│   └─────────┬─────────┘       └─────────┬─────────┘        │
│             │                           │                   │
│             │                   ┌───────┴───────┐           │
│             │                   ▼               │           │
│             │           Load Schema             │           │
│             │           ├── common.schema       │           │
│             │           └── {type}.schema       │           │
│             │                   │               │           │
│             │                   ▼               │           │
│             │           Validate Front Matter   │           │
│             │                   │               │           │
│             └─────────────┬─────┘               │           │
│                           ▼                                 │
│                   Aggregate Results                         │
│                           │                                 │
│            ┌──────────────┴──────────────┐                  │
│            ▼                             ▼                  │
│       All Pass                      Any Fail                │
└─────────────────────────────────────────────────────────────┘
        │                                 │
        ▼                                 ▼
  Handoff: Pass                    Handoff: Fail + Details
```

---

## Schema Validation Criteria

### Required (Must Pass)

- [ ] `type` field exists and matches valid document types
- [ ] `status` field exists and matches valid values for the document type
- [ ] `created` field exists and follows YYYY-MM-DD format
- [ ] `updated` field exists and follows YYYY-MM-DD format

### Recommended (Should Pass)

- [ ] `tags` field is an array (if present)
- [ ] `related` field contains valid relative paths (if present)
- [ ] Type-specific required fields are present

---

## Feedback Format

When validation fails, Reviewer reports:

```yaml
document: "blueprint/constitutions/base.md"
violations:
  - field: "status"
    expected: "draft | active | deprecated | archived"
    actual: "in-progress"
    suggestion: "For constitution documents, use 'active' instead of 'in-progress'"
  - field: "created"
    expected: "YYYY-MM-DD format"
    actual: "2024/01/15"
    suggestion: "Use ISO date format: 2024-01-15"
```

---

## Related

- `../../front-matters/` for FrontMatter definitions
- `../` (gates/README.md) for Gate classification
- `../../constitutions/workers/reviewer.md` for Reviewer principles
