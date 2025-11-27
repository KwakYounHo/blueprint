## **CRITICAL RULES**
- When you're uncertain or unable to make an independent judgment, ask the user.

## **Project Identity (MUST READ)**

### What This Project Is
- This is a **framework template repository**, NOT a working framework instance.
- We are **creating** a framework, NOT **using** one.
- The goal: Provide minimal constraints and guidelines for target projects to customize.

### What Gets Copied vs What Stays
| Item | Copied to Target? | Purpose |
|------|-------------------|---------|
| `templates/blueprint/*` | ✅ Yes → `blueprint/` | Framework core (schemas, constitutions, gates) |
| `templates/claude-agents/*` | ✅ Yes → `.claude/agents/` | Worker definitions |
| `commands/*` | ✅ Yes → `.claude/commands/` | Slash commands |
| `README.md` files (all) | ❌ No | Developer documentation only |
| `initializers/*` | ❌ No | Used to copy templates |
| `docs/adr/*` | ❌ No | Framework design decisions |

### README.md Files
- All README.md files are **for framework developers**, not end users.
- They explain the structure and design decisions.
- They are NOT copied to target projects.
- Template files' `related` field should only reference files that will be copied together.

### Template Files
- Use **placeholders** (e.g., `{{project-name}}`, `{{date}}`) for values that vary per project.
- Provide **minimal required structure** - let project maintainers customize.
- Include **guidelines as comments** within templates when needed.

## Context Window Management Strategy
- Actively leverage Subagents when summarization or deep analysis is needed.
- Treat the Main Session's context window as a precious resource.
- If tasks can be parallelized, consider using Subagents to boost efficiency.
- Workers are defined in `.claude/agents/` - use them for delegated tasks.

## Conversation Rules
- **IMPORTANT** You must converse with the user in Korean, as it's their native language.
- Writing documentation and code in English, but keep user-facing messages in Korean.
- When translating Korean to English, express it naturally as a native speaker would, rather than translating literally.

## Development Status
- **Current Phase**: Schema definition in progress
- **Completed**: base.schema.md, constitution.schema.md, gate.schema.md, aspect.schema.md
- **In Progress**: phase.schema.md, stage.schema.md, task.schema.md, progress.schema.md
- Reference `docs/adr/001-schema-first-development.md` for implementation order.

### Schema Creation Guide (for next session)

#### 1. Existing Schema Pattern Reference
Read these files to understand the established schema structure:
- `templates/blueprint/front-matters/base.schema.md` - Common fields all schemas inherit
- `templates/blueprint/front-matters/aspect.schema.md` - Best example of extension pattern (includes parent reference via `gate` field)

**Schema file structure**:
```markdown
1. FrontMatter (type: schema, dependencies: [base.schema.md])
2. # Schema: {Type} FrontMatter
3. ## Inherits (list base.schema.md fields)
4. ## Additional Required Fields (table)
5. ## Field Definitions (detailed per field)
6. ## Constraints (validation rules table)
7. ## Field Guidelines (tags, dependencies recommendations)
8. ## Usage Examples (YAML examples)
9. ## Context (relationship diagram - optional)
```

#### 2. Workflow Structure Design Decisions
Reference: `templates/blueprint/workflows/README.md`

| Concept | Question | File | Count | Type |
|---------|----------|------|-------|------|
| **Phase** | "Why" - Background/purpose | `spec.md` | 1 per workflow | Definition |
| **Stage** | "What" - Requirements | `stage-*.md` | N per workflow | Definition |
| **Task** | "How" - Methods | `task-*.md` | N per Stage | Definition |
| **Progress** | "How much" - Tracking | `progress.md` | 1 per workflow | Task |

#### 3. Dependency Flow
```
Phase (spec.md)           → dependencies: []
       ↓
Stage (stage-*.md)        → dependencies: [spec.md]
       ↓
Task (task-*.md)          → dependencies: [stage-XX-*.md]
       ↓
Progress (progress.md)    → dependencies: [task-*.md, ...]
```

#### 4. WBS-Style Naming Convention
Reference: `templates/blueprint/workflows/README.md` (## Naming Conventions)

| Type | Pattern | Example |
|------|---------|---------|
| Workflow ID | `{NNN}-{short-description}` | `001-initialize-documents` |
| Stage | `stage-{SS}-{name}.md` | `stage-01-requirement-analysis.md` |
| Task | `task-{SS}-{TT}-{name}.md` | `task-01-02-validate-scope.md` |

- `SS`: Stage number (01-99)
- `TT`: Task number within Stage (01-99)

#### 5. Status Values by Document Category
Reference: `templates/blueprint/front-matters/README.md` (## Status Values by Document Type)

| Category | Types | Valid Status Values |
|----------|-------|---------------------|
| Definition | `phase`, `stage`, `task` | `draft`, `active`, `deprecated`, `archived` |
| Task | `progress` | `pending`, `in-progress`, `completed`, `failed` |

#### 6. Required Fields per Schema

| Schema | Additional Required Fields |
|--------|---------------------------|
| `phase.schema.md` | `workflow-id` (string) |
| `stage.schema.md` | `name` (string), `order` (number) |
| `task.schema.md` | `name` (string), `stage` (string - parent ref), `order` (number) |
| `progress.schema.md` | None (inherits base only) |

#### 7. Stage-Task Relationship (Parent Reference Pattern)
Reference: `templates/blueprint/front-matters/aspect.schema.md` (uses `gate` field for parent reference)

Task references its parent Stage via the `stage` field:
```yaml
# In task-01-02-validate-scope.md
stage: "requirement-analysis"  # matches Stage's `name` field
```

#### 8. After Schema Creation
Update `templates/blueprint/front-matters/base.schema.md`:
- Add new types to the `type` enum: `phase`, `stage`, `task`, `progress`
- Update status categories in Field Definitions section

## Blueprint-First Principle

README files in this project serve as **blueprints** for framework elements:

```
README (Blueprint) → Schema (Contract) → Instance (Actual Document)
```

| Layer | Role | Example |
|-------|------|---------|
| README | Design specification for developers | `gates/README.md` |
| Schema | Formal contract (FrontMatter definition) | `gate.schema.md` |
| Instance | Actual framework document | `gates/specification/gate.md` |

**Workflow**:
1. Design/update README (blueprint) first
2. Generate/update Schema based on README
3. Create instances that conform to Schema

This ensures READMEs remain the source of truth for framework design.

## Project Structure
```
agent-docs/
├── docs/
│   └── adr/                 # Architecture Decision Records
├── templates/
│   ├── claude-agents/       # Worker definitions for .claude/agents/
│   └── blueprint/           # Framework core templates
│       ├── front-matters/   # FrontMatter Schema definitions
│       ├── constitutions/   # Principles
│       ├── gates/           # Validation checkpoints (incl. documentation/)
│       └── workflows/       # Work containers (Phase, Stage, Task, Progress)
├── initializers/            # Setup scripts
├── commands/                # Slash commands
└── .conversation/           # Session summaries
```

## Key Terminology
| Term | Definition |
|------|------------|
| Agent | Top-level: LLM + Tools + Memory |
| Orchestrator | Coordinates Workers, manages state |
| Worker | Executes delegated tasks (Specifier, Implementer, Reviewer) |
| Constitution | Principles to follow |
| Gate | Validation checkpoint between Phases |
| Aspect | Expertise area within Gate (1:1 with Reviewer) |
| Criteria | Minimum requirements to pass |
| Workflow | Container for Phase, Stage, Task, Progress; synced with Branch |
| Phase | "Why" - Background and purpose (spec.md) |
| Stage | "What" - Requirements to fulfill (stage-*.md) |
| Task | "How" - Methods to achieve (task-*.md) |
| Progress | "How much" - Completion tracking (progress.md) |

## Commands
- `/specify` - Start specification for a new workflow
- `/implement` - Begin implementation phase
- `/review` - Run gate validation
