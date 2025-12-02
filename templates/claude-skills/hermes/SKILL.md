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
bash .claude/skills/hermes/hermes.sh --list

# Show specific handoff form
bash .claude/skills/hermes/hermes.sh <from> <to>
```

## Examples

```bash
bash .claude/skills/hermes/hermes.sh --list
bash .claude/skills/hermes/hermes.sh orchestrator specifier
bash .claude/skills/hermes/hermes.sh specifier orchestrator
bash .claude/skills/hermes/hermes.sh orchestrator implementer
```
