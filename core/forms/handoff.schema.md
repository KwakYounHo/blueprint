---
type: schema
status: draft
version: 1.0.0
created: "{{date}}"
updated: "{{date}}"
tags: [schema, handoff, worker, communication]
dependencies: []
---

# Handoff Forms

Defines communication forms between Workers.

Use **Hermes** skill to view specific forms: `hermes orchestrator specifier`

---

[F]Orchestrator&[T]Specifier
---s
```yaml
task:
  action: specify
  workflow-id: "{NNN-description}"
  requirements: "{clarified-requirements}"
  discussion: "{path/to/discussion.md}"  # optional
```
---e

[F]Specifier&[T]Orchestrator
---s
```yaml
handoff:
  status: completed | blocked
  summary: "{what was created/modified}"
  artifacts:
    - "{blueprint/workflows/NNN-desc/spec.md}"
    # or when from discussion:
    # - "{blueprint/discussions/NNN-topic.context.md}"
  decide-markers:
    - location: "{file:line}"
      question: "{question requiring user decision}"
```
---e

[F]Orchestrator&[T]Implementer
---s
```yaml
task:
  action: implement
  workflow-id: "{NNN-description}"
  task-file: "blueprint/workflows/{workflow-id}/task-SS-TT-name.md"
```
---e

[F]Implementer&[T]Orchestrator
---s
```yaml
handoff:
  status: completed | blocked
  summary: "{what was implemented}"
  artifacts:
    - "{path/to/created/file}"
  decide-markers:
    - location: "{file:line}"
      question: "{question requiring user decision}"
  tests:
    status: pass | fail | skipped
    details: "{test results summary}"
```
---e

[F]Orchestrator&[T]Reviewer
---s
```yaml
task:
  action: review
  document: "{path/to/artifact}"
  gate: specification | implementation | documentation
  aspect: "{aspect-name}"
  context:
    workflow-id: "{NNN-description}"
    phase: specification | implementation
```
---e

[F]Reviewer&[T]Orchestrator
---s
```yaml
handoff:
  status: pass | fail
  gate: "{gate-name}"
  aspect: "{aspect-name}"
  document: "{path/to/validated/document}"
  criteria:
    required:
      - criterion: "{criterion-name}"
        status: pass | fail
        violations:
          - location: "{file:line or section}"
            expected: "{what was expected}"
            actual: "{what was found}"
            suggestion: "{how to fix}"
    recommended:
      - criterion: "{criterion-name}"
        status: pass | fail
        violations:
          - location: "{file:line or section}"
            expected: "{what was expected}"
            actual: "{what was found}"
            suggestion: "{how to fix}"
  summary: "{human-readable summary}"
```
---e

[F]Orchestrator&[T]Annotator
---s
```yaml
task:
  action: annotate | revise
  discussion: "{path/to/discussion/file.md}"
  context: "{optional context or focus area}"
  feedback: "{user feedback for revision, empty if action is annotate}"
```
---e

[F]Annotator&[T]Orchestrator
---s
```yaml
handoff:
  status: completed | blocked
  summary: "{what was annotated}"
  artifacts:
    - "{blueprint/discussions/NNN-brief-summary.md}"
  markers:
    decisions: {count}
    constraints: {count}
    questions: {count}
    alternatives: {count}
  decide-markers:
    - location: "{file:line}"
      question: "{question requiring user decision}"
  confirmation-prompt: |
    I've identified the following key points:
    - {N} decisions
    - {N} constraints
    - {N} open questions
    - {N} alternatives

    Is there anything I missed or misunderstood?
```
---e
