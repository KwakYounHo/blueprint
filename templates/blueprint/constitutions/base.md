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
