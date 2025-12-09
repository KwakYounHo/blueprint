---
type: schema
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [schema, discussion, front-matter, lorekeeper]
dependencies: [front-matters/base.schema.md]
---

# Schema: Discussion FrontMatter

> Extends base schema with Discussion-specific fields. Discussion captures verbatim records of user conversations created by Lorekeeper.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `session-count` | number | Number of recorded sessions |

## Additional Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `summary` | string | `null` | Brief summary of discussion (used in filename) |

## Field Definitions

### session-count

- **Type**: number
- **Required**: Yes
- **Format**: Positive integer (1+)
- **Examples**: `1`, `2`, `3`
- **Description**: Tracks how many sessions have been recorded in this discussion.

**Rules**:
- Increment when a new session is added
- Minimum value is `1`

### summary

- **Type**: string | null
- **Required**: No
- **Default**: `null`
- **Format**: lowercase, hyphen-separated
- **Examples**: `"user-auth-design"`, `"api-architecture"`, `null`
- **Description**: Brief summary used when renaming the file upon completion.

**Rules**:
- Set to `null` while recording is in progress
- Set when status changes to `archived`
- Used to rename file from `{NNN}.md` to `{NNN}-{summary}.md`

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `discussion` |
| Status | Must be: `recording`, `archived` |
| File Name | Start: `{NNN}.md`, End: `{NNN}-{summary}.md` |
| Summary Timing | `summary` should be set when status becomes `archived` |

## Status Definitions

| Value | Description |
|-------|-------------|
| `recording` | Discussion in progress, sessions can be added |
| `archived` | Discussion complete, no more sessions |

## Field Guidelines

### tags (recommended)

- Include: `[discussion]`
- Add topic tags when archiving
- Example: `[discussion, user-auth, oauth]`

### dependencies (optional)

- Generally empty for discussions
- May reference related discussions if continuation

## Template

For complete example, use:

```bash
forma show discussion
```

## File Naming Convention

| Phase | Pattern | Example |
|-------|---------|---------|
| Start | `{NNN}.md` | `001.md` |
| Complete | `{NNN}-{summary}.md` | `001-user-auth-design.md` |

- `NNN`: Zero-padded sequential number (001, 002, ...)
- `summary`: Value from `summary` field

## Location

```
blueprint/
└── discussions/
    ├── 001.md                      # Recording
    ├── 002-api-architecture.md     # Archived
    └── 003-database-design.md      # Archived
```
