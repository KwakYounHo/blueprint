---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, lib-spec, specification, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Lib Spec FrontMatter

> Extends base schema for Library Specifications. Lib Specs define reusable units with single responsibility.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `spec-id` | string | Unique spec identifier (LIB-namespace/module) |
| `name` | string | Human-readable module name |
| `plan-id` | string | Reference to parent plan |

## Field Definitions

### spec-id

- **Type**: string
- **Required**: Yes
- **Format**: `LIB-{namespace}/{module}`
- **Examples**: `"LIB-auth/jwt-validator"`, `"LIB-volume/schema-voice-source"`
- **Description**: Unique identifier following namespace/module convention.

### name

- **Type**: string
- **Required**: Yes
- **Format**: Human-readable
- **Examples**: `"JWT Token Validator"`, `"Voice Source Volume Schema"`

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Description**: Reference to the parent Master Plan.

## Status Definitions

| Value | Description |
|-------|-------------|
| `draft` | Specification in progress |
| `ready` | All sections complete, ready for implementation |

## Lib Spec Body Sections

### Required Sections (5)

1. **Purpose** - Single sentence description
2. **File Location** - Exact file path
3. **Implementation** - Complete code (no placeholders)
4. **Integration Point** - Where it's called from
5. **Acceptance Criteria** - Verifiable conditions

### Optional Sections (3)

6. **Prerequisites** - Project context, existing dependencies
7. **Invariants** - System invariants that must hold
8. **External Contracts** - External API constraints

## Classification Criteria

> Rule of Three: Lib if used 3+ times OR has standalone value.

| Criterion | Lib | Feature |
|-----------|-----|---------|
| Reusability | 3+ uses OR standalone | Single use |
| Responsibility | Single, focused | Composition |
| Testing | Unit test | Integration test |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `lib-spec` |
| Location | `blueprint/plans/{plan-id}/lib/{namespace}/{module}.md` |
| Implementation | Section 3 MUST NOT contain placeholders ("TODO", "...") |
| Deterministic | Any implementer MUST produce identical code |

## Template

For complete example, use:

```bash
blueprint.sh forma show lib-spec
```
