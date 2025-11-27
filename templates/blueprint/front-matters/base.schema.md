---
type: schema
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [schema, common, front-matter]
dependencies: []
---

# Schema: Common FrontMatter

> Defines FrontMatter fields shared by all document types.

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `type` | enum | Document type identifier |
| `status` | enum | Current document status |
| `version` | semver | Document version |
| `created` | date | Creation date |
| `updated` | date | Last modification date |

## Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `tags` | string[] | `[]` | Searchable keywords |
| `dependencies` | string[] | `[]` | Documents this document depends on (upstream) |

## Field Definitions

### type

- **Type**: enum
- **Required**: Yes
- **Values**: `schema` | `constitution` | `worker` | `gate` | `aspect` | `phase` | `stage` | `task` | `progress`
- **Description**: Identifies the document category for routing and validation.

### status

- **Type**: enum
- **Required**: Yes
- **Description**: Current state of the document. Valid values depend on document category.

**Definition Documents** (`schema`, `constitution`, `worker`, `gate`, `aspect`, `phase`, `stage`, `task`):
| Value | Description |
|-------|-------------|
| `draft` | Work in progress, not ready for use |
| `active` | Current and in use |
| `deprecated` | Superseded, avoid using |
| `archived` | No longer relevant, kept for history |

**Task Documents** (`progress`):
| Value | Description |
|-------|-------------|
| `pending` | Not yet started |
| `in-progress` | Currently being worked on |
| `completed` | Successfully finished |
| `failed` | Did not complete successfully |

### version

- **Type**: string (semver)
- **Required**: Yes
- **Format**: `MAJOR.MINOR.PATCH`
- **Example**: `1.0.0`, `2.1.3`
- **Description**: Semantic version for tracking document changes.

### created

- **Type**: date
- **Required**: Yes
- **Format**: `YYYY-MM-DD`
- **Example**: `2025-11-28`
- **Description**: Date when the document was first created.

### updated

- **Type**: date
- **Required**: Yes
- **Format**: `YYYY-MM-DD`
- **Example**: `2025-11-28`
- **Description**: Date when the document was last modified.

### tags

- **Type**: string[]
- **Required**: No
- **Default**: `[]`
- **Example**: `[schema, common, front-matter]`
- **Description**: Keywords for search and categorization.

### dependencies

- **Type**: string[]
- **Required**: No
- **Default**: `[]`
- **Example**: `[base.schema.md]` (for a schema that extends base)
- **Description**: Documents that this document depends on (upstream dependencies).

**Rules**:
| Rule | Description |
|------|-------------|
| Purpose | List documents this document depends on |
| Scope | Direct dependencies only (1-degree relationship) |
| Direction | Unidirectional (this document → its dependencies) |
| Propagation | When a dependency is modified, scan for documents that depend on it |
| Constraint | Only reference files copied together to target projects |

**Examples**:
| Relationship | Document | dependencies | Meaning |
|--------------|----------|--------------|---------|
| Inheritance | `constitution.schema.md` | `[base.schema.md]` | Extends base schema |
| Composition | `completeness.md` (aspect) | `[../gate.md]` | Belongs to gate |
| Hierarchy | `stage.md` | `[../phase.md]` | Part of phase |

**Change Propagation**:
```
base.schema.md modified
  → Scan all documents for dependencies: [base.schema.md]
  → Found: constitution.schema.md, gate.schema.md
  → These documents need review
```

**Anti-patterns**:
- ❌ Listing downstream (documents affected by this)
- ❌ Listing transitive dependencies (e.g., Stage listing Task)
- ❌ Circular references (A → B → A)
- ❌ Referencing files not copied to target project

## Type-Status Mapping

| Type | Category | Valid Status Values |
|------|----------|---------------------|
| `schema` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `constitution` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `worker` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `gate` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `aspect` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `phase` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `stage` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `task` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `progress` | Task | `pending`, `in-progress`, `completed`, `failed` |
