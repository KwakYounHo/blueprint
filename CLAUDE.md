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
- **Current Phase**: Structure and README.md completed
- **Next**: Schema-first development (see ADR-001)
- **Approach**: Create schemas first as contracts, then create documents that conform to them
- Reference `docs/adr/001-schema-first-development.md` for implementation order.

## Project Structure
```
agent-docs/
├── docs/
│   └── adr/                 # Architecture Decision Records
├── templates/
│   ├── claude-agents/       # Worker definitions for .claude/agents/
│   └── blueprint/           # Framework core templates
│       ├── front-matters/   # FrontMatter definitions
│       ├── constitutions/   # Principles
│       ├── gates/           # Validation checkpoints (incl. documentation/)
│       ├── workflows/       # Phase/Stage definitions
│       └── features/        # Feature/Artifact templates
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
| Feature | Container for Artifacts, synced with Branch |

## Commands
- `/specify` - Start specification for a new feature
- `/implement` - Begin implementation phase
- `/review` - Run gate validation
