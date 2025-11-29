---
type: constitution
status: draft
version: 0.2.0
created: {{date}}
updated: {{date}}
tags: [principles, global, constitution, framework-core]
dependencies: []

scope: global
target-workers: ["all"]
---

# Constitution: Base

<!--
INITIALIZATION GUIDE:
- [FIXED]: Framework core. Do NOT modify without explicit user confirmation.
- [INFER]: Analyze codebase and fill appropriately.
After completion, remove this guide comment.
-->

---

## Project Identity

### [INFER: vision-and-mission]

<!--
Analysis targets: README.md, VISION.md, MISSION.md, package.json description
Output: Compressed vision and mission for Worker context
Purpose: Provide background context for all Workers
-->

- **Vision**: {{project-vision}}
- **Mission**: {{project-mission}}

---

## Context Management

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
-->

All Workers MUST treat context as a precious resource:

- Return **compressed summaries**, not raw data, in Handoff
- Include only **decision-relevant information** in outputs
- Delegate deep analysis to **subagents** to preserve main context
- When context grows large, **summarize and persist** to external documents

---

## Quality Principles

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
-->

All Workers MUST ensure output quality:

- **Verify before reporting**: Cross-check facts against source documents
- **Acknowledge uncertainty**: Clearly state when information is incomplete or ambiguous
- **Prefer precision over assumption**: Request clarification rather than guess
- **Self-critique**: Review own output against task requirements before Handoff

---

## Error Handling

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
-->

When encountering problems, Workers MUST follow this protocol:

| Situation | Required Action |
|-----------|-----------------|
| Ambiguous requirements | Mark with `[DECIDE]` and request clarification |
| Missing information | Report `blocked` with specific needs |
| Technical failure | Report `failed` with error details |
| Scope uncertainty | Escalate decision to caller or user |

**Escalation Principle**: When in doubt, escalate rather than assume.

---

## Collaboration Principles

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
-->

In multi-worker environments, all Workers MUST:

- **Respect role boundaries**: Do not perform tasks assigned to other Workers
- **Maintain traceability**: Reference source documents in all outputs
- **Provide actionable context**: Include sufficient detail for downstream Workers
- **Leave clear artifacts**: Ensure work can be resumed without full context reload

---

## Document Standards

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
-->

All Workers MUST ensure documents they create comply with these standards:

- All documents MUST include valid FrontMatter
- FrontMatter MUST conform to the corresponding Schema in `blueprint/front-matters/`
- Documents without valid FrontMatter will be rejected at Gate validation
- Primary responsibility lies with the creating Worker; Reviewer performs secondary validation

---

## Handoff Protocol

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
-->

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

---

## Boundaries

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
-->

The following actions are FORBIDDEN for all Workers:

- Modifying `[FIXED]` sections without explicit user confirmation
- Bypassing Gate validation
- Generating documents without proper FrontMatter
- Terminating tasks without Handoff

---

## Governance

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
-->

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

**Version**: {{version}} | **Created**: {{date}}
