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
- **Current Phase**: Template creation (Phase 2 of ADR-001)
- **Completed Schemas**: base, constitution, gate, aspect, phase, stage, task, progress
- **In Progress**: Constitution templates (base.md, workers/*.md)
- Reference `docs/adr/001-schema-first-development.md` for implementation order.

### Template Creation Guide (for next session)

#### 1. ADR-001 Implementation Phases

| Phase | Status | Content |
|-------|--------|---------|
| Phase 1: Schema Definition | ✅ Complete | `front-matters/*.schema.md` |
| Phase 2: Constitution | 🔄 In Progress | `constitutions/base.md`, `constitutions/workers/*.md` |
| Phase 3: Workers | ⏳ Pending | `templates/claude-agents/*.md` → `.claude/agents/` |
| Phase 4: Gates | ⏳ Pending | `gates/**/gate.md`, `gates/**/aspects/*.md` |
| Phase 5: Tooling | ⏳ Pending | `initializers/`, `commands/` |

#### 2. Phase 2: Constitution Templates

**Reference Files**:
- Schema: `templates/blueprint/front-matters/constitution.schema.md`
- Blueprint: `templates/blueprint/constitutions/README.md`
- Worker Blueprint: `templates/blueprint/constitutions/workers/README.md`

**Files to Create**:
```
constitutions/
├── base.md                    # scope: global, target-workers: ["all"]
└── workers/
    ├── orchestrator.md        # scope: worker-specific, target-workers: ["orchestrator"]
    ├── specifier.md           # scope: worker-specific, target-workers: ["specifier"]
    ├── implementer.md         # scope: worker-specific, target-workers: ["implementer"]
    └── reviewer.md            # scope: worker-specific, target-workers: ["reviewer"]
```

**Constitution FrontMatter** (from constitution.schema.md):
```yaml
---
type: constitution
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [principles, ...]
dependencies: []  # or ["../base.md"] for worker-specific

scope: global | worker-specific
target-workers: ["all"] | ["specifier", ...]
---
```

**Body Structure** (from README):
```markdown
# Constitution: {Name}

## Core Principles
## Quality Standards
## Boundaries
## Patterns
## Exceptions
```

**Token Budget**: ~500-800 tokens per file (from research on context efficiency)

#### 3. Template Rules (IMPORTANT)

| Rule | Description |
|------|-------------|
| Placeholders | Use `{{project-name}}`, `{{date}}` for variable values |
| Minimal Structure | Provide only required structure, let projects customize |
| Body in README | Body structure is defined in README, not schema |
| Token Efficiency | Keep Constitution files short (~500-800 tokens) |
| Status | Templates should be `status: active` (ready to use after copy) |

#### 4. Worker-Constitution-Gate Relationship

```
.claude/agents/specifier.md          (HOW - behavior/system prompt)
        │
        └──► blueprint/constitutions/
             ├── base.md              (WHAT - global principles)
             └── workers/specifier.md (WHAT - specific principles)

Reviewer Worker
        │
        └──► blueprint/gates/
             └── specification/
                 ├── gate.md
                 └── aspects/completeness.md (Criteria to check)
```

#### 5. Recommended Creation Order

1. **Constitution base.md** - Global principles (foundation for all)
2. **Constitution workers/*.md** - Worker-specific principles
3. **Worker definitions** - Reference constitutions
4. **Gate definitions** - Define validation checkpoints
5. **Aspect definitions** - Define specific criteria

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
