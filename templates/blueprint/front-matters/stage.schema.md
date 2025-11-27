---
type: schema
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [schema, stage, front-matter, workflow]
dependencies: [front-matters/base.schema.md, front-matters/phase.schema.md]
---

# Schema: Stage FrontMatter

> Extends base schema with Stage-specific fields. Stage defines "What" - the requirements to fulfill within a Workflow.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Stage identifier |
| `order` | number | Execution sequence within the workflow |

## Field Definitions

### name

- **Type**: string
- **Required**: Yes
- **Format**: lowercase, hyphen-separated
- **Examples**: `requirement-analysis`, `core-implementation`, `testing`
- **Description**: Unique identifier within the parent Phase. Referenced by child Tasks via their `stage` field.

### order

- **Type**: number
- **Required**: Yes
- **Format**: Positive integer (1-99)
- **Examples**: `1`, `2`, `3`
- **Description**: Defines the execution sequence. Lower numbers execute first.

**Constraints**:
- Must be unique within the same workflow
- Should match the `SS` portion of the filename

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `stage` |
| Status | Must be: `draft`, `active`, `deprecated`, `archived` |
| File Name | Must follow pattern: `stage-{SS}-{name}.md` |
| Order Match | `order` value must match `SS` in filename |
| Name Match | `name` value must match `{name}` portion of filename |

## Field Guidelines

### tags (recommended)

- Include: `[stage, {stage-name}]`
- Example: `[stage, requirement-analysis]`

### dependencies (recommended)

- Should reference the parent Phase document
- Example: `[spec.md]`

## Usage Examples

### Requirement Analysis Stage

```yaml
---
type: stage
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [stage, requirement-analysis]
dependencies: [spec.md]

name: "requirement-analysis"
order: 1
---
```

### Core Implementation Stage

```yaml
---
type: stage
status: draft
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [stage, core-implementation]
dependencies: [spec.md]

name: "core-implementation"
order: 2
---
```

### Testing Stage

```yaml
---
type: stage
status: draft
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [stage, testing]
dependencies: [spec.md]

name: "testing"
order: 3
---
```

## Hierarchy Context

```
Phase (phase.schema.md)
└── Stage (this schema)       ← Stage depends on Phase
    └── Task (task.schema.md) ← Task references Stage via `stage` field
```

- Each Phase has multiple Stages
- Each Stage belongs to one Phase (referenced via `dependencies: [spec.md]`)
- Tasks reference their parent Stage via the `stage` field (matches Stage's `name`)
