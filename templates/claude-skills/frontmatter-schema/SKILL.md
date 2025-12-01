---
name: frontmatter-schema
description: View FrontMatter schema definitions and list all available schemas. Use when you need to know required/optional fields for document types (task, aspect, gate, phase, etc.) or see what schemas exist.
allowed-tools: Bash, Read
---

# FrontMatter Schema Viewer

## Script Usage

```bash
# View schema for a specific type
.claude/skills/frontmatter-schema/scripts/schema.sh <type>

# List all available schemas
.claude/skills/frontmatter-schema/scripts/schema.sh --list
```

### Examples

```bash
schema.sh task
schema.sh aspect
schema.sh constitution
schema.sh --list
```

## Extensibility

Project maintainers can add custom types by creating `blueprint/front-matters/{type}.schema.md`. The script will automatically recognize new schemas.
