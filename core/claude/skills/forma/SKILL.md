---
name: forma
description: View and list document templates. Use when creating new documents (specs, discussions, gates, etc.) to get the correct format and structure.
allowed-tools: Bash, Read
---

# Forma

Template viewer for document creation.

## Commands

```bash
# List available templates
.claude/skills/forma/forma.sh list

# Show template content
.claude/skills/forma/forma.sh show <name>
```

## Examples

```bash
.claude/skills/forma/forma.sh list
.claude/skills/forma/forma.sh show spec-lib
.claude/skills/forma/forma.sh show spec-feat
.claude/skills/forma/forma.sh show memory
.claude/skills/forma/forma.sh show discussion
.claude/skills/forma/forma.sh show gate
.claude/skills/forma/forma.sh show aspect
.claude/skills/forma/forma.sh show constitution
```

## Why Forma?

Templates provide the correct structure for creating new documents. Use `forma show <type>` to get the template, then copy and customize for your needs.

## Template vs Schema

| Tool | Purpose |
|------|---------|
| `frontis schema <type>` | View field definitions and constraints |
| `forma show <type>` | Get copy-paste template for new document |
