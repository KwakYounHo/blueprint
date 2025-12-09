---
type: schema
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [schema, memory, specification, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Memory FrontMatter

> Extends base schema with Memory-specific fields. Memory files maintain context across multi-session specification work.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `source-discussion` | string | Path to originating discussion file |
| `session-count` | number | Total interaction sessions count |
| `last-session` | date | Date of last interaction session |

## Additional Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `source-memory` | string | `null` | Path to parent memory (for continuation) |
| `generated-specs` | array | `[]` | List of specs generated from this memory |

## Field Definitions

### source-discussion

- **Type**: string
- **Required**: Yes
- **Format**: Relative path to discussion file
- **Examples**: `"blueprint/discussions/001-elevenlabs-tts.md"`
- **Description**: Traceability to the originating discussion.

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
  - spec-id: "LIB-elevenlabs/schema"
    status: ready
  - spec-id: "FEAT-elevenlabs-tts-integration"
    status: draft
```

## Memory Body Sections (4 Required)

### 1. Decisions Made

Resolved decisions with rationale.

```markdown
## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | Use SDK over REST API | Type safety, built-in retry | 1 |
| D-002 | Static voice list | No API rate limit concerns | 2 |
```

### 2. [DECIDE] Items

Pending decisions requiring user input.

```markdown
## [DECIDE] Items (Pending)

| ID | Question | Options | Status |
|----|----------|---------|--------|
| DECIDE-001 | Error handling strategy? | A: throw, B: return Result | pending |
| DECIDE-002 | Voice list update frequency? | A: static, B: daily fetch | resolved → D-002 |
```

### 3. Codebase Analysis

Patterns and locations discovered during analysis.

```markdown
## Codebase Analysis

### Existing Patterns
- Provider pattern: `main/utils/tts/{provider}/index.ts`
- Client pattern: `lib/tts/{provider}/index.ts`

### File Locations
| Context | Pattern | Example |
|---------|---------|---------|
| Server Provider | `main/utils/tts/{name}/` | `main/utils/tts/typecast/index.ts` |
| Client Utils | `lib/tts/{name}/` | `lib/tts/typecast/index.ts` |
```

### 4. Generated Artifacts

Tracking of outputs produced.

```markdown
## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | {this file} | active |
| Lib Spec | blueprint/specs/lib/elevenlabs/schema/spec.yaml | draft |
| Feature Spec | blueprint/specs/features/elevenlabs-tts/spec.yaml | draft |
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
| Traceability | `source-discussion` must reference valid discussion |
| Update | Must be updated after each significant decision |
| Location | Same directory as source discussion |

## Template

For complete example, use:

```bash
forma show memory
```

## File Naming

Memory files use the naming pattern: `{discussion-id}-memory.md`

| Source Discussion | Memory File |
|-------------------|-------------|
| `001-elevenlabs-tts.md` | `001-elevenlabs-tts-memory.md` |
| `002-auth-redesign.md` | `002-auth-redesign-memory.md` |
