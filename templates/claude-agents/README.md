# Claude Agents

> Worker definitions for Claude Code integration. These files are copied to `.claude/agents/` in target projects.

---

## Purpose

This directory contains **Worker definition templates** that integrate with Claude Code's subagent system.

Workers defined here:
1. Are automatically recognized by Claude Code
2. Can be invoked explicitly or automatically delegated
3. Have isolated context windows
4. Follow the Claude Code subagent file format

---

## Background

### Why `.claude/agents/`?

Claude Code scans `.claude/agents/` for custom subagent definitions:

| Location | Scope | Priority |
|----------|-------|----------|
| `.claude/agents/` | Project-level | High (takes precedence) |
| `~/.claude/agents/` | User-level | Low |

By placing Workers here, they integrate directly with Claude Code's delegation system.

### Automatic Delegation

Claude reads the `description` field and automatically selects appropriate subagents based on context. Including phrases like "Use PROACTIVELY" encourages automatic usage.

---

## File Format

Workers use **Markdown with YAML front matter**:

```markdown
---
name: worker-name
description: When and why to use this worker. Use PROACTIVELY when...
tools: Read, Grep, Glob, Write, Edit, Bash
model: sonnet
---

System prompt content...

## Your Role
...

## Constitution Reference
You MUST read and follow:
- blueprint/constitutions/base.md
- blueprint/constitutions/workers/{worker-name}.md

## Output Format
...
```

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Lowercase with hyphens (e.g., `specifier`) |
| `description` | string | Natural language description for auto-delegation |

### Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `tools` | string | (inherit all) | Comma-separated tool list |
| `model` | string | `sonnet` | `sonnet`, `opus`, `haiku`, or `inherit` |

### Available Tools

- `Read` - Read files
- `Write` - Write files
- `Edit` - Edit files
- `Grep` - Search file contents
- `Glob` - Find files by pattern
- `Bash` - Execute shell commands

---

## Planned Workers

| Worker | File | Role |
|--------|------|------|
| **Orchestrator** | `orchestrator.template.md` | Coordinates Workers, manages state |
| **Specifier** | `specifier.template.md` | Creates specifications from requirements |
| **Implementer** | `implementer.template.md` | Implements code based on tasks |
| **Reviewer** | `reviewer.template.md` | Validates artifacts against criteria |

---

## Worker-Constitution Relationship

Each Worker references its Constitution:

```
.claude/agents/specifier.md          (Behavior: how to act)
        │
        └──► blueprint/constitutions/workers/specifier.md  (Principles: what to follow)
```

The Worker file defines **behavior** (system prompt).
The Constitution file defines **principles** (rules to follow).

---

## Handoff Format

### Worker → Orchestrator

Workers return structured summaries to Orchestrator:

```yaml
handoff:
  status: success | fail | partial
  artifact: path/to/created/file
  summary: "1-2 sentence description"
  decisions_made: []
  needs_confirmation: []
```

### Orchestrator → Reviewer

Orchestrator sends documents for gate validation:

```yaml
handoff:
  action: review
  document: path/to/document
  required-gates:           # Gate `name` field values
    - specification         # Code Gate (validates: code)
    - documentation         # Document Gate (validates: document)
  context:
    workflow-id: "001-workflow"
    phase: specification
```

See `blueprint/gates/README.md` for complete Handoff structure.

---

## Usage

### Explicit Invocation

```
> Use the specifier to analyze these requirements
```

### Automatic Delegation

Claude automatically selects based on `description`:

```
> I want to add a new feature for user authentication
(Claude automatically invokes specifier based on description match)
```

---

## Related

- `../blueprint/constitutions/workers/` for Worker-specific principles
- `../blueprint/constitutions/base.md` for common principles
- `../../README.md` for Worker type definitions
