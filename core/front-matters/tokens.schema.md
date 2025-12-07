---
type: schema
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [schema, tokens, front-matter, lexer]
dependencies: [front-matters/base.schema.md]
---

# Schema: Tokens FrontMatter

> Extends base schema with Tokens-specific fields. Tokens are the output of Lexer, representing typed segments of a discussion.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `source` | string | Path to source discussion file |
| `token-count` | number | Total number of tokens |

## Additional Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `token-summary` | object | `null` | Count by token type |

## Field Definitions

### source

- **Type**: string
- **Required**: Yes
- **Format**: Relative path to discussion file
- **Examples**: `"001.md"`, `"002-api-design.md"`
- **Description**: The discussion file that was tokenized.

### token-count

- **Type**: number
- **Required**: Yes
- **Format**: Positive integer
- **Examples**: `15`, `42`
- **Description**: Total number of tokens generated.

### token-summary

- **Type**: object | null
- **Required**: No
- **Default**: `null`
- **Description**: Breakdown of token counts by type.

**Structure**:
```yaml
token-summary:
  decisions: 5
  constraints: 3
  questions: 2
  alternatives: 4
  problems: 1
  reasoning: 8
  concerns: 2
  definitions: 3
  analogies: 1
  models: 2
  fillers: 5
  noise: 3
```

## Token Types

| Type | Description |
|------|-------------|
| `DECISION` | Confirmed action/direction |
| `CONSTRAINT` | Boundary condition/limit |
| `OPEN_QUESTION` | Unresolved item |
| `ALTERNATIVE` | Option considered |
| `PROBLEM` | Problem recognition |
| `REASONING` | Rationale/justification |
| `CONCERN` | Worry/uncertain constraint |
| `DEFINITION` | Term/concept definition |
| `ANALOGY` | Metaphor/comparison |
| `MODEL` | Structure/flow proposal |
| `FILLER` | Thinking markers |
| `NOISE` | Meaningless utterance |

## Token Structure

Each token in the `tokens` array:

```yaml
tokens:
  - id: string          # Sequential ID (T-001, T-002, ...)
    type: TokenType     # Primary token type
    text: string        # Original text verbatim
    position: number    # Line number in source
    markers:
      hasPause: boolean       # Contains pause indicator
      deliberation: boolean   # Contains hedging/qualifiers
      uncertainty: boolean    # Contains tentative language
      questionForm: boolean   # Is interrogative
    secondary: TokenType | null  # Secondary type for compound
```

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `tokens` |
| Status | Must be: `draft`, `complete` |
| File Name | Must match: `{source-name}.tokens.yaml` |
| Source Exists | `source` file must exist |

## Status Definitions

| Value | Description |
|-------|-------------|
| `draft` | Tokenization in progress |
| `complete` | Tokenization finished |

## Usage Examples

### Complete Tokens File

```yaml
---
type: tokens
status: complete
version: 1.0.0
created: 2025-12-07
updated: 2025-12-07
tags: [tokens]
dependencies: []

source: "001.md"
token-count: 15
token-summary:
  decisions: 5
  constraints: 2
  questions: 3
  alternatives: 2
  reasoning: 3
---

tokens:
  - id: "T-001"
    type: PROBLEM
    text: "The current Phase/Stage/Task structure is too execution-centric"
    position: 18
    markers:
      hasPause: false
      deliberation: false
      uncertainty: false
      questionForm: false
    secondary: null

  - id: "T-002"
    type: DECISION
    text: "Decided to treat Specification as a high-level language"
    position: 24
    markers:
      hasPause: false
      deliberation: false
      uncertainty: false
      questionForm: false
    secondary: null
```

## File Naming Convention

| Source | Tokens File |
|--------|-------------|
| `001.md` | `001.tokens.yaml` |
| `002-api-design.md` | `002-api-design.tokens.yaml` |

## Location

```
blueprint/discussions/
├── 001.md                    # Discussion (source)
├── 001.tokens.yaml           # Tokens (output)
├── 002-api-design.md
└── 002-api-design.tokens.yaml
```
