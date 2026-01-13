---
name: blueprint
description: Provides unified CLI access for Blueprint framework - gate validation, document templates, FrontMatter schemas, worker handoffs, constitutions, and worker registry.
allowed-tools: Bash, Read
---

# Blueprint

Unified CLI for the Blueprint orchestration framework.

## Quick Reference

| Submodule | Purpose | Data Source |
|-----------|---------|-------------|
| `aegis` | Gate validation & aspects | `blueprint/gates/` |
| `forma` | Document templates | `blueprint/templates/` |
| `frontis` | FrontMatter search & schemas | `blueprint/front-matters/` |
| `hermes` | Handoff forms | `blueprint/forms/` |
| `lexis` | Constitution viewer | `blueprint/constitutions/` |
| `polis` | Worker registry | `.claude/agents/` |

## Commands

**Execution:** `{project-root}/.claude/skills/blueprint/blueprint.sh <submodule> [args]`

```bash
# General
blueprint --help
blueprint --list

# Aegis - Gates
blueprint aegis --list                # List all gates
blueprint aegis <gate>                # Show gate definition
blueprint aegis <gate> --aspects      # List aspects for gate
blueprint aegis <gate> <aspect>       # Show specific aspect

# Forma - Templates
blueprint forma list                  # List available templates
blueprint forma show <name>           # Show template content
blueprint forma copy <name> <dir>     # Copy template to directory (RECOMMENDED)

# Frontis - FrontMatter
blueprint frontis search <field> <value> [path]  # Search by FrontMatter
blueprint frontis show <file> [file...]          # Show frontmatter
blueprint frontis schema <type>                  # View schema
blueprint frontis schema --list                  # List schemas

# Hermes - Handoff Forms
blueprint hermes --list               # List all Handoff forms
blueprint hermes <form>               # Show Handoff form (after-*, request:*, response:*)

# Lexis - Constitutions
blueprint lexis --list                # List all workers
blueprint lexis <worker>              # Show base + worker constitution
blueprint lexis --base                # Show base constitution only

# Polis - Workers
blueprint polis --list                # List all workers with descriptions
blueprint polis <worker>              # Show worker instruction
```

## Examples

```bash
# Find all spec documents
blueprint frontis search type spec

# View spec-lib template
blueprint forma show spec-lib

# Check gate aspects
blueprint aegis documentation --aspects

# View Handoff form
blueprint hermes after-load:standard

# Check worker constitution
blueprint lexis specifier

# List available workers
blueprint polis --list
```

## When to Use

Use this skill when working with Blueprint Framework:

- **Creating documents**: Use `forma` for templates, `frontis` for schemas
- **Validating work**: Use `aegis` for gate criteria and aspects
- **Worker communication**: Use `hermes` for handoff formats
- **Understanding roles**: Use `lexis` for constitutions, `polis` for worker info

## Template Usage Guidelines

| Action | Command | Context Impact |
|--------|---------|----------------|
| Create file from template | `forma copy` | **None** (recommended) |
| View template structure | `forma show` | ~500 tokens |
| Validate FrontMatter | `frontis schema` | Necessary |

**IMPORTANT**: Use `forma copy` to create files. Avoid `forma show` unless you need to understand template structure without creating a file.
