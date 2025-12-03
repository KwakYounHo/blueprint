---
type: stage
status: draft
version: 1.0.0
created: "{{date}}"
updated: "{{date}}"
tags: [stage, "{{stage-name}}"]
dependencies: [spec.md]

name: "{{stage-name}}"
order: "{{SS}}"
---

<!--
INITIALIZATION GUIDE (For Specifier Worker):

This template is referenced when creating stage-{SS}-{name}.md (Stage document).

[Annotation System]
- [FIXED]: Do NOT modify without explicit user confirmation.
- [INFER]: Fill by analyzing requirements.
- [DECIDE]: Insert marker for items requiring user judgment.

[DECIDE Marker Usage]
When encountering ambiguous items requiring user decision:

[DECIDE: brief-description]
<！--
Question: Specific question
Options:
- Option A
- Option B
Recommendation: Recommended option with rationale
--＞

Example: When requirement priority or implementation scope is unclear

Remove this guide comment after completion.
-->

# Stage: {{stage-name}}

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
Stage document answers "What": What requirements must be fulfilled?
Background/purpose (Why) is defined in Phase, implementation methods (How) in Task.

Stage creation criteria: Derived from Phase.Boundaries
One Boundary can be decomposed into multiple Stages.
-->

---

## Description

<!--
[INFER: description]
Analysis targets: Phase.Boundaries, user requirements
Output: Summary of what this Stage covers

Rules:
- Specify which Boundary this Stage is derived from
- Briefly explain the scope and goals of this Stage
-->

{{What does this Stage cover?}}

**Related Boundary**: {{Corresponding item from Phase.Boundaries}}

---

## Requirements

<!--
[INFER: requirements]
Analysis targets: Phase.Boundaries, user requirements
Output: Specific requirements to be fulfilled in this Stage

Rules:
- Assign unique ID to each requirement (REQ-{SS}-{NNN})
- Write clearly to allow only one interpretation
- Avoid ambiguous expressions ("appropriately", "quickly", etc.)
- Must be measurable/verifiable

Use [DECIDE] marker when priority is unclear:
[DECIDE: req-priority-xxx]
-->

- **REQ-{{SS}}-001**: {{Requirement 1}}
  - Priority: {{High | Medium | Low}}

- **REQ-{{SS}}-002**: {{Requirement 2}}
  - Priority: {{High | Medium | Low}}

---

## Acceptance Criteria

<!--
[INFER: acceptance-criteria]
Analysis targets: Requirements section
Output: Verifiable criteria to determine Stage completion

Rules:
- Include verification criteria corresponding to each requirement
- Given-When-Then format recommended (optional)
- All criteria must be testable
-->

- [ ] **AC-{{SS}}-001**: {{Verifiable criterion 1}}
- [ ] **AC-{{SS}}-002**: {{Verifiable criterion 2}}

---

## Prerequisites

<!--
[INFER: prerequisites]
Analysis targets: Other Stage documents, Phase document
Output: Conditions that must be completed before starting this Stage

Rules:
- Specify dependencies on other Stages
- Specify external dependencies (APIs, libraries, etc.)
- Write "None" if no prerequisites
-->

- {{Prerequisite 1 or "None"}}

---

**Version**: {{version}} | **Created**: {{date}}
