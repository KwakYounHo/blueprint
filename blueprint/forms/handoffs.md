# Handoff Forms

Worker 간 통신 양식 정의.

Use **Hermes** skill to view specific forms: `hermes orchestrator specifier`

---

[F]Orchestrator&[T]Specifier
---s
```yaml
task:
  action: specify
  workflow-id: "{NNN-description}"
  requirements: "{clarified-requirements}"
```
---e

[F]Specifier&[T]Orchestrator
---s
```yaml
handoff:
  status: completed | blocked
  summary: "{what was created/modified}"
  artifacts:
    - "{path/to/created/file.md}"
  decide-markers:
    - location: "{file:line}"
      question: "{question requiring user decision}"
  next-steps:
    - "{recommended follow-up action}"
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
handoff:
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
        violations: []
    recommended:
      - criterion: "{criterion-name}"
        status: pass | fail
        violations: []
  summary: "{human-readable summary}"
```
---e
