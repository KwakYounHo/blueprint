---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, plan, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Plan FrontMatter

> Extends base schema with Plan-specific fields. Plan files define high-level implementation phases and track progress through Directive Markers.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `plan-id` | string | Unique plan identifier (PLAN-NNN) |
| `name` | string | Human-readable plan name |
| `source-brief` | string | Reference to brief file |
| `phase-count` | number | Number of phases in plan |

## Additional Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `task-count` | number | Total number of Tasks across all Phases |

## Field Definitions

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Examples**: `"PLAN-001"`, `"PLAN-042"`
- **Description**: Unique identifier for the plan, used for cross-referencing.

### name

- **Type**: string
- **Required**: Yes
- **Format**: Human-readable, concise
- **Examples**: `"ElevenLabs TTS Integration"`, `"User Authentication System"`
- **Description**: Descriptive name for the plan.

### source-brief

- **Type**: string
- **Required**: Yes
- **Format**: Relative path to brief file
- **Default**: `"BRIEF.md"`
- **Description**: Reference to the brief file containing decisions and context.

### phase-count

- **Type**: number
- **Required**: Yes
- **Minimum**: 1
- **Description**: Total number of implementation phases defined in the plan.

### task-count

- **Type**: number
- **Required**: No
- **Minimum**: 1
- **Description**: Total number of Tasks across all Phases. Useful for validation and progress tracking.

## Status Definitions

| Value | Description |
|-------|-------------|
| `draft` | Plan in progress, may have unresolved [DECIDE] markers |
| `ready` | All [DECIDE] resolved, ready for implementation |
| `in-progress` | Implementation underway |
| `completed` | All phases implemented |
| `archived` | Plan superseded or abandoned |

## Plan Body Sections

### Required Sections

1. **Overview** - Goal and Success Criteria
2. **Phases** - Implementation phases with deliverables
3. **[FIXED] Constraints** - Immutable constraints
4. **Lib/Feature Classification** - Rule of Three application
5. **Implementation Order** - Dependency-based sequence
6. **Next Steps** - Immediate action items

### Directive Markers

| Marker | Purpose | Usage |
|--------|---------|-------|
| `[FIXED]` | Protected constraints | MUST NOT modify without user approval |
| `[INFER: topic]` | Analysis-derivable | Fill from codebase analysis |
| `[DECIDE: topic]` | User judgment needed | Block until resolved |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `plan` |
| Location | `blueprint/plans/{plan-id}/PLAN.md` |
| Brief | Must have corresponding BRIEF.md in same directory |
| Directive Markers | All `[DECIDE]` must be resolved before `status: ready` |

## Template

For complete example, use:

```bash
blueprint.sh forma show plan
```
