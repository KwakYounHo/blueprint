---
type: schema
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [schema, gate, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Gate FrontMatter

> Extends base schema with Gate-specific fields.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Gate identifier (used in Handoff `required-gates`) |
| `validates` | enum | What this gate validates |
| `description` | string | Purpose of this gate |

## Field Definitions

### name

- **Type**: string
- **Required**: Yes
- **Format**: lowercase, hyphen-separated
- **Examples**: `specification`, `implementation`, `documentation`
- **Description**: Unique identifier for the gate. Referenced in Orchestrator → Reviewer Handoff.

### validates

- **Type**: enum
- **Required**: Yes
- **Values**: `code` | `document`
- **Description**: Classification of what this gate validates.

| Value | Description | Examples |
|-------|-------------|----------|
| `code` | Validates code/artifact quality | Specification Gate, Implementation Gate |
| `document` | Validates document format compliance | Documentation Gate |

### description

- **Type**: string
- **Required**: Yes
- **Description**: Human-readable explanation of the gate's purpose and focus.
- **Example**: `"Validates specification completeness before implementation"`

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `gate` |
| Status | Must be: `draft`, `active`, `deprecated`, `archived` |
| Name Uniqueness | `name` should be unique across all gates |

## Field Guidelines

### tags (recommended)

- Include: `[gate, {gate-name}]`
- Example: `[gate, specification]`, `[gate, documentation]`

### dependencies (recommended)

- Gates typically have no upstream dependencies
- Example: `[]`

## Template

For complete example, use:

```bash
forma show gate
```

## Execution Context

Gates are **definition documents**, not executable code. Execution is controlled by Orchestrator:

```yaml
# Orchestrator → Reviewer Handoff
handoff:
  action: review
  document: path/to/document
  required-gates:
    - specification    # Gate name
    - documentation    # Gate name
```

The Orchestrator decides:
- **Which gates** to run (via `required-gates`)
- **Pass/fail criteria** (based on Reviewer response)
- **Next action** (proceed, fix, or escalate)
