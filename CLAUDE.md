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

Blueprint uses a **two-step user-level installation**:

```bash
# Step 1: One-time global install (shared across all projects)
./install-global.sh    # → ~/.claude/{agents,skills,commands}/

# Step 2: Per-project initialization
cd /path/to/your/project
./init-project.sh      # → ~/.claude/blueprint/{project-path}/
```

### What Gets Copied vs What Stays

| Item | install-global.sh | init-project.sh | Purpose |
|------|-------------------|-----------------|---------|
| `core/claude/*` | → `~/.claude/` | - | Claude Code config (shared) |
| `core/constitutions/*` | - | → `~/.claude/blueprint/{project}/` | Principle definitions |
| `core/forms/*` | - | → `~/.claude/blueprint/{project}/` | Handoff formats |
| `core/front-matters/*` | - | → `~/.claude/blueprint/{project}/` | FrontMatter schemas |
| `core/gates/*` | - | → `~/.claude/blueprint/{project}/` | Validation checkpoints |
| `core/templates/*` | - | → `~/.claude/blueprint/{project}/` | Document templates |
| `README.md` files | ❌ No | ❌ No | Written at 0.1.0 release |
| `blueprint/*` | ❌ No | ❌ No | Dogfooding - this project's own config |
| `docs/adr/*` | ❌ No | ❌ No | Framework design decisions |

**Note**: `{project-path}` is derived from the absolute path where you run init-project.sh (e.g., `/Users/me/projects/myapp` → `Users-me-projects-myapp`).

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
