---
type: task
status: draft
version: 1.0.0
created: "{{date}}"
updated: "{{date}}"
tags: [task, "{{stage-name}}"]
dependencies: ["stage-{{SS}}-{{stage-name}}.md"]

name: "{{task-name}}"
stage: "{{stage-name}}"
order: "{{TT}}"
parallel-group: "{{group-name | null}}"
---

<!--
INITIALIZATION GUIDE (For Specifier Worker):

This template is referenced when creating task-{SS}-{TT}-{name}.md (Task document).

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

Example: Technology stack selection, implementation approach decisions

Remove this guide comment after completion.
-->

# Task: {{task-name}}

<!--
[FIXED] - Framework Core Rule
LLM: Do NOT modify without explicit user confirmation.
Task document answers "How": How will this be implemented?
Background/purpose (Why) is defined in Phase, requirements (What) in Stage.

Task must contain sufficient information for Implementer Worker to generate code.
Technology stack, framework, and API choices MUST be defined in Task.

[parallel-group Field]
- Attribute assigned at Stage level
- Groups Tasks that can be executed simultaneously within the same Stage
- null: Sequential execution (runs after previous Task completes)
- "group-name": Tasks with the same group name can run in parallel
-->

---

## Objective

<!--
[INFER: objective]
Analysis targets: Stage.Requirements, user requirements
Output: Specific goal this Task aims to achieve

Rules:
- Specify which Requirement this fulfills
- Single responsibility principle: One Task = One clear goal
-->

{{What does this Task achieve?}}

**Related Requirement**: {{REQ-SS-NNN}}

---

## Technical Specification

<!--
[INFER: tech-spec]
Analysis targets: Project codebase, Stage.Requirements
Output: Technical decisions required for implementation

Rules:
- Specify technology stack, framework, libraries
- Concrete specifications like API endpoints, data models
- Use [DECIDE] marker for unclear technical choices

Purpose:
- Provide sufficient information so Implementer can generate code
  without considering other dependencies or complexities
- Simply follow what is specified
- This is the core value of SDD (Specification-Driven Development)
-->

### Tech Stack

- **Language**: {{language}}
- **Framework**: {{framework}}
- **Libraries**: {{libraries}}

### Implementation Details

{{API endpoints, data models, interfaces, etc.}}

---

## Approach

<!--
[INFER: approach]
Analysis targets: Technical Specification, Stage.Requirements
Output: Implementation method and design decisions

Rules:
- Include rationale for why this approach was chosen
- Briefly mention why alternatives were not selected (if any)
-->

{{How will this be implemented? Why this approach?}}

---

## Steps

<!--
[INFER: steps]
Analysis targets: Approach, Technical Specification
Output: Specific steps for Implementer to follow

Rules:
- Write as sequentially executable steps
- Each step should be verifiable
- Don't over-decompose (3-7 steps recommended)

Target: Implementer Worker
-->

1. {{Step 1}}
2. {{Step 2}}
3. {{Step 3}}

---

## Acceptance Criteria

<!--
[INFER: acceptance-criteria]
Analysis targets: Objective, Stage.Acceptance Criteria
Output: Verifiable criteria to determine Task completion

Rules:
- Connect to Stage.Acceptance Criteria
- Write in testable form
- Given-When-Then format recommended (optional)
-->

- [ ] **AC-{{SS}}-{{TT}}-001**: {{Verifiable criterion 1}}
- [ ] **AC-{{SS}}-{{TT}}-002**: {{Verifiable criterion 2}}

---

## Expected Artifacts

<!--
[INFER: expected-artifacts]
Analysis targets: Steps, Technical Specification
Output: List of Artifacts to be created/modified when this Task is completed

Rules:
- Specify file paths and types
- Distinguish between code, tests, config files, etc.

Purpose:
- Reference for artifacts field in Implementer → Orchestrator Handoff
- List of files for Reviewer to verify
- Artifact = Everything created/modified in Workflow (documents + code)
-->

| Artifact | Path | Type |
|----------|------|------|
| {{Artifact 1}} | {{src/auth/oauth.ts}} | {{code}} |
| {{Artifact 2}} | {{tests/auth/oauth.test.ts}} | {{test}} |

---

**Version**: {{version}} | **Created**: {{date}}
