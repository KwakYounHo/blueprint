---
name: blueprint
description: Provides unified CLI access for Blueprint framework - gate validation, document templates, FrontMatter schemas, agent handoffs, constitutions, and agent registry.
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
| `polis` | Agent registry | `.claude/agents/` |
| `project` | Project alias management | `~/.claude/blueprint/projects/` |

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
blueprint lexis --list                # List all agents
blueprint lexis <agent>               # Show agent constitution
blueprint lexis --base                # Show base constitution only

# Polis - Agents
blueprint polis --list                # List all agents with descriptions
blueprint polis <agent>               # Show agent instruction

# Project - Project Aliases
blueprint project init <alias> [--notes "text"]  # Initialize new project
blueprint project list                            # List all projects
blueprint project show <alias>                    # Show project details
blueprint project remove <alias>                  # Remove project
blueprint project link <alias>                    # Link current path to project
blueprint project unlink <alias> [path]           # Unlink path from project
blueprint project rename <new-alias>              # Rename project alias
blueprint project manage                          # Scan and manage projects
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

# Check agent constitution
blueprint lexis reviewer

# List available agents
blueprint polis --list

# Manage project aliases
blueprint project list
blueprint project init myproject --notes "My project"
```

## When to Use

Use this skill when working with Blueprint Framework:

- **Creating documents**: Use `forma` for templates, `frontis` for schemas
- **Validating work**: Use `aegis` for gate criteria and aspects
- **Agent communication**: Use `hermes` for handoff formats
- **Understanding roles**: Use `lexis` for constitutions, `polis` for agent info
- **Managing projects**: Use `project` for cross-machine project aliases

## Template Usage Guidelines

| Action | Command | Context Impact |
|--------|---------|----------------|
| Create file from template | `forma copy` | **None** (recommended) |
| View template structure | `forma show` | ~500 tokens |
| Validate FrontMatter | `frontis schema` | Necessary |

**IMPORTANT**: Use `forma copy` to create files. Avoid `forma show` unless you need to understand template structure without creating a file.

## Project Usage Guidelines

### Before `blueprint project init`

Use **AskUserQuestion** tool to ask the user:
1. **Project alias** - Suggest current directory name as default
2. **Notes** (optional) - Brief description for identification

### Workflows

**New Project:**
```bash
# 1. Ask user for alias and notes via AskUserQuestion
# 2. Run init command
blueprint project init <alias> --notes "<notes>"
```

**Existing Project on New Machine:**
```bash
# 1. Check if project exists
blueprint project list

# 2a. If project exists, link current path
blueprint project link <alias>

# 2b. If not, create new project
blueprint project init <alias>
```

### Registry Location

- Registry: `~/.claude/blueprint/projects/.projects`
- Project data: `~/.claude/blueprint/projects/<alias>/`
- Base files: `~/.claude/blueprint/base/`

### Session Guidelines

**path-based Project Notifications:**
- **Once per session per project**: Only mention rename suggestion once
- **Track mentioned projects**: Don't repeat for the same project in same session
- **Be concise**: Brief suggestion, not a lecture

Example (first mention):
```
Project 'Users-duyo-Desktop-test' uses path-based identification.
Consider: `blueprint project rename <alias>`
```

**Using `blueprint project manage`:**
1. Run `blueprint project manage` to scan
2. Use **AskUserQuestion** to gather alias preferences
3. Execute appropriate commands (`rename`, `init`, or cleanup)
