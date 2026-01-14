# Project Management

Manage project aliases for cross-machine portability.

## Commands

```bash
blueprint project init <alias> [--notes "text"]   # Initialize new project
blueprint project list                            # List all projects
blueprint project show <alias>                    # Show project details
blueprint project remove <alias>                  # Remove project
blueprint project link <alias>                    # Link current path to project
blueprint project unlink <alias> [path]           # Unlink path from project
```

## Usage Instructions

### Before `blueprint project init`

Use **AskUserQuestion** tool to ask the user:

1. **Project alias** - Suggest current directory name as default
2. **Notes** (optional) - Brief description for identification

Example prompt:
```
Questions:
1. What alias should this project use? (default: current-dir-name)
2. Add a note for this project? (optional, helps identify the project later)
```

### New Project Workflow

```bash
# 1. Ask user for alias and notes
# 2. Run init command
blueprint project init <alias> --notes "<notes>"
```

### Existing Project on New Machine

```bash
# 1. Check if project exists
blueprint project list

# 2a. If project exists, link current path
blueprint project link <alias>

# 2b. If not, create new project
blueprint project init <alias>
```

## Registry Location

Projects are stored in: `~/.claude/blueprint/.blueprint`

Data directories are stored in: `~/.claude/blueprint/<alias>/`
