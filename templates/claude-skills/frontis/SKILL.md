---
name: frontis
description: Search documents by FrontMatter metadata and view schema definitions. Use when you need to find documents by type/status/tags or check required fields for document types.
allowed-tools: Bash, Read
---

# Frontis

FrontMatter search and schema viewer.

## Commands

```bash
# Search documents by FrontMatter field
bash .claude/skills/frontis/frontis.sh search <field> <value> [path]

# Show frontmatter of file(s)
bash .claude/skills/frontis/frontis.sh show <file> [file...]

# View schema definition
bash .claude/skills/frontis/frontis.sh schema <type>

# List available schemas
bash .claude/skills/frontis/frontis.sh schema --list
```

- `path`: optional, defaults to current directory (`.`)

## Examples

```bash
bash .claude/skills/frontis/frontis.sh search type task
bash .claude/skills/frontis/frontis.sh search status active blueprint/
bash .claude/skills/frontis/frontis.sh show blueprint/tasks/task-001.md
bash .claude/skills/frontis/frontis.sh show file1.md file2.md file3.md
bash .claude/skills/frontis/frontis.sh schema aspect
bash .claude/skills/frontis/frontis.sh schema --list
```

## Why Frontis?

Schema files contain FrontMatter examples in code blocks. Simple grep matches these examples, causing false positives. Frontis extracts only the actual FrontMatter block before searching.
