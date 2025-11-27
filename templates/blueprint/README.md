# Blueprint

> Core framework structure containing Constitutions, Gates, Workflows, and Features.

---

## Purpose

This directory is the **heart of the framework**. It contains:

1. **Constitutions**: Principles that Workers must follow
2. **Gates**: Validation checkpoints with Criteria
3. **Workflows**: Phase and Stage definitions
4. **Features**: Containers for Artifacts (spec, plan, tasks, reviews)
5. **Schemas**: Document format definitions for validation

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
├── front-matters/               # FrontMatter definitions
│   ├── common.schema.md         # Shared fields across all types
│   ├── constitution.schema.md
│   ├── gate.schema.md
│   ├── aspect.schema.md
│   ├── feature.schema.md
│   └── artifact.schema.md       # spec, plan, task, review
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
│   ├── specification/           # Specification Phase gate
│   │   ├── gate.md
│   │   └── aspects/
│   ├── implementation/          # Implementation Phase gate
│   │   ├── gate.md
│   │   └── aspects/
│   └── documentation/           # Documentation gate (parallel)
│       ├── gate.md
│       └── aspects/
│
├── workflows/                   # Phase and Stage definitions
│   ├── phases.md                # Phase order and transitions
│   └── stages/                  # Stage definitions per Phase
│
└── features/                    # Feature containers
    └── {feature-id}/            # One directory per Feature
        ├── feature.md
        ├── spec.md
        ├── plan.md
        ├── tasks/
        └── reviews/
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
│ "When things happen"         │                              │
│                              ▼                              │
│ Phase: Specification ──► Gate: Specification                │
│ Phase: Implementation ──► Gate: Implementation              │
└─────────────────────────────────────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────┐
│ Gates                        │                              │
│ "What to validate"           ▼                              │
│                                                             │
│ Phase Gates (sequential):                                   │
│   Gate ──► Aspect ──► Criteria                              │
│            (1:N)      (1:N)                                 │
│                                                             │
│ Document Gates (parallel):                                  │
│   Documentation Gate ──► Schema Validation ──► front-matters/ │
│                                                             │
│ Each Aspect = One Reviewer Worker                           │
└─────────────────────────────────────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────┐
│ Features                     │                              │
│ "What is produced"           ▼                              │
│                                                             │
│ Feature ──► Artifacts                                       │
│             ├── spec.md                                     │
│             ├── plan.md                                     │
│             ├── tasks/                                      │
│             └── reviews/                                    │
└─────────────────────────────────────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────┐
│ Schemas                      │                              │
│ "What format to follow"      ▼                              │
│                                                             │
│ front-matters/ ──► Defines valid front matter for each type │
│               Used by Documentation Gate for validation     │
└─────────────────────────────────────────────────────────────┘
```

---

## Initialization

When initializing a project:

1. Copy `templates/blueprint/` to `target-project/blueprint/`
2. Customize Constitutions for project-specific principles
3. Define Gates and Criteria for project-specific quality standards
4. Features are created dynamically as work progresses

---

## Subdirectories

| Directory | Purpose | See |
|-----------|---------|-----|
| `front-matters/` | FrontMatter definitions | `front-matters/README.md` |
| `constitutions/` | Principle definitions | `constitutions/README.md` |
| `gates/` | Validation checkpoints | `gates/README.md` |
| `workflows/` | Phase/Stage definitions | `workflows/README.md` |
| `features/` | Artifact containers | `features/README.md` |

---

## Related

- `../claude-agents/` for Worker behavior definitions
- `../../initializers/` for setup scripts
- `../../commands/` for slash commands
