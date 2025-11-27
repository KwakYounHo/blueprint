# Schemas

> Document format definitions for validation. Used by Documentation Gate.

---

## Purpose

Schemas define **valid front matter structure** for each document type:

1. **Validation**: Documentation Gate uses schemas to validate documents
2. **Reference**: Authors can consult schemas when writing documents
3. **Consistency**: Ensures all documents follow the same structure

---

## Background

### Why Separate Schemas?

From our token efficiency research:
- Schemas are needed at **validation time**, not execution time
- Including schemas in documents wastes tokens
- Reviewers load schemas only when validating

### Schema vs Template

| Concept | Purpose | When Used |
|---------|---------|-----------|
| **Schema** | Defines valid structure | Validation (Documentation Gate) |
| **Template** | Starting point for new documents | Document creation |

---

## Directory Structure

```
schemas/
├── README.md                    # This file
├── common.schema.md             # Shared fields across all types
├── constitution.schema.md       # Constitution document schema
├── gate.schema.md               # Gate document schema
├── aspect.schema.md             # Aspect document schema
├── feature.schema.md            # Feature document schema
└── artifact.schema.md           # Artifact schema (spec, plan, task, review)
```

---

## Schema File Structure

Each schema file defines:

```markdown
# Schema: {Document Type}

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| ... | ... | ... |

## Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| ... | ... | ... | ... |

## Field Definitions

### {field-name}
- **Type**: string | string[] | enum
- **Required**: Yes/No
- **Values**: (for enum types)
- **Description**: ...
```

---

## Planned Schemas

### common.schema.md

Fields shared by **all document types**:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | enum | Yes | Document type identifier |
| `status` | enum | Yes | Document lifecycle status |
| `created` | date | Yes | Creation date (YYYY-MM-DD) |
| `updated` | date | Yes | Last update date (YYYY-MM-DD) |
| `tags` | string[] | No | Searchable keywords |
| `related` | string[] | No | Related document paths |

### Status Values by Document Type

| Document Types | Valid Status Values |
|----------------|---------------------|
| constitution, gate, aspect, phase, stage, worker | `draft`, `active`, `deprecated`, `archived` |
| feature, artifact (spec, plan, task, review) | `pending`, `in-progress`, `completed`, `failed` |

### artifact.schema.md

Contains sections for each artifact type:

- **Specification (spec.md)**: feature-id, requirements, scope
- **Plan (plan.md)**: feature-id, stages, task-list
- **Task (task-*.md)**: task-id, dependencies, acceptance-criteria
- **Review (*-review.md)**: gate, aspect, pass/fail, findings

---

## Usage

### By Documentation Gate

```
Document Created/Modified
        │
        ▼
Documentation Gate Triggered
        │
        ▼
Schema Validation Reviewer
        │
        ├── Load: schemas/common.schema.md
        ├── Load: schemas/{type}.schema.md
        │
        ▼
Validate Front Matter
        │
        ├── Pass: No action
        └── Fail: Report violations
```

### By Authors (Reference)

Authors can consult schemas when uncertain about:
- Required fields for a document type
- Valid values for enum fields
- Correct format for dates, arrays, etc.

---

## Best Practices

### Keep Schemas Minimal

Only include fields that need validation. Don't over-specify.

### Use common.schema.md

Extract shared fields to avoid duplication across schemas.

### Version with Framework

Schemas are part of the framework, not project-specific customization.

---

## Related

- `../gates/documentation/` for Documentation Gate definition
- `../constitutions/` for documents that follow these schemas
- `../../../README.md` for Global Rules section
