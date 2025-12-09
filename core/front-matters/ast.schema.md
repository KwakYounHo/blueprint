---
type: schema
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [schema, ast, front-matter, parser]
dependencies: [front-matters/base.schema.md]
---

# Schema: AST FrontMatter

> Extends base schema with AST-specific fields. AST is the output of Parser, representing the structural relationships between context elements.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `source` | string | Path to source tokens file |
| `node-count` | number | Total number of nodes |
| `relationship-count` | number | Total number of relationships |

## Additional Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `node-summary` | object | `null` | Count by node type |

## Field Definitions

### source

- **Type**: string
- **Required**: Yes
- **Format**: Relative path to tokens file
- **Examples**: `"001.tokens.yaml"`, `"002-api-design.tokens.yaml"`
- **Description**: The tokens file that was parsed.

### node-count

- **Type**: number
- **Required**: Yes
- **Format**: Positive integer
- **Examples**: `12`, `35`
- **Description**: Total number of nodes in the AST.

### relationship-count

- **Type**: number
- **Required**: Yes
- **Format**: Non-negative integer
- **Examples**: `8`, `0`
- **Description**: Total number of relationships between nodes.

### node-summary

- **Type**: object | null
- **Required**: No
- **Default**: `null`
- **Description**: Breakdown of node counts by type.

**Structure**:
```yaml
node-summary:
  problem: 1
  decision: 5
  constraint: 3
  question: 2
  alternative: 4
  reasoning: 8
  concern: 2
  definition: 3
  analogy: 1
  model: 2
```

## Node Types

| Type | Description |
|------|-------------|
| `ProblemNode` | Problem/background statement |
| `DecisionNode` | Confirmed decision |
| `ConstraintNode` | Boundary/limitation |
| `QuestionNode` | Open question |
| `AlternativeNode` | Option considered |
| `ReasoningNode` | Rationale/justification |
| `ConcernNode` | Worry/risk |
| `DefinitionNode` | Term/concept definition |
| `AnalogyNode` | Metaphor/comparison |
| `ModelNode` | Structure/flow proposal |
| `BehaviorNode` | Action/behavior definition |

## Relationship Types

| Type | Description | Direction |
|------|-------------|-----------|
| `respondsTo` | Response to question | source → target question |
| `refutes` | Refutation/rejection | source → target refuted |
| `supports` | Support/rationale | source → target supported |
| `raises` | Raise concern | source → target concerning |
| `resolves` | Resolution | source → target resolved |
| `scopedBy` | Context limitation | source → target constraint |
| `motivates` | Motivation | source → target motivated |
| `derivedFrom` | Derivation | source → target origin |

## Node Structure

Each node in the `nodes` array:

```yaml
nodes:
  - id: string           # Sequential ID (N-001, N-002, ...)
    type: NodeType       # Node type
    token-ref: string    # Reference to source token ID
    text: string         # Original text from token
    position: number     # Line number in original source
    relationships:       # Outgoing relationships
      - type: RelationType
        target: string   # Target node ID
```

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `ast` |
| Status | Must be: `draft`, `complete` |
| File Name | Must match: `{source-name}.ast.yaml` |
| Source Exists | `source` tokens file must exist |
| Node IDs | Must be unique and sequential |

## Status Definitions

| Value | Description |
|-------|-------------|
| `draft` | Parsing in progress |
| `complete` | Parsing finished |

## Template

For complete example, use:

```bash
forma show ast
```

## File Naming Convention

| Source | AST File |
|--------|----------|
| `001.tokens.yaml` | `001.ast.yaml` |
| `002-api-design.tokens.yaml` | `002-api-design.ast.yaml` |

## Location

```
blueprint/discussions/
├── 001.md                    # Discussion (original)
├── 001.tokens.yaml           # Tokens (Lexer output)
├── 001.ast.yaml              # AST (Parser output)
├── 002-api-design.md
├── 002-api-design.tokens.yaml
└── 002-api-design.ast.yaml
```
