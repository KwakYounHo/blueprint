# Initializers

> Scripts that set up the framework in target projects.

---

## Purpose

Initializers are **automation scripts** that:

1. Create directory structure in target project
2. Copy templates to appropriate locations
3. Set up initial configurations
4. Optionally create initial Git branch

---

## Background

### Why Initializers?

Manual setup is:
- Error-prone
- Time-consuming
- Inconsistent

Initializers ensure:
- Correct structure every time
- Consistent starting point
- Quick project setup

### What Gets Initialized

| Source | Destination |
|--------|-------------|
| `templates/claude-agents/` | `.claude/agents/` |
| `templates/blueprint/` | `blueprint/` |

---

## Directory Structure

```
initializers/
├── README.md                    # This file
└── init.sh                      # Main initialization script
```

---

## Planned Scripts

### init.sh

Main initialization script that:

1. **Creates structure**:
   ```
   .claude/agents/
   blueprint/
   ├── front-matters/
   ├── constitutions/
   │   └── workers/
   ├── gates/
   │   ├── specification/
   │   │   └── aspects/
   │   ├── implementation/
   │   │   └── aspects/
   │   └── documentation/
   │       └── aspects/
   └── workflows/
   ```

2. **Copies templates** (optional, with flag):
   - Worker definitions to `.claude/agents/`
   - Constitution templates to `blueprint/constitutions/`
   - Gate templates to `blueprint/gates/`

3. **Initializes Git** (optional):
   - Creates `.gitignore` entries if needed

---

## Usage

### Basic Initialization

```bash
# From agent-docs directory
./initializers/init.sh /path/to/target-project
```

### With Template Copying

```bash
./initializers/init.sh /path/to/target-project --with-templates
```

### Options

| Flag | Description |
|------|-------------|
| `--with-templates` | Copy all templates |
| `--workers-only` | Copy only Worker templates to .claude/agents/ |
| `--no-git` | Skip Git-related setup |
| `--dry-run` | Show what would be done without doing it |

---

## Script Structure

```bash
#!/bin/bash

# init.sh - Initialize framework in target project

TARGET_DIR=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates"

# Parse flags
WITH_TEMPLATES=false
WORKERS_ONLY=false
# ...

# Create directory structure
create_structure() {
    mkdir -p "$TARGET_DIR/.claude/agents"
    mkdir -p "$TARGET_DIR/blueprint/front-matters"
    mkdir -p "$TARGET_DIR/blueprint/constitutions/workers"
    mkdir -p "$TARGET_DIR/blueprint/gates/specification/aspects"
    mkdir -p "$TARGET_DIR/blueprint/gates/implementation/aspects"
    mkdir -p "$TARGET_DIR/blueprint/gates/documentation/aspects"
    mkdir -p "$TARGET_DIR/blueprint/workflows"
}

# Copy templates
copy_templates() {
    if [ "$WITH_TEMPLATES" = true ]; then
        cp -r "$TEMPLATE_DIR/claude-agents/"* "$TARGET_DIR/.claude/agents/"
        cp -r "$TEMPLATE_DIR/blueprint/"* "$TARGET_DIR/blueprint/"
    fi
}

# Main
create_structure
copy_templates
echo "Initialization complete: $TARGET_DIR"
```

---

## Post-Initialization

After running initializer:

1. **Customize Constitutions**:
   - Edit `blueprint/constitutions/base.md` for project-specific rules
   - Add tech stack, dependencies, coding standards

2. **Define Gates**:
   - Add Aspects and Criteria to `blueprint/gates/`
   - Customize validation rules for your project

3. **Configure Workers**:
   - Review `.claude/agents/*.md`
   - Adjust descriptions and tools as needed

---

## Integration with Commands

After initialization, use slash commands:

```
/specify - Start specifying a new workflow
/implement - Begin implementation
/review - Run gate validation
```

See `commands/README.md` for details.

---

## Best Practices

### Always Dry-Run First

```bash
./initializers/init.sh /path/to/project --dry-run
```

### Check for Existing Structure

Script should:
- Detect existing `blueprint/` directory
- Ask for confirmation before overwriting
- Provide `--force` flag for intentional overwrites

### Version the Initializer

When updating templates:
- Consider existing projects
- Provide migration scripts if structure changes
- Document breaking changes

---

## Related

- `../templates/` for what gets copied
- `../commands/` for post-initialization usage
- `../README.md` for overall documentation
