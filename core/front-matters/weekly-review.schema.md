---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, weekly-review, metrics]
dependencies: [base.schema.md]
---

# Schema: Weekly Review

> Defines FrontMatter fields for weekly review documents.

## Inherits

All fields from `base.schema.md` (type, status, version, created, updated, tags, dependencies)

## Type-Specific Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `plan-id` | string | Plan identifier (e.g., "PLAN-001") |
| `week-start` | date | Start date of the review week |
| `week-end` | date | End date of the review week |

## Type-Specific Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `sessions-count` | number | `0` | Number of sessions during this week |

## Field Definitions

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}` where NNN is zero-padded number
- **Example**: `"PLAN-001"`, `"PLAN-042"`
- **Description**: Links this weekly review to its parent Plan.

### week-start

- **Type**: date
- **Required**: Yes
- **Format**: `YYYY-MM-DD`
- **Example**: `2026-01-06`
- **Description**: First day of the review period (typically Monday).

### week-end

- **Type**: date
- **Required**: Yes
- **Format**: `YYYY-MM-DD`
- **Example**: `2026-01-12`
- **Description**: Last day of the review period (typically Sunday).

### sessions-count

- **Type**: number
- **Required**: No
- **Default**: `0`
- **Example**: `5`
- **Description**: Total number of work sessions during this week.

## Status Values

| Value | Description |
|-------|-------------|
| `completed` | Weekly review finalized |

## Validation Rules

1. `week-end` MUST be after `week-start`
2. `week-end - week-start` SHOULD be approximately 7 days
3. `sessions-count` MUST be non-negative integer
4. `plan-id` MUST reference an existing Plan

## Example FrontMatter

```yaml
---
type: weekly-review
status: completed
version: 1.0.0
created: 2026-01-12
updated: 2026-01-12
tags: [weekly-review, metrics, progress]
dependencies: [../PLAN.md, HISTORY.md]

plan-id: "PLAN-001"
week-start: "2026-01-06"
week-end: "2026-01-12"
sessions-count: 5
---
```

## File Location

Weekly reviews are stored in the session-context directory:

```
blueprint/plans/{nnn}-{topic}/session-context/WEEKLY-REVIEW-{YYYY-MM-DD}.md
```

Or in archive after checkpoint:

```
blueprint/plans/{nnn}-{topic}/session-context/archive/{DATE}/WEEKLY-REVIEW-{YYYY-MM-DD}.md
```
