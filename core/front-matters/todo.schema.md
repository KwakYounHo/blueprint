---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, todo, tasks, front-matter]
dependencies: [base.schema.md]
---

# Schema: TODO FrontMatter

> Extends base schema with TODO-specific fields. TODO.md tracks detailed tasks within phases.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `plan-id` | string | Parent plan identifier (PLAN-NNN) |
| `current-phase` | number | Current phase number |
| `current-task` | string | Current Task identifier (T-N.M) |

## Field Definitions

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Examples**: `"PLAN-001"`, `"PLAN-042"`
- **Description**: Reference to the parent Master Plan.

### current-phase

- **Type**: number
- **Required**: Yes
- **Minimum**: 1
- **Description**: Current phase number. Updated when phase changes.

### current-task

- **Type**: string
- **Required**: Yes
- **Format**: `T-{N}.{M}` where N is phase number, M is task number
- **Examples**: `"T-1.1"`, `"T-3.2"`
- **Description**: Current Task identifier. Must match CURRENT.md.

## Status Definitions

| Value | Description |
|-------|-------------|
| `active` | Task tracking in progress |
| `completed` | All tasks done |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `todo` |
| Location | `blueprint/plans/{plan-id}/session-context/TODO.md` |
| Update | Updated by /save command |

## Template

For complete example, use:

```bash
blueprint forma show todo
```
