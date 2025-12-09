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

> Extends base schema with Tokens-specific fields. Tokens are the output of Lexer, representing typed segments of raw context (discussion or memory).

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `source` | string | Path to source file (discussion or memory) |
| `token-count` | number | Total number of tokens |

## Additional Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `token-summary` | object | `null` | Count by token type |

## Field Definitions

### source

- **Type**: string
- **Required**: Yes
- **Format**: Relative path to source file
- **Examples**: `"001.md"`, `"002-api-design.md"`, `"001-memory.md"`
- **Description**: The source file (discussion or memory) that was tokenized.

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

## Template

For complete example, use:

```bash
forma show tokens
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
