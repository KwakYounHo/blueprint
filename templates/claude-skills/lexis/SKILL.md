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
.claude/skills/lexis/lexis.sh --list

# Show base + worker constitution
.claude/skills/lexis/lexis.sh <worker>

# Show base constitution only
.claude/skills/lexis/lexis.sh --base
```

## Examples

```bash
.claude/skills/lexis/lexis.sh --list
.claude/skills/lexis/lexis.sh orchestrator
.claude/skills/lexis/lexis.sh specifier
.claude/skills/lexis/lexis.sh implementer
.claude/skills/lexis/lexis.sh --base
```
