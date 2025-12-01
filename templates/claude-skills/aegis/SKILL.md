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
aegis --list

# Show gate definition
aegis <gate>

# List aspects for a gate
aegis <gate> --aspects

# Show specific aspect
aegis <gate> <aspect>
```

## Examples

```bash
aegis --list
aegis specification
aegis specification --aspects
aegis specification workflow-structure
```

## Extensibility

Project maintainers can add custom gates by creating `blueprint/gates/{gate-name}/` with `gate.md` and `aspects/` subdirectory. Aegis automatically recognizes new gates.
