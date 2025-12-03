---
type: schema
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [schema, task, front-matter, workflow]
dependencies: [front-matters/base.schema.md, front-matters/stage.schema.md]
---

# Schema: Task FrontMatter

> Extends base schema with Task-specific fields. Task defines "How" - the methods to achieve Stage requirements.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Task identifier |
| `stage` | string | Parent stage name |
| `order` | number | Execution sequence within the stage |
| `parallel-group` | string \| null | Parallel execution group identifier |

## Field Definitions

### name

- **Type**: string
- **Required**: Yes
- **Format**: lowercase, hyphen-separated
- **Examples**: `gather-requirements`, `validate-scope`, `implement-logic`
- **Description**: Unique identifier within the parent Stage.

### stage

- **Type**: string
- **Required**: Yes
- **Values**: Parent stage's `name` field value
- **Examples**: `requirement-analysis`, `core-implementation`, `testing`
- **Description**: References the parent Stage this task belongs to.

### order

- **Type**: number
- **Required**: Yes
- **Format**: Positive integer (1-99)
- **Examples**: `1`, `2`, `3`
- **Description**: Defines the execution sequence within the Stage. Lower numbers execute first.

**Constraints**:
- Must be unique within the same Stage
- Should match the `TT` portion of the filename

### parallel-group

- **Type**: string | null
- **Required**: No
- **Default**: `null`
- **Examples**: `"initial-analysis"`, `"data-collection"`, `null`
- **Description**: Identifies tasks that can be executed in parallel.

**Rules**:

| Value | Behavior |
|-------|----------|
| `null` | Sequential execution (waits for previous task to complete) |
| `"group-name"` | Parallel execution with other tasks sharing the same group name |

**Execution Flow Example**:

```
task-01-01 (parallel-group: null)
    │
    ▼
┌─────────────────────────────────┐
│ parallel-group: "analysis"      │
├───────────────┬─────────────────┤
│ task-01-02    │ task-01-03      │  ← Execute simultaneously
└───────────────┴─────────────────┘
    │
    ▼
task-01-04 (parallel-group: null)
```

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `task` |
| Status | Must be: `draft`, `active`, `deprecated`, `archived` |
| File Name | Must follow pattern: `task-{SS}-{TT}-{name}.md` |
| Stage Match | `SS` in filename must match parent Stage's `order` |
| Order Match | `order` value must match `TT` in filename |
| Name Match | `name` value must match `{name}` portion of filename |
| Stage Reference | `stage` must match an existing Stage's `name` |

## Field Guidelines

### tags (recommended)

- Include: `[task, {stage-name}]`
- Example: `[task, requirement-analysis]`

### dependencies (recommended)

- Should reference the parent Stage document
- Example: `[stage-01-requirement-analysis.md]`

## Usage Examples

### Sequential Task

```yaml
---
type: task
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [task, requirement-analysis]
dependencies: [stage-01-requirement-analysis.md]

name: "gather-requirements"
stage: "requirement-analysis"
order: 1
parallel-group: null
---
```

### Parallel Tasks (Same Group)

```yaml
---
type: task
status: draft
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [task, requirement-analysis]
dependencies: [stage-01-requirement-analysis.md]

name: "validate-scope"
stage: "requirement-analysis"
order: 2
parallel-group: "analysis"
---
```

```yaml
---
type: task
status: draft
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [task, requirement-analysis]
dependencies: [stage-01-requirement-analysis.md]

name: "document-constraints"
stage: "requirement-analysis"
order: 3
parallel-group: "analysis"
---
```

### Task in Different Stage

```yaml
---
type: task
status: draft
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [task, core-implementation]
dependencies: [stage-02-core-implementation.md]

name: "implement-logic"
stage: "core-implementation"
order: 2
parallel-group: null
---
```

## Hierarchy Context

```
Phase (phase.schema.md)
└── Stage (stage.schema.md)
    └── Task (this schema)            ← Task depends on Stage
        └── Progress (progress.schema.md) ← Progress tracks Tasks
```

- Each Stage has multiple Tasks
- Each Task belongs to one Stage (referenced via `stage` field)
- Tasks with same `parallel-group` value can execute simultaneously
- Progress document tracks completion of all Tasks
