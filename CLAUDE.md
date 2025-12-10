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

### What Gets Copied vs What Stays
| Item | Copied to Target? | Purpose |
|------|-------------------|---------|
| `core/claude/*` | ✅ Yes → `.claude/` | Claude Code config (agents, commands, skills) |
| `core/constitutions/*` | ✅ Yes → `blueprint/constitutions/` | Principle definitions |
| `core/forms/*` | ✅ Yes → `blueprint/forms/` | Handoff formats |
| `core/front-matters/*` | ✅ Yes → `blueprint/front-matters/` | FrontMatter schemas |
| `core/gates/*` | ✅ Yes → `blueprint/gates/` | Validation checkpoints |
| `core/templates/*` | ✅ Yes → `blueprint/templates/` | Document templates |
| `core/specs/*` | ✅ Yes → `blueprint/specs/` | Specification templates |
| `core/initializers/*` | ✅ Yes | Setup scripts |
| `README.md` files | ❌ No | Written at 0.1.0 release |
| `blueprint/*` | ❌ No | Dogfooding - this project's own config |
| `docs/adr/*` | ❌ No | Framework design decisions |

### Template Rules
- Use **placeholders** (`{{project-name}}`, `{{date}}`) for values that vary per project.
- Provide **minimal required structure** - let project maintainers customize.
- **Token efficiency** is critical: base.md ~500 tokens, worker constitutions ~300-500 tokens each.

## Key Concepts

### Constitution vs Instruction (ADR-002)

| | Constitution | Instruction |
|---|-------------|-------------|
| **Essence** | Law to obey | Responsibility to fulfill |
| **Location** | `blueprint/constitutions/` | `.claude/agents/` |
| **Content** | Principles, Boundaries | Role, Workflow, Handoff format |

### Symlink Structure (Development Only)

This repository uses symlinks to avoid duplicate maintenance:

| Path | Type | Edit Target |
|------|------|-------------|
| `.claude/agents/` | symlink | `core/claude/agents/` |
| `.claude/skills/` | symlink | `core/claude/skills/` |
| `.claude/commands/` | symlink | `core/claude/commands/` |
| `blueprint/forms/` | symlink | `core/forms/` |
| `blueprint/front-matters/` | symlink | `core/front-matters/` |
| `blueprint/gates/` | symlink | `core/gates/` |
| `blueprint/templates/` | symlink | `core/templates/` |
| `blueprint/constitutions/workers/` | symlink | `core/constitutions/workers/` |
| `blueprint/constitutions/base.md` | **real file** | Edit directly |
| `blueprint/discussions/` | **real dir** | Project data |
| `blueprint/specs/` | **real dir** | Project data |

**Rule**: If editing a symlinked path, modify the `core/` source instead.
