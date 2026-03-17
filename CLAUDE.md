## **CRITICAL RULES**
- When you're uncertain or unable to make an independent judgment, ask the user.
- Familiarize yourself with the [past ADRs](#architecture-decision-records) to understand architectural decisions.

## Conversation Rules
- **IMPORTANT** You must converse with the user in Korean, as it's their native language.
- Always write documents and code (including comments) in English, but keep the user-facing language in Korean.

## **Project Identity (MUST READ)**

## Context Window Management Strategy
- Actively leverage Subagents when summarization or deep analysis is needed.
- Treat the Main Session's context window as a precious resource.

### What This Project Is
- This is a **framework template repository**, NOT a working framework instance.
- We are **creating** a framework, NOT **using** one.
- The goal: Provide minimal constraints and guidelines for target projects to customize.

### Installation (User-Level)

```bash
# One-time global install (per Code Assistant)
./providers/claude/install.sh    # → ~/.claude/{agents,skills}/ + ~/.blueprint/base/
```

### What Gets Copied

| Item | Target | Purpose |
|------|--------|---------|
| `core/constitutions/*` | `~/.blueprint/base/` | Principle definitions |
| `core/forms/*` | `~/.blueprint/base/` | Handoff formats |
| `core/front-matters/*` | `~/.blueprint/base/` | FrontMatter schemas |
| `core/gates/*` | `~/.blueprint/base/` | Validation checkpoints |
| `core/templates/*` | `~/.blueprint/base/` | Document templates |
| `instructions/agents/*` | `~/.claude/agents/` (via provider) | Agent definitions |
| `instructions/skills/*` | `~/.claude/skills/` (via provider) | Workflow skills |
| `docs/adr/*` | ❌ Not copied | Framework design decisions |

### Repository Structure

```
├── cli/                 # Blueprint CLI (Rust) — manages ~/.blueprint/ only
│   └── src/
│       ├── commands/    # aegis, forma, frontis, hermes, lexis, plan, polis, project
│       └── common/      # paths, frontmatter, registry
├── core/                # Layer 0: Blueprint system content
│   ├── constitutions/   # Principle definitions
│   │   ├── base.md      # Global constitution template
│   │   └── agents/      # Agent-specific constitutions
│   ├── forms/           # Handoff format definitions
│   ├── front-matters/   # FrontMatter schema definitions (*.schema.md)
│   ├── gates/           # Validation checkpoints
│   │   ├── documentation/
│   │   └── session/
│   └── templates/       # Document templates (*.template.md)
├── instructions/        # Layer 2-3: CLI consumers (NOT part of CLI)
│   ├── agents/          # Agent definitions + specs (reviewer, phase-analyzer, etc.)
│   └── skills/          # Workflow skills + specs (load, save, bplan, etc.)
├── providers/           # Platform integration (CLI outside)
│   ├── claude/          # Claude Code provider (install.sh)
│   └── codex/           # Codex provider
└── docs/                # ADRs, documentation
```

### Layer Architecture

```
Layer 3: Skills (load, save, bplan, ...)      — Orchestrate agents + manage documents
Layer 2: Agents (reviewer, phase-analyzer)     — Consume documents via CLI
Layer 1: Plan Documents (PLAN.md, BRIEF.md)    — Follow Blueprint schemas
Layer 0: Core System (constitutions, gates...) — Blueprint itself
```

CLI manages Layer 0-1. Layer 2-3 are CLI **consumers**, installed by providers.

### Template Rules
- Use **placeholders** (`{{project-name}}`, `{{date}}`) for values that vary per project.
- Provide **minimal required structure** - let project maintainers customize.
- **Token efficiency** is critical: base.md ~500 tokens, agent constitutions ~300-500 tokens each.

## Key Concepts

### Constitution vs Instruction (ADR-002)

| | Constitution | Instruction |
|---|-------------|-------------|
| **Essence** | Law to obey | Responsibility to fulfill |
| **Location** | `~/.blueprint/{base,projects}/constitutions/` | `instructions/` (repo) → provider installs |
| **Content** | Principles, Boundaries | Role, Workflow, Handoff format |

### Core vs Dogfooding

| | Framework Core | Dogfooding |
|---|----------------|------------|
| **Location** | `core/*`, `instructions/*` | Query via `blueprint` CLI |
| **Purpose** | Template for other projects | This project's own config |
| **Content** | Placeholders (`{{...}}`) | Actual values filled in |

**Query dogfooding info** (execute `blueprint` CLI directly):
- Current project info: `blueprint project current`
- Project constitution: `blueprint lexis --base`
- FrontMatter validation: `blueprint frontis show <file>`

When modifying files, **clearly distinguish** whether it's a framework core change or a dogfooding change. If uncertain → **ASK the user**.

### Architecture Decision Records

| ADR | Title |
|-----|-------|
| [001](docs/adr/001-schema-first-development.md) | Schema-First Development |
| [002](docs/adr/002-constitution-instruction-separation.md) | Constitution/Instruction Separation |
| [003](docs/adr/003-template-annotation-system.md) | Template Annotation System |
| [004](docs/adr/004-marker-convention-system.md) | Marker Convention System |
| [005](docs/adr/005-sync-versioning-strategy.md) | Sync Versioning Strategy |
| [006](docs/adr/006-orchestrator-pattern.md) | Orchestrator Pattern |
| [007](docs/adr/007-reviewer-gate-spawn-and-validation-separation.md) | Reviewer Gate Spawn & Validation Separation |
