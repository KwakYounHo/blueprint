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
.claude/skills/frontis/frontis.sh search <field> <value> [path]

# Show frontmatter of file(s)
.claude/skills/frontis/frontis.sh show <file> [file...]

# View schema definition
.claude/skills/frontis/frontis.sh schema <type>

# List available schemas
.claude/skills/frontis/frontis.sh schema --list
```

- `path`: optional, defaults to current directory (`.`)

## Examples

```bash
.claude/skills/frontis/frontis.sh search type task
.claude/skills/frontis/frontis.sh search status active blueprint/
.claude/skills/frontis/frontis.sh show blueprint/tasks/task-001.md
.claude/skills/frontis/frontis.sh show file1.md file2.md file3.md
.claude/skills/frontis/frontis.sh schema aspect
.claude/skills/frontis/frontis.sh schema --list
```

## Why Frontis?

Schema files contain FrontMatter examples in code blocks. Simple grep matches these examples, causing false positives. Frontis extracts only the actual FrontMatter block before searching.
