---
type: schema
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [schema, feature-spec, specification, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Feature Spec FrontMatter

> Extends base schema for Feature Specifications. Feature Specs define composition of Lib Specs for business flow.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `spec-id` | string | Unique spec identifier (FEAT-name) |
| `name` | string | Human-readable feature name |
| `plan-id` | string | Reference to parent plan |
| `lib-dependencies` | array | List of required Lib Specs |

## Field Definitions

### spec-id

- **Type**: string
- **Required**: Yes
- **Format**: `FEAT-{name}`
- **Examples**: `"FEAT-user-authentication"`, `"FEAT-volume-control"`
- **Description**: Unique identifier for the feature.

### name

- **Type**: string
- **Required**: Yes
- **Format**: Human-readable
- **Examples**: `"User Authentication"`, `"Volume Control Feature"`

### plan-id

- **Type**: string
- **Required**: Yes
- **Format**: `PLAN-{NNN}`
- **Description**: Reference to the parent Plan.

### lib-dependencies

- **Type**: array
- **Required**: Yes
- **Format**: List of LIB-{namespace}/{module} IDs
- **Description**: Lib Specs that this feature depends on.

**Structure**:
```yaml
lib-dependencies:
  - LIB-auth/jwt-validator
  - LIB-auth/session-manager
```

## Status Definitions

| Value | Description |
|-------|-------------|
| `draft` | Specification in progress |
| `ready` | All sections complete, ready for implementation |

## Feature Spec Body Sections

### Required Sections (5)

1. **Summary** - What, Why, Scope
2. **Lib Dependencies** - Role of each Lib
3. **Integration Points** - Code changes required
4. **Implementation Order** - Dependency-based sequence
5. **Acceptance Criteria** - Verifiable conditions

### Optional Sections (3)

6. **Dependency Graph** - Transitive dependency analysis
7. **Architecture Decisions** - ADR references
8. **External Contracts** - External API constraints

## Classification Criteria

> Feature Specs compose Lib Specs. They MUST NOT contain implementation details.

| Criterion | Feature | Lib |
|-----------|---------|-----|
| Purpose | Composition/Integration | Declaration/Unit |
| Content | How to connect | What to implement |
| Details | Integration points | Implementation code |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `feature-spec` |
| Location | `blueprint/plans/{plan-id}/feature/{name}.md` |
| Dependencies | All `lib-dependencies` must have corresponding Lib Specs |
| No Implementation | Feature Specs MUST NOT contain implementation code |

## Template

For complete example, use:

```bash
blueprint.sh forma show feature-spec
```
