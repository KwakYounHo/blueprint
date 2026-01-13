---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, history, sessions, front-matter]
dependencies: [base.schema.md]
---

# Schema: History FrontMatter

> Extends base schema with History-specific fields. HISTORY.md is an append-only log of all sessions.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `plan-id` | string | Parent plan identifier (PLAN-NNN) |
| `session-count` | number | Total sessions recorded |

## Field Definitions

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Examples**: `"PLAN-001"`, `"PLAN-042"`
- **Description**: Reference to the parent Master Plan.

### session-count

- **Type**: number
- **Required**: Yes
- **Minimum**: 0
- **Description**: Total number of sessions recorded. Incremented by each /save.

## Status Definitions

| Value | Description |
|-------|-------------|
| `active` | Accepting new session entries |
| `archived` | Plan completed, no more sessions |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `history` |
| Location | `blueprint/plans/{plan-id}/session-context/HISTORY.md` |
| Append-only | New sessions appended, existing entries not modified |
| Compression | /checkpoint may compress and move old entries to archive |

## Template

For complete example, use:

```bash
blueprint forma show history
```
