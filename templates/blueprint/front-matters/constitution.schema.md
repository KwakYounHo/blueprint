---
type: schema
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [schema, constitution, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Constitution FrontMatter

> Extends base schema with Constitution-specific fields.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `scope` | enum | Constitution applicability scope |
| `target-workers` | string[] | Workers that must follow this constitution |

## Field Definitions

### scope

- **Type**: enum
- **Required**: Yes
- **Values**: `global` | `worker-specific`
- **Description**: Defines whether this constitution applies globally or to specific workers.

| Value | Description |
|-------|-------------|
| `global` | Applies to all workers (e.g., base.md) |
| `worker-specific` | Applies only to workers listed in `target-workers` |

### target-workers

- **Type**: string[]
- **Required**: Yes
- **Valid Values**: `orchestrator`, `specifier`, `implementer`, `reviewer`, `all`
- **Description**: List of workers that must follow this constitution.

**Rules**:
- `"all"` cannot be combined with other values
- Multiple workers allowed: `["specifier", "implementer"]`

| Example | Meaning |
|---------|---------|
| `["all"]` | All workers must follow |
| `["specifier"]` | Only Specifier |
| `["specifier", "implementer"]` | Specifier and Implementer |

## Constraints

| Rule | Description |
|------|-------------|
| Scope-Target | `scope: global` requires `target-workers: ["all"]` |
| Scope-Target | `scope: worker-specific` forbids `target-workers: ["all"]` |
| Type | `type` field must be `constitution` |
| Status | Must be one of: `draft`, `active`, `deprecated`, `archived` |

## Field Guidelines

### tags (recommended)

- Global constitution: `[principles, global, constitution]`
- Worker-specific: `[worker, {worker-name}, constitution]`

### dependencies (recommended)

- Worker-specific constitutions SHOULD include path to base.md
- Example: `["../base.md"]`

## Usage Examples

### Global Constitution

```yaml
---
type: constitution
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [principles, global, constitution]
dependencies: []

scope: global
target-workers: ["all"]
---
```

### Worker-Specific Constitution

```yaml
---
type: constitution
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [worker, specifier, constitution]
dependencies: ["../base.md"]

scope: worker-specific
target-workers: ["specifier"]
---
```
