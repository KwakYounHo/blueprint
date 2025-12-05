---
name: polis
description: View available Workers and their roles. Use when you need to see which Workers exist, their descriptions, or delegate work to the right Worker. (project)
allowed-tools: Bash, Read
---

# Polis

Worker registry viewer for discovering available Workers.

## Commands

```bash
# List all workers with descriptions
.claude/skills/polis/polis.sh --list

# Show specific worker instruction
.claude/skills/polis/polis.sh <worker>
```

## Examples

```bash
.claude/skills/polis/polis.sh --list
.claude/skills/polis/polis.sh orchestrator
.claude/skills/polis/polis.sh specifier
.claude/skills/polis/polis.sh implementer
```

## Extensibility

Project maintainers can add custom Workers by creating `.claude/agents/{worker-name}.md` with FrontMatter containing `name` and `description` fields. Polis automatically recognizes new Workers.
