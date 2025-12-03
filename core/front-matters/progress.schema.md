---
type: schema
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [schema, progress, front-matter, workflow]
dependencies: [front-matters/base.schema.md]
---

# Schema: Progress FrontMatter

> Extends base schema for Progress tracking. Progress defines "How much" - the completion status of Tasks within a Workflow.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

None. Progress uses only the inherited base fields.

## Field Constraints

### type

- **Value**: Must be `progress`

### status

Progress uses **Task category** status values (different from Definition documents):

| Value | Description |
|-------|-------------|
| `pending` | Workflow not yet started |
| `in-progress` | Workflow currently being executed |
| `completed` | All Tasks successfully finished |
| `failed` | Workflow did not complete successfully |

### dependencies

- **Required**: Yes (not optional for Progress)
- **Values**: All Task documents in the workflow
- **Example**: `[task-01-01-gather-requirements.md, task-01-02-validate-scope.md, ...]`
- **Description**: Lists all Tasks that this Progress document tracks.

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `progress` |
| Status | Must be: `pending`, `in-progress`, `completed`, `failed` |
| File Name | Must be named `progress.md` |
| Location | Must be in workflow directory root |
| Singleton | Only one Progress document per workflow |
| Dependencies | Must list all Task documents in the workflow |

## Field Guidelines

### tags (recommended)

- Include: `[progress, tracking]`
- Optionally add workflow-specific tags

### dependencies (required pattern)

- Must include all `task-*.md` files in the workflow
- Update when Tasks are added or removed

## Usage Examples

### New Workflow (Pending)

```yaml
---
type: progress
status: pending
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [progress, tracking]
dependencies:
  - task-01-01-gather-requirements.md
  - task-01-02-validate-scope.md
  - task-02-01-define-interfaces.md
  - task-02-02-implement-logic.md
---
```

### Active Workflow (In Progress)

```yaml
---
type: progress
status: in-progress
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [progress, tracking]
dependencies:
  - task-01-01-gather-requirements.md
  - task-01-02-validate-scope.md
  - task-02-01-define-interfaces.md
  - task-02-02-implement-logic.md
---
```

### Completed Workflow

```yaml
---
type: progress
status: completed
version: 1.0.0
created: 2025-11-20
updated: 2025-11-28
tags: [progress, tracking]
dependencies:
  - task-01-01-gather-requirements.md
  - task-01-02-validate-scope.md
  - task-02-01-define-interfaces.md
  - task-02-02-implement-logic.md
---
```

## Hierarchy Context

```
Phase (phase.schema.md)
└── Stage (stage.schema.md)
    └── Task (task.schema.md)
        └── Progress (this schema)  ← Tracks all Tasks
```

- One Progress document per Workflow
- Tracks completion status of all Tasks
- Updated continuously as Tasks are completed
