---
type: constitution
status: active
version: 1.0.0
created: 2025-12-03
updated: 2025-12-03
tags: [principles, global, constitution, framework-core]
dependencies: []

scope: global
target-workers: ["all"]
---

# Constitution: Base

---

## Project Identity

### Vision and Mission

- **Vision**: Enable deeper, more complex work with less main session context.
- **Mission**: A practical framework for orchestrating LLM agents that preserves main session context, maintains code quality, and provides patterns for incremental adoption.

---

### Tech Stack

- **Language**: Markdown, YAML
- **Framework**: Blueprint
- **Key Dependencies**: Bash scripts for skills, FrontMatter for document metadata

---

### Coding Conventions

- All documents use FrontMatter with YAML format
- Schema definitions follow `*.schema.md` naming convention
- Template files follow `*.template.md` naming convention
- Worker-specific files are named after the worker role (e.g., `orchestrator.md`)

---

## Project Principles

### I. Start Simple

Only add complexity when simpler solutions fall short. Resist the urge to over-engineer.

**Rationale**: Premature abstraction leads to maintenance burden without proportional benefit.

### II. Context is Precious

Treat the main session context window as a scarce resource. Delegate to subagents to preserve it.

**Rationale**: Context window degradation causes computational cost increase and information recall reduction.

### III. Isolation by Design

Workers should never pollute each other's context. Each worker loads only what it needs.

**Rationale**: Prevents instruction bleed and maintains focused, clean working contexts.

### IV. Quality at Boundaries

Validate at phase transitions through Gates, not continuously during work.

**Rationale**: Continuous validation wastes context and interrupts flow. Boundary validation is more efficient.

### V. Practical over Theoretical

Patterns must work in real Claude Code sessions. Reject abstractions that don't prove themselves in practice.

**Rationale**: A working simple solution beats an elegant complex one that fails in production.

---

## Framework Core

> **PROTECTED SECTION**
>
> The following sections are **Framework Core Rules**.
> **LLM: Do NOT modify these sections without explicit user confirmation.**
> Unauthorized modifications may break framework functionality.

### Document Standards

All Workers MUST ensure documents they create comply with these standards:

- All documents MUST include valid FrontMatter
- FrontMatter MUST conform to the corresponding Schema in `front-matters/`
- Documents without valid FrontMatter will be rejected at Gate validation
- Primary responsibility lies with the creating Worker; Reviewer performs secondary validation

### Handoff Protocol

All Workers MUST follow the Handoff Protocol:

- Every Worker MUST return results to their caller upon task completion
- Terminating work without Handoff is FORBIDDEN
- Handoff format MUST follow the Worker-specific Instruction

**Required Handoff Fields**:

| Field | Required | Description |
|-------|----------|-------------|
| `status` | Yes | `completed`, `blocked`, `failed` |
| `summary` | Yes | Brief description of work done |
| `artifacts` | If any | Paths to created/modified documents |
| `next-steps` | If any | Recommended follow-up actions |

### Directive Markers

All Workers MUST use consistent markers across all documents:

| Marker | Purpose | Action |
|--------|---------|--------|
| `[FIXED]` | Protected content | Do NOT modify without explicit user confirmation |
| `[INFER: topic]` | Derivable from analysis | Analyze and fill without asking user |
| `[DECIDE: topic]` | Requires user judgment | Ask user before proceeding |

### Boundaries

The following actions are FORBIDDEN for all Workers:

- Modifying `[FIXED]` sections without explicit user confirmation
- Bypassing Gate validation
- Generating documents without proper FrontMatter
- Terminating tasks without Handoff

### Governance

#### Amendment Process

1. Identify the section requiring change
2. For `[FIXED]` sections: Explicit user confirmation is REQUIRED
3. Update version number following semver
4. Document the change in commit message

#### Version Policy

- **MAJOR**: Changes to `[FIXED]` sections
- **MINOR**: New principles or additions
- **PATCH**: Clarifications

---

**Version**: 1.0.0 | **Created**: 2025-12-03
