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
| `source-memory` | string | `null` | Path to memory file (if used) |

## Field Definitions

### spec-type

- **Type**: enum
- **Required**: Yes
- **Values**: `lib`, `feature`
- **Description**: Distinguishes between library (declaration) and feature (invocation) specs.

| Value | Analogy | Purpose |
|-------|---------|---------|
| `lib` | Library | Reusable unit, declaration, pure function |
| `feature` | Main | Business flow, invocation, composition |

**Naming Convention**:
- Lib specs: `LIB-{namespace}/{module}` (e.g., `LIB-elevenlabs/schema`)
- Feature specs: `FEAT-{name}` (e.g., `FEAT-elevenlabs-tts-integration`)

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

## Lib Spec Body (5 Required Sections)

Lib specs enable **deterministic implementation** - any Implementer produces identical code.

### 1. Purpose

Single sentence describing what this module does.

```markdown
## 1. Purpose

Pure utility for hashing and verifying passwords using bcrypt.
```

### 2. File Location

Exact path where implementation file will be created.

```markdown
## 2. File Location

```
src/lib/auth/password-hasher.ts
```
```

### 3. Implementation

Complete code with NO placeholders. Forbidden: `// TODO`, `...`, `REPLACE_*`.

```markdown
## 3. Implementation

```typescript
import bcrypt from "bcrypt";

const SALT_ROUNDS = 12;

export async function hashPassword(plaintext: string): Promise<string> {
  return bcrypt.hash(plaintext, SALT_ROUNDS);
}

export async function verifyPassword(
  plaintext: string,
  hash: string
): Promise<boolean> {
  return bcrypt.compare(plaintext, hash);
}
```
```

### 4. Integration Point

Where this module is called from.

```markdown
## 4. Integration Point

**Called from**: `src/services/auth/register.ts:45` in `registerUser`

```typescript
import { hashPassword } from "@/lib/auth/password-hasher";

const hashedPassword = await hashPassword(input.password);
```
```

### 5. Acceptance Criteria

Verifiable conditions for completion.

```markdown
## 5. Acceptance Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | hashPassword returns valid bcrypt hash | Unit test |
| 2 | verifyPassword matches correct pairs | Unit test |
```

---

## Feature Spec Body (5 Required Sections)

Feature specs define composition of Lib specs and integration points.

### 1. Summary

What, Why, and Scope.

```markdown
## 1. Summary

### What
JWT-based user authentication with session management.

### Why
- Secure user identity verification
- Stateless authentication for API scalability

### Scope
- **Include**: Login, Register, Token refresh, Logout
- **Exclude**: OAuth providers, MFA, Password reset
```

### 2. Lib Dependencies

List of Lib specs this feature composes.

```markdown
## 2. Lib Dependencies

| Lib Spec | Role |
|----------|------|
| LIB-auth/password-hasher | Password hashing/verification |
| LIB-auth/jwt-validator | Token generation/validation |
| LIB-auth/session-manager | Session storage/retrieval |
```

### 3. Integration Points

Where lib modules are called (file:line).

```markdown
## 3. Integration Points

### 3.1 Login Endpoint

**File**: `src/routes/auth/login.ts` (Line 23-35)

```typescript
import { verifyPassword } from "@/lib/auth/password-hasher";
import { generateToken } from "@/lib/auth/jwt-validator";

const isValid = await verifyPassword(input.password, user.passwordHash);
const token = generateToken({ userId: user.id });
```
```

### 4. Implementation Order

Dependency-based sequence.

```markdown
## 4. Implementation Order

```
Phase 1: Core Utilities
├── LIB-auth/password-hasher
└── LIB-auth/jwt-validator

Phase 2: Session Management
└── LIB-auth/session-manager

Phase 3: Integration (This Spec)
├── Login endpoint
└── Auth middleware
```
```

### 5. Acceptance Criteria

Verifiable conditions for the complete feature.

```markdown
## 5. Acceptance Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | Login returns valid JWT | API test |
| 2 | Protected routes reject invalid tokens | API test |
| 3 | TypeScript compiles | `npx tsc --noEmit` |
```

---

## [DECIDE] Markers

Unresolved items requiring user input (draft status only).

```markdown
[DECIDE: api-integration]
<!--
Question: SDK vs REST API?
Options:
- Option A: SDK - Type safety, built-in retry
- Option B: REST - No dependency, manual types
Recommendation: SDK (matches existing pattern)
Related: D-001
-->
```

**Rule**: All `[DECIDE]` markers MUST be resolved before status changes to `ready`.

## Constraints

| Rule | Description |
|------|-------------|
| Type | `type` field must be `spec` |
| Status | Must be: `draft`, `ready` |
| Spec Type | `spec-type` must be `lib` or `feature` |
| Location | Lib in `blueprint/specs/lib/{namespace}/{module}/`, Feature in `blueprint/specs/features/{name}/` |
| Deterministic | Lib specs MUST enable identical code generation by any Implementer |
| No Placeholders | `// TODO`, `...`, `REPLACE_*` are FORBIDDEN in implementation code |
| [DECIDE] Resolution | All `[DECIDE]` markers must be resolved before `ready` status |

## Status Definitions

| Value | Description |
|-------|-------------|
| `draft` | Specification in progress, may have [DECIDE] markers |
| `ready` | All [DECIDE] resolved, user approved, ready for implementation |

## Templates

For complete examples, use `forma show <type>`:

```bash
forma show spec-lib    # Lib Specification template
forma show spec-feat   # Feature Specification template
```

## Directory Structure

```
blueprint/specs/
├── features/
│   └── user-authentication/
│       └── spec.yaml           # Feature spec (FEAT-user-authentication)
└── lib/
    └── auth/                   # Namespace grouping
        ├── jwt-validator/
        │   └── spec.yaml       # LIB-auth/jwt-validator
        ├── password-hasher/
        │   └── spec.yaml       # LIB-auth/password-hasher
        └── session-manager/
            └── spec.yaml       # LIB-auth/session-manager
```

## File Naming

All specifications use `spec.yaml` as filename, organized by namespace:

| Spec Type | Location | ID Format |
|-----------|----------|-----------|
| Lib | `blueprint/specs/lib/{namespace}/{module}/spec.yaml` | `LIB-{namespace}/{module}` |
| Feature | `blueprint/specs/features/{feature-name}/spec.yaml` | `FEAT-{feature-name}` |
