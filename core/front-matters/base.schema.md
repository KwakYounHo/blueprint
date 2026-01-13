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
- **Values**: `schema` | `constitution` | `gate` | `aspect` | `memory` | `discussion` | `master-plan` | `implementation-notes` | `lib-spec` | `feature-spec`
- **Description**: Identifies the document category for routing and validation.

### status

- **Type**: enum
- **Required**: Yes
- **Description**: Current state of the document. Valid values depend on document category.

**Definition Documents** (`schema`, `constitution`, `gate`, `aspect`):
| Value | Description |
|-------|-------------|
| `draft` | Work in progress, not ready for use |
| `active` | Current and in use |
| `deprecated` | Superseded, avoid using |
| `archived` | No longer relevant, kept for history |

**Memory Documents** (`memory`):
| Value | Description |
|-------|-------------|
| `active` | Specification work in progress |
| `completed` | All specs generated, memory archived for reference |
| `archived` | Superseded or abandoned |

**Master Plan Documents** (`master-plan`):
| Value | Description |
|-------|-------------|
| `draft` | Plan in progress, may have unresolved [DECIDE] markers |
| `ready` | All [DECIDE] resolved, ready for implementation |
| `in-progress` | Implementation underway |
| `completed` | All phases implemented |
| `archived` | Plan superseded or abandoned |

**Implementation Notes** (`implementation-notes`):
| Value | Description |
|-------|-------------|
| `active` | Implementation ongoing, notes being added |
| `completed` | Implementation finished |
| `archived` | Historical reference |

**Specification Documents** (`lib-spec`, `feature-spec`):
| Value | Description |
|-------|-------------|
| `draft` | Specification in progress |
| `ready` | All sections complete, ready for implementation |

**Discussion Documents** (`discussion`):
| Value | Description |
|-------|-------------|
| `recording` | Discussion in progress, sessions can be added |
| `archived` | Discussion complete, no more sessions |

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
| `gate` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `aspect` | Definition | `draft`, `active`, `deprecated`, `archived` |
| `memory` | Planning | `active`, `completed`, `archived` |
| `master-plan` | Planning | `draft`, `ready`, `in-progress`, `completed`, `archived` |
| `implementation-notes` | Planning | `active`, `completed`, `archived` |
| `lib-spec` | Specification | `draft`, `ready` |
| `feature-spec` | Specification | `draft`, `ready` |
| `discussion` | Discussion | `recording`, `archived` |
