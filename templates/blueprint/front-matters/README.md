# FrontMatters

> FrontMatter definitions for validation. Used by Documentation Gate.

---

## Purpose

This directory defines **valid FrontMatter structure** for each document type:

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
front-matters/
├── README.md                    # This file
├── base.schema.md               # Shared fields across all types
├── constitution.schema.md       # Constitution FrontMatter schema
├── gate.schema.md               # Gate FrontMatter schema
├── aspect.schema.md             # Aspect FrontMatter schema
├── feature.schema.md            # Feature FrontMatter schema
└── artifact.schema.md           # Artifact FrontMatter schema (spec, plan, task, review)
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

### base.schema.md

Fields shared by **all document types**:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | enum | Yes | Document type identifier |
| `status` | enum | Yes | Document lifecycle status |
| `version` | semver | Yes | Document version (MAJOR.MINOR.PATCH) |
| `created` | date | Yes | Creation date (YYYY-MM-DD) |
| `updated` | date | Yes | Last update date (YYYY-MM-DD) |
| `tags` | string[] | No | Searchable keywords |
| `dependencies` | string[] | No | Documents this document depends on (upstream) |

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
        ├── Load: front-matters/base.schema.md
        ├── Load: front-matters/{type}.schema.md
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

### Use base.schema.md

Extract shared fields to avoid duplication across schemas.

### Version with Framework

Schemas are part of the framework, not project-specific customization.

---

## Related

- `../gates/documentation/` for Documentation Gate definition
- `../constitutions/` for documents that follow these schemas
- `../../../README.md` for Global Rules section
