---
type: schema
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [schema, phase, front-matter, workflow]
dependencies: [front-matters/base.schema.md]
---

# Schema: Phase FrontMatter

> Extends base schema with Phase-specific fields. Phase defines "Why" - the background and purpose of a Workflow.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `workflow-id` | string | Unique workflow identifier |

## Field Definitions

### workflow-id

- **Type**: string
- **Required**: Yes
- **Format**: `{NNN}-{short-description}`
- **Pattern**: `^\d{3}-[a-z0-9-]+$`
- **Examples**: `001-initialize-documents`, `002-user-authentication`, `042-payment-flow`
- **Description**: Unique identifier for the workflow. Used for directory naming and branch naming.

**Composition**:

| Component | Format | Description |
|-----------|--------|-------------|
| `NNN` | 3-digit, zero-padded | Sequential workflow number |
| `short-description` | lowercase, hyphen-separated | Brief workflow description |

**Constraints**:
- Directory name must equal `workflow-id`
- Git branch name must equal `workflow-id`

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `phase` |
| Status | Must be: `draft`, `archived`, `deprecated` |
| File Name | Phase document must be named `spec.md` |
| Uniqueness | `workflow-id` must be unique across all workflows |
| Directory Match | Parent directory name must equal `workflow-id` |

**Status Note**: Phase does not use `active` status. Once the problem definition is finalized, Phase transitions directly from `draft` to `archived`. This reflects the principle that **the problem being solved should not change** - if it does, it becomes a different Workflow.

## Field Guidelines

### tags (recommended)

- Include relevant domain tags for the workflow
- Example: `[authentication, security, user-management]`

### dependencies (recommended)

- Phase is the root document of a workflow
- Should be empty array: `[]`
- If workflow depends on another workflow's completion, reference that workflow's spec.md

## Usage Examples

### New Workflow - Draft Phase

```yaml
---
type: phase
status: draft
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [documentation, initialization]
dependencies: []

workflow-id: "001-initialize-documents"
---
```

### Finalized Phase - Ready for Implementation

```yaml
---
type: phase
status: archived
version: 1.0.0
created: 2025-11-20
updated: 2025-11-28
tags: [authentication, security, oauth]
dependencies: []

workflow-id: "002-user-authentication"
---
```

### Workflow with External Dependency

```yaml
---
type: phase
status: draft
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [payment, integration]
dependencies: [../002-user-authentication/spec.md]

workflow-id: "003-payment-integration"
---
```

## Workflow Hierarchy Context

```
Workflow Directory (workflows/{workflow-id}/)
└── Phase (this schema)         ← spec.md - Root document
    └── Stage (stage.schema.md) ← stage-*.md - depends on spec.md
        └── Task (task.schema.md)   ← task-*.md - depends on stage
            └── Progress (progress.schema.md) ← progress.md - depends on tasks
```

## Lifecycle

```
Phase Created (status: draft)
    │
    ▼
Phase Finalized (status: archived)  ← Problem definition confirmed
    │
    ▼
Stages & Tasks Created (referencing this Phase)
    │
    ▼
Workflow Completed (Phase remains archived)
```

**Key Principle**: Phase transitions directly from `draft` to `archived`. The `archived` status for Phase means "problem definition is finalized" - Stage/Task creation can only begin after Phase is archived.
