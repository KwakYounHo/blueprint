---
type: schema
status: active
version: 1.1.0
created: {{date}}
updated: {{date}}
tags: [schema, memory, specification, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Memory FrontMatter

> Extends base schema with Memory-specific fields. Memory files serve as **Specification Plans** - maintaining context across multi-session specification work and tracking implementation decisions.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `session-count` | number | Total interaction sessions count |
| `last-session` | date | Date of last interaction session |

## Additional Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `source-discussion` | string | `null` | Path to originating discussion file (if created from discussion) |
| `source-memory` | string | `null` | Path to parent memory (for continuation) |
| `generated-specs` | array | `[]` | List of specs generated from this memory |

## Field Definitions

### source-discussion

- **Type**: string | null
- **Required**: No
- **Default**: `null`
- **Format**: Relative path to discussion file
- **Examples**: `"blueprint/discussions/001-elevenlabs-tts.md"`, `null`
- **Description**: Traceability to the originating discussion. When `null`, Memory was created through interactive mode (direct conversation with Specifier).

### session-count

- **Type**: number
- **Required**: Yes
- **Minimum**: 1
- **Description**: Number of user-Specifier interaction sessions.

### last-session

- **Type**: date
- **Required**: Yes
- **Format**: `YYYY-MM-DD`
- **Description**: Date of the most recent interaction session.

### source-memory

- **Type**: string | null
- **Required**: No
- **Default**: `null`
- **Description**: Reference to parent memory for continued sessions.

### generated-specs

- **Type**: array
- **Required**: No
- **Default**: `[]`
- **Description**: List of specification IDs generated from this memory.

**Structure**:
```yaml
generated-specs:
  - spec-id: "LIB-auth/token-validator"
    status: ready
  - spec-id: "FEAT-user-authentication"
    status: draft
```

## Memory Body Sections (6 Required)

### 1. Session Log

Chronological conversation record with context for decisions. Captures the **why** behind each decision.

```markdown
## Session Log

### 2025-01-15 Session 1

User: "I want to add authentication to the API."

Me: Clarifying the scope - API-only or full-stack?

User: "API-only. We're using JWT tokens from an external provider."

Me: Understood. Exploring existing patterns in codebase.

> **D-001**: Use middleware pattern for auth - matches existing request handling

User: "Should we validate tokens on every request?"

Me: Proposing two options with trade-offs.

> **D-002**: Validate on every request - security over performance
```

**Format**:
- `User: "quoted text"` - User's exact words
- `Me: description` - Specifier's action/response (not quoted)
- `> **D-XXX**: decision - rationale` - Inline decision marker

### 2. Decisions Made

Summary table of all decisions (derived from Session Log).

```markdown
## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | Use TypeScript over JavaScript | Type safety, better IDE support | 1 |
| D-002 | Use Zod for validation | Runtime validation + type inference | 1 |
```

### 3. [DECIDE] Items

Pending decisions requiring user input.

```markdown
## [DECIDE] Items (Pending)

| ID | Question | Options | Status |
|----|----------|---------|--------|
| DECIDE-001 | Error handling strategy? | A: throw, B: return Result | pending |
| DECIDE-002 | Config file format? | A: JSON, B: YAML | resolved → D-003 |
```

### 4. Codebase Analysis

Patterns and locations discovered during analysis.

```markdown
## Codebase Analysis

### Existing Patterns
- Service pattern: `src/services/{name}/index.ts`
- Utility pattern: `src/utils/{name}.ts`

### File Locations
| Context | Pattern | Example |
|---------|---------|---------|
| Services | `src/services/{name}/` | `src/services/auth/index.ts` |
| Utils | `src/utils/{name}.ts` | `src/utils/validation.ts` |
```

### 5. Implementation Plan

Specification structure and implementation order.

```markdown
## Implementation Plan

### Proposed Specs
| ID | Type | Purpose | Dependencies |
|----|------|---------|--------------|
| LIB-auth/token-validator | lib | JWT token validation | none |
| FEAT-user-authentication | feature | Full auth flow | LIB-auth/token-validator |

### Implementation Order
1. LIB-auth/token-validator - Foundation, no dependencies
2. FEAT-user-authentication - Depends on token-validator

### Affected Files
| File | Change Type | Notes |
|------|-------------|-------|
| src/services/auth/index.ts | create | Auth service |
| src/middleware/auth.ts | create | Auth middleware |
```

### 6. Generated Artifacts

Tracking of outputs produced.

```markdown
## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | {this file} | active |
| Lib Spec | blueprint/specs/lib/auth/token-validator/spec.yaml | draft |
| Feature Spec | blueprint/specs/features/user-auth/spec.yaml | draft |
```

## Status Definitions

| Value | Description |
|-------|-------------|
| `active` | Specification work in progress |
| `completed` | All specs generated, memory archived for reference |
| `archived` | Superseded or abandoned |

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `memory` |
| Traceability | If `source-discussion` is set, must reference valid discussion |
| Update | Must be updated after each significant decision |
| Location | `blueprint/specs/memory/` directory |

## Template

For complete example, use:

```bash
forma show memory
```

## File Naming

Memory files use sequential numbering with descriptive suffix:

| Creation Mode | Pattern | Example |
|---------------|---------|---------|
| Interactive | `{NNN}-{brief-topic}.md` | `001-user-authentication.md` |
| From Discussion | `{discussion-id}-memory.md` | `001-feature-request-memory.md` |

**Interactive Mode** (source-discussion: null):
- Created through direct conversation with Specifier
- Named by topic, not by source

**From Discussion** (source-discussion: path):
- Created by analyzing existing discussion file
- Named by source discussion ID
