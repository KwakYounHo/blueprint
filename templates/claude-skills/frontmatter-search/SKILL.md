---
name: frontmatter-search
description: Search blueprint documents by YAML FrontMatter metadata fields (type, status, version, tags). Use when you need to find documents matching specific metadata criteria.
allowed-tools: Bash, Read
---

# FrontMatter Search

## Script Usage

```bash
.claude/skills/frontmatter-search/scripts/search.sh <field> <value> [path]
```

- `path`: optional, defaults to current directory (`.`)

### Examples

```bash
search.sh type task blueprint/
search.sh type aspect blueprint/
search.sh status active blueprint/
search.sh type constitution blueprint/constitutions/
```

## Why Use the Script?

Schema files contain FrontMatter examples in code blocks. Simple grep patterns match these examples, causing false positives.

The script extracts **only the actual FrontMatter block** (between first two `---` lines) before searching.

## Fields Reference

See `blueprint/front-matters/*.schema.md` for field definitions.

Common fields: `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`
