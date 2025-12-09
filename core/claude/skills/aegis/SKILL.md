---
name: aegis
description: View gate definitions and their validation aspects. Use when you need to see gate criteria, list available gates, or check what aspects a gate validates.
allowed-tools: Bash, Read
---

# Aegis

Gate viewer for validation checkpoints.

## Commands

```bash
# List all gates
.claude/skills/aegis/aegis.sh --list

# Show gate definition
.claude/skills/aegis/aegis.sh <gate>

# List aspects for a gate
.claude/skills/aegis/aegis.sh <gate> --aspects

# Show specific aspect
.claude/skills/aegis/aegis.sh <gate> <aspect>
```

## Examples

```bash
.claude/skills/aegis/aegis.sh --list
.claude/skills/aegis/aegis.sh documentation
.claude/skills/aegis/aegis.sh documentation --aspects
.claude/skills/aegis/aegis.sh documentation schema-validation
```

## Extensibility

Project maintainers can add custom gates by creating `blueprint/gates/{gate-name}/` with `gate.md` and `aspects/` subdirectory. Aegis automatically recognizes new gates.
