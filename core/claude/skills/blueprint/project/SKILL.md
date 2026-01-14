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
blueprint project rename <new-alias>              # Rename project alias
blueprint project manage                          # Scan and manage projects
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

Projects are stored in: `~/.claude/blueprint/projects/.projects`

Data directories are stored in: `~/.claude/blueprint/projects/<alias>/`

Base files are stored in: `~/.claude/blueprint/base/`

## Session Guidelines

### path-based Project Notifications

When detecting path-based projects (via `blueprint project manage` or automatic detection):

1. **Once per session per project**: Only mention rename suggestion once
2. **Track mentioned projects**: Don't repeat for the same project in the same Claude Code session
3. **Be concise**: Brief suggestion, not a lecture

Example (first mention):
```
Project 'Users-duyo-Desktop-test' uses path-based identification.
Consider: `blueprint project rename <alias>`
```

Example (subsequent): Skip or acknowledge briefly if user asks.

### Using `blueprint project manage`

When user runs `manage` or when you detect unregistered/path-based projects:

1. Run `blueprint project manage` to scan
2. Review output and use **AskUserQuestion** to gather:
   - Alias preferences for each project
   - Whether to clean up invalid projects
3. Execute appropriate commands (`rename`, `init`, or cleanup)
