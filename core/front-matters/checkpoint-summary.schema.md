---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, checkpoint, milestone, front-matter]
dependencies: [base.schema.md]
---

# Schema: Checkpoint Summary FrontMatter

> Extends base schema with Checkpoint Summary-specific fields. Created when /checkpoint archives a completed phase.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `plan-id` | string | Parent plan identifier (PLAN-NNN) |
| `phase-completed` | number | Phase number that was completed |
| `sessions-archived` | number | Number of sessions in this checkpoint |

## Field Definitions

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Examples**: `"PLAN-001"`, `"PLAN-042"`
- **Description**: Reference to the parent Master Plan.

### phase-completed

- **Type**: number
- **Required**: Yes
- **Minimum**: 1
- **Description**: The phase number that was completed and archived.

### sessions-archived

- **Type**: number
- **Required**: Yes
- **Minimum**: 0
- **Description**: Number of sessions included in this checkpoint.

## Status Definitions

| Value | Description |
|-------|-------------|
| `completed` | Checkpoint finalized |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `checkpoint-summary` |
| Location | `blueprint/plans/{plan-id}/session-context/archive/{YYYY-MM-DD}/CHECKPOINT-SUMMARY.md` |
| Immutable | Once created, should not be modified |

## Template

For complete example, use:

```bash
blueprint forma show checkpoint-summary
```
