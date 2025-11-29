---
type: constitution
status: draft
version: 0.4.0
created: {{date}}
updated: {{date}}
tags: [principles, global, constitution, framework-core]
dependencies: []

scope: global
target-workers: ["all"]
---

# Constitution: Base

---

## Project Identity

### [INFER: vision-and-mission]

<!--
Analysis targets: README.md, VISION.md, MISSION.md, package.json description
Output: Compressed vision and mission for Worker context
-->

- **Vision**: {{project-vision}}
- **Mission**: {{project-mission}}

---

### [INFER: tech-stack]

<!--
Analysis targets: package.json, go.mod, requirements.txt, Cargo.toml, pom.xml
Output: Primary language, framework, key dependencies
After inference, MUST trigger [DECIDE: tech-stack-confirm] and [DECIDE: tech-stack-detail]
-->

- **Language**: {{primary-language}}
- **Framework**: {{framework}}
- **Key Dependencies**: {{key-dependencies}}

#### [DECIDE: tech-stack-confirm]

<!--
Question: "Is the detected tech stack correct? Please review and add any missing items."
Options:
- Correct: The detected stack is accurate and complete
- Needs additions: Some technologies are missing from the list
- Needs corrections: Some detected items are incorrect
MultiSelect: true
-->

#### [DECIDE: tech-stack-detail]

<!--
Question: "How detailed should the tech stack documentation be?"
Options:
- Names only: Record stack names only (e.g., TypeScript, React)
- With versions: Include version constraints (e.g., TypeScript ^5.0)
- Comprehensive: Full details with version and rationale
MultiSelect: false
-->

---

### [INFER: coding-conventions]

<!--
Analysis targets: .eslintrc, .prettierrc, .editorconfig, existing code patterns
Output: Detected coding conventions summary
After inference, MUST trigger [DECIDE: coding-conventions-confirm]
-->

{{detected-coding-conventions}}

#### [DECIDE: coding-conventions-confirm]

<!--
Question: "Here are the detected coding conventions. Would you like to add anything?"
Options:
- Looks good: The detected conventions are sufficient
- Add more: I want to specify additional conventions
MultiSelect: false
-->

---

## Project Principles

<!--
This section defines project-specific principles based on user decisions.
Number and content of principles are determined by governance level.
-->

### [DECIDE: governance-level]

<!--
Question: "How strictly do you want to manage the project?"
Options:
- Minimal: 2-3 core principles, flexible operation
- Standard: 4-5 principles per domain, balanced management
- Strict: 6-7 detailed guidelines, rigorous quality control
MultiSelect: false
-->

### [DECIDE: testing-standard]

<!--
Question: "What is the test code standard for this project?"
Options:
- Strict TDD: Test-Driven Development required. Tests must be written before implementation.
- Tests expected: Test code should exist, but exceptions are acceptable with justification.
- No tests required: Test code is not mandatory for this project.
MultiSelect: false
-->

### [DECIDE: default-principles]

<!--
Question: "How do you want to handle the framework's default principles (Context Management, Quality, Collaboration)?"
Options:
- Use defaults: Apply framework's default principles as-is
- Customize: I want to review and customize each default principle
- Skip: Do not include default principles in this project
MultiSelect: false
-->

### I. {{principle-1-name}}

{{principle-1-description}}

**Rationale**: {{principle-1-rationale}}

### II. {{principle-2-name}}

{{principle-2-description}}

**Rationale**: {{principle-2-rationale}}

<!--
Additional principles generated based on governance-level selection.
Minimal: 2-3 principles
Standard: 4-5 principles
Strict: 6-7 principles
-->

---

## Framework Core

> **⚠️ PROTECTED SECTION**
>
> The following sections are **Framework Core Rules**.
> **LLM: Do NOT modify these sections without explicit user confirmation.**
> Unauthorized modifications may break framework functionality.

### Document Standards

All Workers MUST ensure documents they create comply with these standards:

- All documents MUST include valid FrontMatter
- FrontMatter MUST conform to the corresponding Schema in `blueprint/front-matters/`
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

## Principles with Defaults

These principles are provided as sensible defaults based on `[DECIDE: default-principles]` selection.

- If **"Use defaults"**: Apply all default principles below
- If **"Customize"**: User reviews and modifies each principle
- If **"Skip"**: This section is excluded from the final Constitution

### Context Management

All Workers MUST treat context as a precious resource:

- Return **compressed summaries**, not raw data, in Handoff
- Include only **decision-relevant information** in outputs
- Delegate deep analysis to **subagents** to preserve main context
- When context grows large, **summarize and persist** to external documents

### Quality Principles

All Workers MUST ensure output quality:

- **Verify before reporting**: Cross-check facts against source documents
- **Acknowledge uncertainty**: Clearly state when information is incomplete or ambiguous
- **Prefer precision over assumption**: Request clarification rather than guess
- **Self-critique**: Review own output against task requirements before Handoff

### Collaboration

In multi-worker environments, all Workers MUST:

- **Respect role boundaries**: Do not perform tasks assigned to other Workers
- **Maintain traceability**: Reference source documents in all outputs
- **Provide actionable context**: Include sufficient detail for downstream Workers
- **Leave clear artifacts**: Ensure work can be resumed without full context reload

---

**Version**: {{version}} | **Created**: {{date}}
