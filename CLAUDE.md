## **CRITICAL RULES**
- When you're uncertain or unable to make an independent judgment, ask the user.
- Familiarize yourself with the [past ADRs](docs/adr/) to understand architectural decisions.

## Conversation Rules
- **IMPORTANT** You must converse with the user in Korean, as it's their native language.
- Always write documents and code (including comments) in English, but keep the user-facing language in Korean.

## **Project Identity (MUST READ)**

## Context Window Management Strategy
- Actively leverage Subagents when summarization or deep analysis is needed.
- Treat the Main Session's context window as a precious resource.
- Agents are defined in `.claude/agents/` - use them for delegated tasks.

### What This Project Is
- This is a **framework template repository**, NOT a working framework instance.
- We are **creating** a framework, NOT **using** one.
- The goal: Provide minimal constraints and guidelines for target projects to customize.

### Installation (User-Level)

```bash
# One-time global install (shared across all projects)
./install-global.sh    # → ~/.claude/{agents,skills,commands}/ + ~/.claude/blueprint/base/
```

### What Gets Copied

| Item | Target | Purpose |
|------|--------|---------|
| `core/claude/*` | `~/.claude/` | Claude Code config (agents, skills, commands) |
| `core/constitutions/*` | `~/.claude/blueprint/base/` | Principle definitions |
| `core/forms/*` | `~/.claude/blueprint/base/` | Handoff formats |
| `core/front-matters/*` | `~/.claude/blueprint/base/` | FrontMatter schemas |
| `core/gates/*` | `~/.claude/blueprint/base/` | Validation checkpoints |
| `core/templates/*` | `~/.claude/blueprint/base/` | Document templates |
| `docs/adr/*` | ❌ Not copied | Framework design decisions |

### Core Directory Structure

```
core/
├── claude/              # Claude Code configuration
│   ├── agents/          # Subagent definitions (reviewer, etc.)
│   ├── commands/        # Slash commands (/plan, /save, /load, /checkpoint)
│   ├── hooks/           # Session hooks (session-init.sh)
│   └── skills/          # Skills (blueprint with submodules)
│       └── blueprint/   # aegis, forma, frontis, hermes, lexis, polis, project
├── constitutions/       # Principle definitions
│   ├── base.md          # Global constitution template
│   └── agents/          # Agent-specific constitutions
├── forms/               # Handoff format definitions
├── front-matters/       # FrontMatter schema definitions (*.schema.md)
├── gates/               # Validation checkpoints
│   ├── documentation/   # Document format validation
│   └── session/         # Session continuity validation
│       └── aspects/     # Individual validation criteria
└── templates/           # Document templates (*.template.md)
```

### Template Rules
- Use **placeholders** (`{{project-name}}`, `{{date}}`) for values that vary per project.
- Provide **minimal required structure** - let project maintainers customize.
- **Token efficiency** is critical: base.md ~500 tokens, agent constitutions ~300-500 tokens each.

## Key Concepts

### Constitution vs Instruction (ADR-002)

| | Constitution | Instruction |
|---|-------------|-------------|
| **Essence** | Law to obey | Responsibility to fulfill |
| **Location** | `~/.claude/blueprint/{base,projects}/constitutions/` | `~/.claude/agents/` |
| **Content** | Principles, Boundaries | Role, Workflow, Handoff format |

### Core vs Dogfooding

| | Framework Core | Dogfooding |
|---|----------------|------------|
| **Location** | `core/*` | Query via `/blueprint` skill |
| **Purpose** | Template for other projects | This project's own config |
| **Content** | Placeholders (`{{...}}`) | Actual values filled in |

**Query dogfooding info** (load `/blueprint` skill first, then execute in Bash):
- Current project info: `project current` (submodule: project, subcommand: current)
- Project constitution: `lexis --base` (submodule: lexis, flag: --base)
- FrontMatter validation: `frontis show <file>` (submodule: frontis, subcommand: show)

When modifying files, **clearly distinguish** whether it's a framework core change or a dogfooding change. If uncertain → **ASK the user**.

