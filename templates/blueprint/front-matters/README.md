# FrontMatters

> FrontMatter Schema definitions for validation. Used by Documentation Gate.

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
├── phase.schema.md              # Workflow: Phase (spec.md)
├── stage.schema.md              # Workflow: Stage
├── task.schema.md               # Workflow: Task
└── progress.schema.md           # Workflow: Progress tracking
```

---

## Schema File Structure

Each schema file defines:

```markdown
# Schema: {Document Type}

## Inherits
All fields from `base.schema.md`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| ... | ... | ... |

## Field Definitions

### {field-name}
- **Type**: string | string[] | enum
- **Required**: Yes/No
- **Values**: (for enum types)
- **Description**: ...

## Constraints
| Rule | Description |
|------|-------------|

## Usage Examples
```yaml
---
...
---
```
```

---

## Schema Overview

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

| Document Types | Category | Valid Status Values |
|----------------|----------|---------------------|
| `schema`, `constitution`, `gate`, `aspect`, `worker` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `phase`, `stage`, `task` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `progress` | Task | `pending`, `in-progress`, `completed`, `failed` |

---

## Workflow Schemas

### phase.schema.md

Defines the Phase document (`spec.md`) - "Why" the workflow exists.

| Field | Type | Description |
|-------|------|-------------|
| `workflow-id` | string | Unique workflow identifier (e.g., `001-initialize-documents`) |

### stage.schema.md

Defines Stage documents (`stage-*.md`) - "What" requirements to fulfill.

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Stage identifier |
| `order` | number | Execution order within workflow |

### task.schema.md

Defines Task documents (`task-*.md`) - "How" to achieve requirements.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Task identifier |
| `stage` | string | Yes | Parent stage name |
| `order` | number | Yes | Execution order within stage |
| `parallel-group` | string \| null | Yes | Parallel execution group (null = sequential)

### progress.schema.md

Defines the Progress document (`progress.md`) - "How much" completed.

| Field | Type | Description |
|-------|------|-------------|
| (inherits base) | | No additional required fields |

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
- `../workflows/` for documents that follow these schemas
- `../constitutions/` for documents that follow these schemas
