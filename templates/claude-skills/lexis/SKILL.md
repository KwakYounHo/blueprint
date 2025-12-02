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
bash .claude/skills/lexis/lexis.sh --list

# Show base + worker constitution
bash .claude/skills/lexis/lexis.sh <worker>

# Show base constitution only
bash .claude/skills/lexis/lexis.sh --base
```

## Examples

```bash
bash .claude/skills/lexis/lexis.sh --list
bash .claude/skills/lexis/lexis.sh orchestrator
bash .claude/skills/lexis/lexis.sh specifier
bash .claude/skills/lexis/lexis.sh implementer
bash .claude/skills/lexis/lexis.sh --base
```
