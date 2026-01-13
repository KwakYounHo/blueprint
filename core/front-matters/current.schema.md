---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, current, session, front-matter]
dependencies: [base.schema.md]
---

# Schema: Current Session FrontMatter

> Extends base schema with Current Session-specific fields. CURRENT.md represents the current session state for handoff.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `plan-id` | string | Parent plan identifier (PLAN-NNN) |
| `session-id` | number | Current session number |
| `current-phase` | number | Current phase number |

## Field Definitions

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Examples**: `"PLAN-001"`, `"PLAN-042"`
- **Description**: Reference to the parent Master Plan.

### session-id

- **Type**: number
- **Required**: Yes
- **Minimum**: 1
- **Description**: Sequential session number. Incremented by each /save.

### current-phase

- **Type**: number
- **Required**: Yes
- **Minimum**: 1
- **Description**: Current phase number from Master Plan.

## Status Definitions

| Value | Description |
|-------|-------------|
| `active` | Current session state |
| `archived` | Moved to history/archive |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `current` |
| Location | `blueprint/plans/{plan-id}/session-context/CURRENT.md` |
| Update | Updated by /save command |

## Template

For complete example, use:

```bash
blueprint forma show current
```
