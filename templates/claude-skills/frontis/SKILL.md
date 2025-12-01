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
frontis search <field> <value> [path]

# View schema definition
frontis schema <type>

# List available schemas
frontis schema --list
```

- `path`: optional, defaults to current directory (`.`)

## Examples

```bash
frontis search type task
frontis search status active blueprint/
frontis schema aspect
frontis schema --list
```

## Why Frontis?

Schema files contain FrontMatter examples in code blocks. Simple grep matches these examples, causing false positives. Frontis extracts only the actual FrontMatter block before searching.
