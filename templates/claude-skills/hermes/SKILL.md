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
hermes --list

# Show specific handoff form
hermes <from> <to>
```

## Examples

```bash
hermes --list
hermes orchestrator specifier
hermes specifier orchestrator
hermes orchestrator implementer
```
