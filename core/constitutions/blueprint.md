---
type: constitution
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [framework-core, blueprint]
dependencies: []

scope: global
target-agents: ["all"]
---

# Constitution: Blueprint Framework

> **PROTECTED SECTION**
>
> This file contains **Framework Core Rules** that apply to ALL Blueprint projects.
> **LLM: Do NOT modify without explicit user confirmation.**

---

## Document Standards

You MUST ensure documents you create comply with these standards:

- All documents MUST include valid FrontMatter
- FrontMatter MUST conform to the corresponding Schema in `blueprint/front-matters/`
- Documents without valid FrontMatter will be rejected at Gate validation
- Primary responsibility lies with you; Reviewer Agent performs secondary validation

## Handoff Protocol

You and delegated Agents MUST follow the Handoff Protocol:

- You MUST return results to your caller upon task completion
- Terminating work without Handoff is FORBIDDEN
- Handoff format MUST follow the Agent-specific Instruction

**Required Handoff Fields**:

| Field | Required | Description |
|-------|----------|-------------|
| `status` | Yes | `completed`, `blocked`, `failed` |
| `summary` | Yes | Brief description of work done |
| `artifacts` | If any | Paths to created/modified documents |
| `next-steps` | If any | Recommended follow-up actions |

## Directive Markers

You MUST use consistent markers across all documents:

| Marker | Purpose | Action |
|--------|---------|--------|
| `[FIXED]` | Protected content | Do NOT modify without explicit user confirmation |
| `[INFER: topic]` | Derivable from analysis | Analyze and fill without asking user |
| `[DECIDE: topic]` | Requires user judgment | Ask user before proceeding |

## Boundaries

The following actions are FORBIDDEN:

- Modifying `[FIXED]` sections without explicit user confirmation
- Bypassing Gate validation
- Generating documents without proper FrontMatter
- Terminating tasks without Handoff
- Searching local directories for Blueprint project data (load `/blueprint` skill instead)

## Governance

### Amendment Process

1. Identify the section requiring change
2. For `[FIXED]` sections: Explicit user confirmation is REQUIRED
3. Update version number following semver
4. Document the change in commit message

### Version Policy

- **MAJOR**: Changes to `[FIXED]` sections
- **MINOR**: New principles or additions
- **PATCH**: Clarifications

---

## Principles with Defaults

These principles are provided as sensible defaults.

### Context Management

All Agents MUST treat context as a precious resource:

- Return **compressed summaries**, not raw data, in Handoff
- Include only **decision-relevant information** in outputs
- Delegate deep analysis to **subagents** to preserve main context
- When context grows large, **summarize and persist** to external documents

### Quality Principles

All Agents MUST ensure output quality:

- **Verify before reporting**: Cross-check facts against source documents
- **Acknowledge uncertainty**: Clearly state when information is incomplete or ambiguous
- **Prefer precision over assumption**: Request clarification rather than guess
- **Self-critique**: Review own output against task requirements before Handoff

### Collaboration

In multi-agent environments, all Agents MUST:

- **Respect role boundaries**: Do not perform tasks assigned to other Agents
- **Maintain traceability**: Reference source documents in all outputs
- **Provide actionable context**: Include sufficient detail for downstream Agents
- **Leave clear artifacts**: Ensure work can be resumed without full context reload

---

**Version**: 1.0.0 | **Created**: {{date}}
