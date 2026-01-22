---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, roadmap, session, front-matter]
dependencies: [base.schema.md]
---

# Schema: Roadmap FrontMatter

> Extends base schema with Roadmap-specific fields. Roadmap files track Phase progress for a Plan.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `plan-id` | string | Parent plan identifier (PLAN-NNN) |
| `source-plan` | string | Path to PLAN.md |

## Field Definitions

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Examples**: `"PLAN-001"`, `"PLAN-042"`
- **Description**: Reference to the parent Plan.

### source-plan

- **Type**: string
- **Required**: Yes
- **Format**: Relative path to PLAN.md
- **Examples**: `"PLAN.md"`
- **Description**: Source file for Phase definitions. ROADMAP Phase list should sync with this file.

## Status Definitions

| Value | Description |
|-------|-------------|
| `active` | Tracking in progress |
| `completed` | All phases done |
| `archived` | Plan archived |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `roadmap` |
| Location | `blueprint/plans/{plan-id}/ROADMAP.md` |
| Sync | Phase and Task list must match PLAN.md |
| Task Format | Tasks use `T-{N}.{M}` format under each Phase |

## Template

For complete example, use:

```bash
blueprint forma show roadmap
```
