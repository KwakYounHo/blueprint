---
name: gate
description: View gate definitions and their validation aspects. Use when you need to see gate criteria, list available gates, or check what aspects a gate validates (specification, implementation, documentation).
allowed-tools: Bash, Read
---

# Gate Viewer

## Script Usage

```bash
# List all gates
.claude/skills/gate/scripts/gate.sh --list

# Show gate definition
.claude/skills/gate/scripts/gate.sh <gate>

# List aspects for a gate
.claude/skills/gate/scripts/gate.sh <gate> --aspects

# Show specific aspect
.claude/skills/gate/scripts/gate.sh <gate> <aspect>
```

### Examples

```bash
gate.sh --list
gate.sh specification
gate.sh specification --aspects
gate.sh specification workflow-structure
```

## Extensibility

Project maintainers can add custom gates by creating `blueprint/gates/{gate-name}/` with `gate.md` and `aspects/` subdirectory. The script automatically recognizes new gates.
