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
---

System prompt content...

## Constitution Reference
You MUST read and follow:
- blueprint/constitutions/base.md
- blueprint/constitutions/workers/{worker-name}.md

## Your Role
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

## Workers

| Worker | File | Role |
|--------|------|------|
| **Orchestrator** | `orchestrator.md` | Coordinates Workers, manages state, communicates with user |
| **Lorekeeper** | `lorekeeper.md` | Records all discussions verbatim, validates intent alignment |
| **Specifier** | `specifier.md` | Create & Modify specification documents |
| **Implementer** | `implementer.md` | Create & Modify code based on tasks |
| **Reviewer** | `reviewer.md` | Validate quality & compliance per Aspect |

### Special Workers

Special Workers can be used as **Main Session Persona** or **Subagent**:

| Worker | Main Session Role | Subagent Role |
|--------|-------------------|---------------|
| **Orchestrator** | Coordinates workflow with user | Invoked by another agent for coordination |
| **Lorekeeper** | Records discussions in real-time | Validates artifacts against discussion records |

**Lorekeeper's unique role**:
- **Beginning of Workflow**: Records EVERYTHING - every word, tangent, decision, concern
- **End of Workflow**: Validates that artifacts match the original intent discussed
- Uses markers `[D-]`, `[A-]`, `[C-]`, `[Q-]` inline while maintaining chronological flow
- Does NOT summarize - that's Specifier's job

### Reviewer (Per-Aspect)

Each Reviewer instance validates **one Aspect** only. Multiple Reviewers run in parallel for different Aspects.

```
Gate (e.g., specification)
├── Aspect: completeness ──► Reviewer Instance A
├── Aspect: feasibility ───► Reviewer Instance B (parallel)
└── ...
```

---

## Core Principle: 1 Depth + User Confirm

**All Workers follow this principle:**

1. **1 Depth Rule**: One user command = One work unit
   - Worker creates only one level of output per invocation
   - Chained work without user instruction is FORBIDDEN

2. **User Confirm Required**: User confirmation is REQUIRED after every Worker task
   - Orchestrator MUST report result to user after Worker completion
   - Proceeding to next task without user confirmation is FORBIDDEN

```
User command → Orchestrator → Worker → Result → Orchestrator → User (confirm required)
                                                                  ↓
                                                User next command → ...
```

---

## `[DECIDE]` Marker Handling

Workers use `[DECIDE]` markers to indicate items requiring user judgment:

- **Specifier**: Marks ambiguous requirements that need clarification
- **Implementer**: Marks unclear specifications that cannot be implemented without user decision
- **Orchestrator**: Responsible for detecting `[DECIDE]` markers and requesting user confirmation before proceeding

---

## Worker-Constitution Relationship

Each Worker references its Constitution:

```
.claude/agents/specifier.md          (Instruction: how to act)
        │
        └──► blueprint/constitutions/workers/specifier.md  (Constitution: what to follow)
```

The Worker file defines **behavior** (Instruction).
The Constitution file defines **principles** (Constitution).

---

## Handoff Format

### Worker → Orchestrator

Workers return structured summaries to Orchestrator:

```yaml
handoff:
  status: completed | blocked
  summary: "Brief description of work done"
  artifacts: [path/to/created/files]
  decide-markers: [path/to/file#marker-location]  # If any
  next-steps: ["Recommended follow-up actions"]
```

| Field | Required | Description |
|-------|----------|-------------|
| `status` | Yes | `completed` or `blocked` |
| `summary` | Yes | Brief description of work done |
| `artifacts` | If any | Paths to created/modified files |
| `decide-markers` | If any | Locations of `[DECIDE]` markers requiring user decision |
| `next-steps` | If any | Recommended follow-up actions |

### Orchestrator → Reviewer

Orchestrator sends **one Aspect** per Reviewer invocation:

```yaml
handoff:
  action: review
  document: path/to/document
  gate: specification
  aspect: completeness
  context:
    workflow-id: "001-workflow"
    phase: specification
```

| Field | Required | Description |
|-------|----------|-------------|
| `action` | Yes | Always `review` |
| `document` | Yes | Path to document to validate |
| `gate` | Yes | Gate name (specification, implementation, documentation) |
| `aspect` | Yes | Single Aspect to validate |
| `context` | No | Additional context |

### Reviewer → Orchestrator

```yaml
handoff:
  status: pass | fail
  gate: specification
  aspect: completeness
  document: path/to/document
  criteria:
    required: [...]
    recommended: [...]
  summary: "Validation result summary"
```

See `blueprint/gates/README.md` for Gate and Aspect definitions.

---

## Gate Validation Recommendation

Orchestrator recommends Gate validation whenever any Artifact is created or modified.

| Worker | Recommended Gates |
|--------|-------------------|
| Specifier | `gates/specification`, `gates/documentation` |
| Implementer | `gates/implementation` |

**Note**: Gate validation is recommended, not forced. Respect user's choice.

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

- `../blueprint/constitutions/workers/` for Worker-specific principles (Constitution)
- `../blueprint/constitutions/base.md` for common principles (Constitution)
- [ADR-002](../../docs/adr/002-constitution-instruction-separation.md) for Constitution/Instruction separation
- `../../README.md` for Worker type definitions
