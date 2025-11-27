---
type: schema
status: active
version: 1.0.0
created: 2024-11-27
updated: 2024-11-27
tags: [schema, aspect, front-matter]
dependencies: [front-matters/base.schema.md, front-matters/gate.schema.md]
---

# Schema: Aspect FrontMatter

> Extends base schema with Aspect-specific fields.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Aspect identifier |
| `gate` | string | Parent gate name |
| `description` | string | What this aspect validates |

## Field Definitions

### name

- **Type**: string
- **Required**: Yes
- **Format**: lowercase, hyphen-separated
- **Examples**: `completeness`, `feasibility`, `code-style`, `schema-validation`
- **Description**: Unique identifier within the parent gate.

### gate

- **Type**: string
- **Required**: Yes
- **Values**: Parent gate's `name` field value
- **Examples**: `specification`, `implementation`, `documentation`
- **Description**: References the parent gate this aspect belongs to.

### description

- **Type**: string
- **Required**: Yes
- **Description**: Human-readable explanation of what this aspect validates.
- **Example**: `"Validates that all functional and non-functional requirements are captured"`

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `aspect` |
| Status | Must be: `draft`, `active`, `deprecated`, `archived` |
| Gate Reference | `gate` must match an existing gate's `name` |

## Field Guidelines

### tags (recommended)

- Include: `[aspect, {gate-name}, {aspect-name}]`
- Example: `[aspect, specification, completeness]`

### dependencies (recommended)

- Should reference the parent gate document
- Example: `[../gate.md]`

## Usage Examples

### Specification Gate - Completeness Aspect

```yaml
---
type: aspect
status: active
version: 1.0.0
created: 2024-11-27
updated: 2024-11-27
tags: [aspect, specification, completeness]
dependencies: [../gate.md]

name: completeness
gate: specification
description: "Validates that all functional and non-functional requirements are captured"
---
```

### Implementation Gate - Code Style Aspect

```yaml
---
type: aspect
status: active
version: 1.0.0
created: 2024-11-27
updated: 2024-11-27
tags: [aspect, implementation, code-style]
dependencies: [../gate.md]

name: code-style
gate: implementation
description: "Validates code style compliance with project standards"
---
```

### Documentation Gate - Schema Validation Aspect

```yaml
---
type: aspect
status: active
version: 1.0.0
created: 2024-11-27
updated: 2024-11-27
tags: [aspect, documentation, schema-validation]
dependencies: [../gate.md]

name: schema-validation
gate: documentation
description: "Validates document FrontMatter compliance against schema definitions"
---
```

## Hierarchy Context

```
Gate (gate.schema.md)
└── Aspect (this schema)      ← Aspect depends on Gate
    └── Criteria (in Body)    ← defined in document content, not FrontMatter
```

- Each Gate has multiple Aspects
- Each Aspect belongs to one Gate (referenced via `gate` field)
- Criteria are defined in the Aspect document body, not FrontMatter
- Reviewer Worker loads Gate + Aspect to perform validation
