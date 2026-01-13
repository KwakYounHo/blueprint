---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, implementation-notes, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Implementation Notes FrontMatter

> Extends base schema for tracking implementation deviations, issues, and learnings.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `plan-id` | string | Reference to parent plan |

## Field Definitions

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Description**: Reference to the parent Master Plan.

## Status Definitions

| Value | Description |
|-------|-------------|
| `active` | Implementation ongoing, notes being added |
| `completed` | Implementation finished |
| `archived` | Historical reference |

## Implementation Notes Body Sections

### Required Sections

1. **Deviations from Plan** - Changes from original plan
2. **Issues Encountered** - Problems and resolutions
3. **Learnings** - Insights for future reference

### Optional Sections

4. **Environment Notes** - Configuration and settings
5. **Timeline** - Implementation milestones

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `implementation-notes` |
| Location | `blueprint/plans/{plan-id}/implementation-notes.md` |
| Creation | Created during implementation, not planning |

## Template

For complete example, use:

```bash
blueprint.sh forma show implementation-notes
```
