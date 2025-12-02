---
name: hermes
description: View handoff forms between Workers. Use when you need to see the correct format for passing work between Orchestrator, Specifier, Implementer, Reviewer, or Lorekeeper.
allowed-tools: Bash, Read
---

# Hermes

Handoff form viewer for Worker communication.

## Commands

```bash
# List all handoff forms
.claude/skills/hermes/hermes.sh --list

# Show specific handoff form
.claude/skills/hermes/hermes.sh <from> <to>
```

## Examples

```bash
.claude/skills/hermes/hermes.sh --list
.claude/skills/hermes/hermes.sh orchestrator specifier
.claude/skills/hermes/hermes.sh specifier orchestrator
.claude/skills/hermes/hermes.sh orchestrator implementer
```
