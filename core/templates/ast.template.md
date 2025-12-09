---
type: ast
status: complete
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [ast]
dependencies: []

source: "{NNN}.tokens.yaml"
node-count: 0
relationship-count: 0
node-summary:
  problem: 0
  decision: 0
  reasoning: 0
---

nodes:
  - id: "N-001"
    type: ProblemNode
    token-ref: "T-001"
    text: "{text from token}"
    position: 18
    relationships:
      - type: motivates
        target: "N-002"

  - id: "N-002"
    type: DecisionNode
    token-ref: "T-002"
    text: "{text from token}"
    position: 24
    relationships:
      - type: resolves
        target: "N-001"
