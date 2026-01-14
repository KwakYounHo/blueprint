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
- Workers are defined in `.claude/agents/` - use them for delegated tasks.

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

### Template Rules
- Use **placeholders** (`{{project-name}}`, `{{date}}`) for values that vary per project.
- Provide **minimal required structure** - let project maintainers customize.
- **Token efficiency** is critical: base.md ~500 tokens, worker constitutions ~300-500 tokens each.

## Key Concepts

### Constitution vs Instruction (ADR-002)

| | Constitution | Instruction |
|---|-------------|-------------|
| **Essence** | Law to obey | Responsibility to fulfill |
| **Location** | `~/.claude/blueprint/{base,projects}/constitutions/` | `~/.claude/agents/` |
| **Content** | Principles, Boundaries | Role, Workflow, Handoff format |

