# Blueprint

> Core framework structure containing Constitutions, Gates, Workflows, and Schemas.

---

## Purpose

This directory is the **heart of the framework**. It contains:

1. **Constitutions**: Principles that Workers must follow
2. **Gates**: Validation checkpoints with Criteria
3. **Workflows**: Work containers (Phase, Stage, Task, Progress)
4. **Schemas**: Document format definitions for validation

---

## Why "Blueprint"?

The name reflects its role:
- A **blueprint** is a design plan that guides construction
- This directory provides the **design plan** for how work should be done
- Workers reference this blueprint to understand principles, validation criteria, and workflow structure

---

## Directory Structure

```
blueprint/
├── README.md                    # This file
│
├── front-matters/               # FrontMatter Schema definitions
│   ├── base.schema.md           # Shared fields across all types
│   ├── constitution.schema.md
│   ├── gate.schema.md
│   ├── aspect.schema.md
│   ├── phase.schema.md          # Workflow: Phase (spec.md)
│   ├── stage.schema.md          # Workflow: Stage
│   ├── task.schema.md           # Workflow: Task
│   └── progress.schema.md       # Workflow: Progress tracking
│
├── constitutions/               # Principles
│   ├── base.md                  # Global principles (all Workers)
│   └── workers/                 # Worker-specific principles
│       ├── orchestrator.md
│       ├── specifier.md
│       ├── implementer.md
│       └── reviewer.md
│
├── gates/                       # Validation checkpoints
│   ├── specification/           # Specification Gate
│   │   ├── gate.md
│   │   └── aspects/
│   ├── implementation/          # Implementation Gate
│   │   ├── gate.md
│   │   └── aspects/
│   └── documentation/           # Documentation Gate (parallel)
│       ├── gate.md
│       └── aspects/
│
└── workflows/                   # Work containers
    └── {workflow-id}/           # e.g., 001-initialize-documents
        ├── spec.md              # Phase: Background and purpose
        ├── stage-*.md           # Stage: Requirements
        ├── task-*.md            # Task: Methods
        └── progress.md          # Progress: Tracking
```

---

## Component Relationships

```
┌─────────────────────────────────────────────────────────────┐
│ Constitutions                                               │
│ "What principles to follow"                                 │
│                                                             │
│ base.md ─────────────────────┐                              │
│                              │                              │
│ workers/specifier.md ────────┼──► Specifier Worker          │
│ workers/implementer.md ──────┼──► Implementer Worker        │
│ workers/reviewer.md ─────────┼──► Reviewer Worker           │
└──────────────────────────────┼──────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────┐
│ Workflows                    │                              │
│ "What work to do"            ▼                              │
│                                                             │
│ Workflow ──► Phase (spec.md)     "Why"                      │
│          ├── Stage (stage-*.md)  "What"                     │
│          ├── Task (task-*.md)    "How"                      │
│          └── Progress (progress.md) "How much"              │
│                                                             │
│ Dependency: Phase → Stage → Task → Progress                 │
└─────────────────────────────────────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────┐
│ Gates                        │                              │
│ "What to validate"           ▼                              │
│                                                             │
│ Code Gates (validates: code):                               │
│   Specification Gate ──► After Phase/Stage/Task defined     │
│   Implementation Gate ──► After Tasks executed              │
│                                                             │
│   Gate ──► Aspect ──► Criteria                              │
│            (1:N)      (1:N)                                 │
│                                                             │
│ Document Gates (validates: document):                       │
│   Documentation Gate ──► Schema Validation ──► front-matters/ │
│                                                             │
│ Each Aspect = One Reviewer Worker                           │
└─────────────────────────────────────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────┐
│ Schemas                      │                              │
│ "What format to follow"      ▼                              │
│                                                             │
│ front-matters/ ──► Defines valid FrontMatter for each type  │
│   ├── phase.schema.md                                       │
│   ├── stage.schema.md                                       │
│   ├── task.schema.md                                        │
│   └── progress.schema.md                                    │
│                                                             │
│ Used by Documentation Gate for validation                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Workflow Structure

A Workflow answers four key questions:

| Concept | Question | File | Type |
|---------|----------|------|------|
| **Phase** | "Why" - Background and purpose | `spec.md` | Definition |
| **Stage** | "What" - Requirements to fulfill | `stage-*.md` | Definition |
| **Task** | "How" - Methods to achieve | `task-*.md` | Definition |
| **Progress** | "How much" - Completion tracking | `progress.md` | Task |

### Dependency Flow

```
Phase (spec.md)           dependencies: []
       ↓
Stage (stage-*.md)        dependencies: [spec.md]
       ↓
Task (task-*.md)          dependencies: [stage-XX-*.md]
       ↓
Progress (progress.md)    dependencies: [task-*.md, ...]
```

---

## Initialization

When initializing a project:

1. Copy `templates/blueprint/` to `target-project/blueprint/`
2. Customize Constitutions for project-specific principles
3. Define Gates and Criteria for project-specific quality standards
4. Workflows are created dynamically as work progresses

---

## Subdirectories

| Directory | Purpose | See |
|-----------|---------|-----|
| `front-matters/` | FrontMatter Schema definitions | `front-matters/README.md` |
| `constitutions/` | Principle definitions | `constitutions/README.md` |
| `gates/` | Validation checkpoints | `gates/README.md` |
| `workflows/` | Work containers | `workflows/README.md` |

---

## Related

- `../claude-agents/` for Worker behavior definitions
- `../../initializers/` for setup scripts
- `../../commands/` for slash commands
