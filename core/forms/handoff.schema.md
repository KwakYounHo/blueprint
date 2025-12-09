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

Use **Hermes** skill to view specific forms: `hermes orchestrator implementer`

---

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
  gate: "{gate-name}"
  aspect: "{aspect-name}"
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

[F]Specifier&[T]Lexer
---s
```yaml
task:
  action: tokenize
  source: "{path/to/file.md}"  # discussion or memory
```
---e

[F]Lexer&[T]Specifier
---s
```yaml
handoff:
  status: completed | blocked
  summary: "{what was tokenized}"
  artifacts:
    - "{path/to/discussion.tokens.yaml}"
  token-summary:
    decisions: {count}
    constraints: {count}
    questions: {count}
    alternatives: {count}
    problems: {count}
    reasoning: {count}
```
---e

[F]Specifier&[T]Parser
---s
```yaml
task:
  action: parse
  tokens: "{path/to/discussion.tokens.yaml}"
```
---e

[F]Parser&[T]Specifier
---s
```yaml
handoff:
  status: completed | blocked
  summary: "{what was parsed}"
  artifacts:
    - "{path/to/discussion.ast.yaml}"
  node-summary:
    total: {count}
    relationships: {count}
```
---e
