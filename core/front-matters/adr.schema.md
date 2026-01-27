---
type: schema
status: active
version: 0.0.1
created: 2026-01-27
updated: 2026-01-27
tags: [schema, adr, front-matter]
dependencies: [base.schema.md]
---

# Schema: ADR (Architecture Decision Record) FrontMatter

> Extends base schema for documenting architecturally significant decisions.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `deciders` | string[] | People who made the decision |

## Additional Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `supersedes` | string[] | ADR IDs this decision replaces |
| `superseded-by` | string[] | ADR IDs that replace this decision |

## Field Definitions

### deciders

- **Type**: string[]
- **Required**: Yes
- **Format**: List of names or identifiers
- **Description**: People who participated in making the decision.

### supersedes

- **Type**: string[]
- **Required**: No
- **Default**: `[]`
- **Format**: `["ADR-NNN", ...]`
- **Description**: Previous ADRs that this decision replaces. When set, referenced ADRs should have `superseded-by` pointing back.

### superseded-by

- **Type**: string[]
- **Required**: No
- **Default**: `[]`
- **Format**: `["ADR-NNN", ...]`
- **Description**: Newer ADRs that replace this decision. When set, this ADR's status should be `superseded`.

## Status Definitions

| Value | Description |
|-------|-------------|
| `proposed` | Decision under consideration, not yet accepted |
| `accepted` | Decision approved and in effect |
| `deprecated` | Decision still valid but discouraged for new work |
| `superseded` | Decision replaced by another ADR (see `superseded-by`) |

## ADR Body Sections

### Required Sections

| Section | Description |
|---------|-------------|
| `## Context` | Why this decision was needed. Problem statement and background. |
| `## Decision` | What was decided. The core of the ADR. |
| `## Consequences` | Results of the decision. Must include at least one of: Positive, Negative, or Neutral. |

### Conditionally Required Sections

| Section | Condition | Description |
|---------|-----------|-------------|
| `## Considered Options` | If alternatives were evaluated | Options considered with pros/cons |
| `### Current State` | If describing existing system | Diagrams, architecture before change |
| `### Problem` | If distinct from context | Specific problem being solved |
| `### Requirements` | If explicit requirements exist | Constraints that must be satisfied |
| `### Rationale` | If decision needs justification | Why this option was chosen |
| `### Details` | If implementation specifics exist | Configuration, workflow, structure details |
| `## Confirmation` | If verification method exists | How to confirm decision is implemented correctly |
| `## References` | If external sources exist | Links, related ADRs, documentation |

### Extension Rule

> **IMPORTANT**: Sections are conditionally required based on content existence.
> If relevant content exists for a section, that section MUST be included.
> Do NOT omit, summarize, or compress content to fit the template.
> The template defines minimum structure; extend freely as needed.

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `adr` |
| Location | `docs/adr/NNN-{slug}.md` |
| Numbering | Sequential, zero-padded (001, 002, ...) |
| Immutability | Accepted ADRs should not be modified except for typos or status changes |
| Supersession | To change a decision, create a new ADR that supersedes the old one |

## Template

For complete example, use:

```bash
blueprint forma show adr
```
