---
type: phase
status: draft
version: 1.0.0
created: "{{date}}"
updated: "{{date}}"
tags: []
dependencies: []

workflow-id: "{{workflow-id}}"
---

<!--
INITIALIZATION GUIDE (For Specifier Worker):

This template is referenced when creating spec.md (Phase document).

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

Example: Features unclear whether to include/exclude in scope

Remove this guide comment after completion.
-->

# Phase: {{workflow-name}}

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
Phase document answers "Why": Why is this workflow needed?
Specific requirements (What) are defined in Stage, implementation methods (How) in Task.
-->

---

## Background

<!--
[INFER: background]
Analysis targets: User requirements, existing codebase, project context
Output: Why this workflow is needed, problem statement
-->

{{Why is this work needed? What problem does it solve?}}

---

## Objective

<!--
[INFER: objective]
Analysis targets: User requirements
Output: Goals this workflow aims to achieve (use action verbs)
-->

{{What will be achieved when this workflow is completed?}}

---

## Scope

### Boundaries

<!--
[INFER: boundaries]
Analysis targets: User requirements
Output: Domain/functional areas this workflow covers

Rules:
- Specific requirements are defined in Stage
- Here, only declare "what areas are covered"
- Write at domain/functional area level

Examples:
  ✅ "User authentication", "Payment processing" (domain declaration)
  ❌ "OAuth 2.0 implementation", "Stripe API integration" (too specific → Stage/Task)
-->

- {{Functional area 1}}
- {{Functional area 2}}

### Out of Scope

<!--
[INFER: out-of-scope]
Analysis targets: User requirements, project constraints
Output: Items explicitly not covered in this workflow

Rules:
- Clearly exclude potentially confusing items
- Distinguish between "do later" and "won't do at all"
-->

- {{Excluded item 1}}
- {{Excluded item 2}}

---

## Success Criteria

<!--
[INFER: success-criteria]
Analysis targets: User requirements
Output: Measurable criteria to determine workflow completion

Rules:
- All criteria must be verifiable
- Avoid ambiguous expressions ("quickly", "appropriately", etc.)
- Write in checklist format
-->

- [ ] {{Verifiable criterion 1}}
- [ ] {{Verifiable criterion 2}}

---

**Version**: {{version}} | **Created**: {{date}}
