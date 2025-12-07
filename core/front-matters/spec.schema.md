---
type: schema
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [schema, spec, specification, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Specification FrontMatter

> Extends base schema with Specification-specific fields. Specifications are the high-level "source code" that Implementer compiles into actual code.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `spec-type` | enum | `implementation` or `feature` |
| `spec-id` | string | Unique specification identifier |
| `name` | string | Human-readable name |

## Additional Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `parent` | string | `null` | Parent spec ID for hierarchy |
| `children` | array | `[]` | Child spec references |
| `source-discussion` | string | `null` | Path to originating discussion |

## Field Definitions

### spec-type

- **Type**: enum
- **Required**: Yes
- **Values**: `implementation`, `feature`
- **Description**: Distinguishes between library (declaration) and main (invocation) specs.

| Value | Analogy | Purpose |
|-------|---------|---------|
| `implementation` | Library | Reusable unit, declaration, pure function |
| `feature` | Main | Business flow, invocation, composition |

### spec-id

- **Type**: string
- **Required**: Yes
- **Format**: `SPEC-{NNN}` or `LIB-{name}` / `FEAT-{name}`
- **Examples**: `"SPEC-001"`, `"LIB-prompt"`, `"FEAT-echo-program"`
- **Description**: Unique identifier for cross-referencing.

### name

- **Type**: string
- **Required**: Yes
- **Format**: Human-readable, concise
- **Examples**: `"User Input Handler"`, `"Echo Program"`
- **Description**: Descriptive name for the specification.

### parent

- **Type**: string | null
- **Required**: No
- **Default**: `null`
- **Format**: Spec ID of parent
- **Examples**: `"FEAT-messenger"`, `null`
- **Description**: For hierarchical spec structure.

### children

- **Type**: array
- **Required**: No
- **Default**: `[]`
- **Description**: References to child specifications.

**Structure**:
```yaml
children:
  - ref: "LIB-prompt"
    relationship: "how"      # how | who | structure | pattern
    required: true
```

### source-discussion

- **Type**: string | null
- **Required**: No
- **Default**: `null`
- **Format**: Path to discussion file
- **Examples**: `"blueprint/discussions/001-sdd-redesign.md"`
- **Description**: Traceability to originating discussion.

## Spec Body Fields (10 Required Sections)

The body of the spec.yaml contains these required sections:

### 1. what

What are we building?

```yaml
what:
  statement: "Brief one-line statement"
  description: "Detailed description"
```

### 2. why

Why are we building it?

```yaml
why:
  problem: "Problem being solved"
  motivation: "Why now, why this approach"
  benefit: "Expected outcome"
```

### 3. scope

What's the boundary?

```yaml
scope:
  includes:
    - "What is included"
  excludes:
    - "What is explicitly excluded"
```

### 4. constraints

What constraints apply?

```yaml
constraints:
  - statement: "Constraint description"
    type: technical | business | resource
    reason: "Why this constraint exists"
```

### 5. input

What goes in?

```yaml
input:
  - name: "inputName"
    type: "string"
    description: "What this input represents"
    required: true
```

### 6. output

What comes out?

```yaml
output:
  - name: "outputName"
    type: "string"
    description: "What this output represents"
```

### 7. edge_cases

What are the exceptions?

```yaml
edge_cases:
  - situation: "When X happens"
    expected_behavior: "System should Y"
```

### 8. anti_patterns

What should we avoid?

```yaml
anti_patterns:
  - description: "What not to do"
    reason: "Why it's problematic"
```

### 9. dependencies

What do we depend on?

```yaml
dependencies:
  technical:
    - "Node.js >= 18"
    - "TypeScript"
  internal:
    - "LIB-prompt"
  decisions:
    - "SPEC-001"
```

### 10. acceptance_criteria

How do we know it's done?

```yaml
acceptance_criteria:
  - criterion: "What must be true"
    verification: "How to verify"
```

## Feature Spec Additional Fields

Feature specs (spec-type: feature) have additional fields:

### flow

Composition of implementation specs:

```yaml
flow:
  - step: 1
    action: "Display prompt"
    uses: "LIB-prompt"
    params:
      message: "What to output?"
    returns: "void"
  - step: 2
    action: "Read user input"
    uses: "LIB-input"
    returns: "userInput"
```

### open_questions

Unresolved items (draft status only):

```yaml
open_questions:
  - id: "Q-001"
    question: "Which runtime environment?"
    options:
      - "Node.js"
      - "Deno"
      - "Bun"
    required: true
    answered: false
    answer: null
```

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `spec` |
| Status | Must be: `draft`, `review`, `complete` |
| Spec Type | `spec-type` must be `implementation` or `feature` |
| Location | Implementation in `specs/lib/`, Feature in `specs/features/` |

## Status Definitions

| Value | Description |
|-------|-------------|
| `draft` | Specification in progress, may have open questions |
| `review` | Ready for review, all questions answered |
| `complete` | Approved, ready for implementation |

## Usage Examples

### Implementation Spec (lib)

```yaml
---
type: spec
status: complete
version: 1.0.0
created: 2025-12-07
updated: 2025-12-07
tags: [spec, lib, prompt]
dependencies: []

spec-type: implementation
spec-id: "LIB-prompt"
name: "Prompt Display"
parent: null
children: []
source-discussion: "blueprint/discussions/001-echo-program.md"
---

what:
  statement: "Display a prompt message to the user"
  description: "Outputs a formatted prompt string to stdout, preparing for user input"

why:
  problem: "Need to communicate with user before receiving input"
  motivation: "Standard UX pattern for CLI applications"
  benefit: "Clear user guidance"

scope:
  includes:
    - "Writing prompt text to stdout"
    - "Formatting with optional prefix"
  excludes:
    - "Reading user input"
    - "Validation"

constraints:
  - statement: "Must not read from stdin"
    type: technical
    reason: "Single responsibility - reading is separate concern"

input:
  - name: "message"
    type: "string"
    description: "The prompt message to display"
    required: true

output:
  - name: "void"
    type: "void"
    description: "No return value, side effect is stdout"

edge_cases:
  - situation: "Empty message"
    expected_behavior: "Display empty line"

anti_patterns:
  - description: "Including input reading in prompt function"
    reason: "Violates single responsibility"

dependencies:
  technical:
    - "Node.js >= 18"
  internal: []
  decisions: []

acceptance_criteria:
  - criterion: "Prompt message appears on stdout"
    verification: "Visual inspection or stdout capture"
```

### Feature Spec (features)

```yaml
---
type: spec
status: draft
version: 1.0.0
created: 2025-12-07
updated: 2025-12-07
tags: [spec, feature, echo]
dependencies: []

spec-type: feature
spec-id: "FEAT-echo-program"
name: "Echo Program"
parent: null
children:
  - ref: "LIB-prompt"
    relationship: "how"
    required: true
  - ref: "LIB-input"
    relationship: "how"
    required: true
  - ref: "LIB-output"
    relationship: "how"
    required: true
source-discussion: "blueprint/discussions/001-echo-program.md"
---

what:
  statement: "CLI program that echoes user input"
  description: "Prompts user for input, reads their response, and outputs it back"

why:
  problem: "Need a simple demonstration of input/output flow"
  motivation: "Validate the SDD compilation process"
  benefit: "Working example of spec-to-code compilation"

# ... (other required sections)

flow:
  - step: 1
    action: "Display prompt"
    uses: "LIB-prompt"
    params:
      message: "What to output?"
    returns: "void"
  - step: 2
    action: "Read user input"
    uses: "LIB-input"
    returns: "userInput"
  - step: 3
    action: "Output the input"
    uses: "LIB-output"
    params:
      content: "userInput"
    returns: "void"

open_questions:
  - id: "Q-001"
    question: "Which runtime environment?"
    options:
      - "Node.js"
      - "Deno"
    required: true
    answered: false
    answer: null
```

## Directory Structure

```
specs/
├── features/
│   └── echo-program/
│       └── spec.yaml       # Feature spec
└── lib/
    ├── prompt/
    │   └── spec.yaml       # Implementation spec
    ├── input/
    │   └── spec.yaml
    └── output/
        └── spec.yaml
```

## File Naming

All specifications use `spec.yaml` as filename, organized by directory:

| Spec Type | Location |
|-----------|----------|
| Implementation | `specs/lib/{module-name}/spec.yaml` |
| Feature | `specs/features/{feature-name}/spec.yaml` |
