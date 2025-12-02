---
name: aegis
description: View gate definitions and their validation aspects. Use when you need to see gate criteria, list available gates, or check what aspects a gate validates (specification, implementation, documentation).
allowed-tools: Bash, Read
---

# Aegis

Gate viewer for validation checkpoints.

## Commands

```bash
# List all gates
bash .claude/skills/aegis/aegis.sh --list

# Show gate definition
bash .claude/skills/aegis/aegis.sh <gate>

# List aspects for a gate
bash .claude/skills/aegis/aegis.sh <gate> --aspects

# Show specific aspect
bash .claude/skills/aegis/aegis.sh <gate> <aspect>
```

## Examples

```bash
bash .claude/skills/aegis/aegis.sh --list
bash .claude/skills/aegis/aegis.sh specification
bash .claude/skills/aegis/aegis.sh specification --aspects
bash .claude/skills/aegis/aegis.sh specification workflow-structure
```

## Extensibility

Project maintainers can add custom gates by creating `blueprint/gates/{gate-name}/` with `gate.md` and `aspects/` subdirectory. Aegis automatically recognizes new gates.
