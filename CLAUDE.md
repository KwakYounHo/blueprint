## **CRITICAL RULES**
- When you're uncertain or unable to make an independent judgment, ask the user.

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
| `core/workflows/*` | ✅ Yes → `blueprint/workflows/` | Workflow templates |
| `core/initializers/*` | ✅ Yes | Setup scripts |
| `README.md` files (all) | ❌ No | Developer documentation only |
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

### Core vs Dogfooding

| | Framework Core | Dogfooding |
|---|----------------|------------|
| **Location** | `core/*` | `blueprint/*`, `.claude/*` |
| **Purpose** | Template for other projects | This project's own config |
| **Placeholders** | `{{project-name}}`, `{{date}}` | Actual values filled in |

- When modifying files, **clearly distinguish** whether it's a framework core change or a dogfooding change.
- If uncertain which to modify → **ASK the user before proceeding**.
