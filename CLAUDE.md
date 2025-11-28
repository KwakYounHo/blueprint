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
| `templates/claude-agents/*` | ✅ Yes → `.claude/agents/` | Worker definitions (Instructions) |
| `commands/*` | ✅ Yes → `.claude/commands/` | Slash commands |
| `README.md` files (all) | ❌ No | Developer documentation only |
| `docs/adr/*` | ❌ No | Framework design decisions |

### Template Rules
- Use **placeholders** (`{{project-name}}`, `{{date}}`) for values that vary per project.
- Provide **minimal required structure** - let project maintainers customize.
- **Token efficiency** is critical: base.md ~500 tokens, worker constitutions ~300-500 tokens each.

## Context Window Management Strategy
- Actively leverage Subagents when summarization or deep analysis is needed.
- Treat the Main Session's context window as a precious resource.
- Workers are defined in `.claude/agents/` - use them for delegated tasks.

## Conversation Rules
- **IMPORTANT** You must converse with the user in Korean, as it's their native language.
- Writing documentation and code in English, but keep user-facing messages in Korean.

## Development Status
- **Current Phase**: Template creation (Phase 2 of ADR-001)
- **Completed**: All schemas, `constitutions/base.md`
- **Next**: `constitutions/workers/*.md` (orchestrator, specifier, implementer, reviewer)
- Reference `docs/adr/001-schema-first-development.md` for implementation order.

### Key ADRs for Current Phase
| ADR | Topic | Reference |
|-----|-------|-----------|
| ADR-001 | Schema-First Development | Implementation phases |
| ADR-002 | Constitution/Instruction Separation | Constitution=Law, Instruction=Responsibility |
| ADR-003 | Template Annotation System | `[FIXED]`, `[INFER]`, `[DECIDE]`, `[ADAPT]` |

### Phase 2: Constitution Templates

**Completed**:
- `constitutions/base.md` (v0.2.0) - ~500 tokens, lean structure

**Files to Create**:
```
constitutions/workers/
├── orchestrator.md
├── specifier.md
├── implementer.md
└── reviewer.md
```

**Worker Constitution Structure** (from workers/README.md):
```markdown
# Constitution: {Worker Name}

## Worker-Specific Principles
## Quality Standards
## Boundaries
```

> Role, Responsibilities, Handoff → belong in **Instruction** (`.claude/agents/*.md`), not Constitution.

### Annotation System (ADR-003)

| Annotation | Purpose | LLM Action |
|------------|---------|------------|
| `[FIXED]` | Framework core rules | Do NOT modify without user confirmation |
| `[INFER]` | Codebase-derivable content | Analyze and fill |
| `[DECIDE]` | User judgment needed | AskUserQuestion |
| `[ADAPT]` | Conditional content | Evaluate and include/exclude |

### Constitution vs Instruction (ADR-002)

| | Constitution | Instruction |
|---|-------------|-------------|
| **Essence** | Law to obey | Responsibility to fulfill |
| **Location** | `blueprint/constitutions/` | `.claude/agents/` |
| **Content** | Principles, Boundaries | Role, Workflow, Handoff format |

```
Worker Runtime
├── Constitution (laws) → blueprint/constitutions/base.md + workers/*.md
└── Instruction (duties) → .claude/agents/*.md
```

### Design Decision: Lean Constitution

Tech Stack, Code Standards, Quality Standards are **NOT** in base.md.
- These are validated by **Gate/Aspects** at review time
- Only Reviewer loads Gate/Aspects; other Workers stay lightweight
- base.md contains only: Project Identity, Document Standards, Handoff Protocol, Boundaries, Governance

## Blueprint-First Principle

```
README (Blueprint) → Schema (Contract) → Instance (Actual Document)
```

1. Design/update README (blueprint) first
2. Generate/update Schema based on README
3. Create instances that conform to Schema

## Project Structure
```
agent-docs/
├── docs/adr/                 # Architecture Decision Records
├── templates/
│   ├── claude-agents/        # Worker definitions (Instructions)
│   └── blueprint/
│       ├── front-matters/    # FrontMatter Schema definitions
│       ├── constitutions/    # Principles (base.md ✅, workers/*.md 🔄)
│       ├── gates/            # Validation checkpoints
│       └── workflows/        # Work containers
├── initializers/             # Setup scripts
└── commands/                 # Slash commands
```

## Key Terminology
| Term | Definition |
|------|------------|
| Constitution | Laws/Principles Workers must obey |
| Instruction | Responsibilities Workers must fulfill (`.claude/agents/`) |
| Gate | Validation checkpoint (Code Standards, Quality → here, not Constitution) |
| Aspect | Specific criteria within Gate |
| `[FIXED]` | Framework core annotation - requires user confirmation to modify |

## Commands
- `/specify` - Start specification for a new workflow
- `/implement` - Begin implementation phase
- `/review` - Run gate validation
