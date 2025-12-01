---
name: lexis
description: View constitution for Workers. Shows base constitution combined with worker-specific rules. Use when you need to check principles, boundaries, or rules for a specific Worker role.
allowed-tools: Bash, Read
---

# Lexis

Constitution viewer for Worker roles.

## Commands

```bash
# List all workers
lexis --list

# Show base + worker constitution
lexis <worker>

# Show base constitution only
lexis --base
```

## Examples

```bash
lexis --list
lexis orchestrator
lexis specifier
lexis implementer
lexis --base
```
