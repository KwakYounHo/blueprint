## **CRITICAL RULES**
- When you're uncertain or unable to make an independent judgment, ask the user.

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
│       ├── _schemas/        # Document format definitions
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
