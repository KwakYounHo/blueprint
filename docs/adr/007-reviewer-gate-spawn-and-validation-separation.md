---
type: adr
status: proposed
version: 0.0.1
created: 2026-02-11
updated: 2026-02-11
tags: [reviewer, gate, spawn, validation, schema, documentation-gate, session-gate]
dependencies: []

deciders: [user, claude]
supersedes: []
superseded-by: []
---

# ADR-007: Reviewer Gate-Level Spawn and Validation Responsibility Separation

## Context

### Current State

The Reviewer agent validates documents against Gate Aspects. It is invoked by workflow commands (`/load`, `/checkpoint`) to verify session state before resuming or archiving work.

```
/load       ──→ Reviewer (background)  ──→ session gate: 4 aspects
/checkpoint ──→ Reviewer (synchronous) ──→ session gate: 1 aspect
```

The Reviewer Instruction (`reviewer.md`) states:

> "Validates against ONE assigned Aspect's Criteria."

However, the actual Handoff Forms (`request:review:session-state`) send multiple aspects in a single invocation:

```yaml
gate: session
aspects:
  - git-state
  - file-integrity
  - plan-progress
  - analysis-completeness
```

### Problem

Two issues were identified:

1. **Spawn Granularity Mismatch**: The Reviewer Instruction specifies 1:1 (one spawn per aspect), but Handoff Forms use 1:N (one spawn per gate with multiple aspects). This inconsistency creates ambiguity for future Reviewer integrations.

2. **FrontMatter Schema Validation Gap**: The `documentation` gate defines a `schema-validation` aspect with criteria for validating FrontMatter against schemas. However, no workflow command invokes this aspect. `/save` modifies FrontMatter fields (session-id, current-phase, current-task, updated) in session documents, but neither `/load` nor `/checkpoint` validates these modifications against schemas.

   The gap was considered acceptable when `/bplan` was expected to handle FrontMatter correctness. However, `/bplan`'s workflow was simplified to only specify major FrontMatters (those directly affecting `/save` and `/load`), relying on the Reviewer as a safety net — a safety net that does not currently exist.

### Requirements

| # | Requirement |
|---|-------------|
| 1 | Resolve the Reviewer spawn granularity mismatch (Instruction vs Handoff Form) |
| 2 | Integrate FrontMatter schema validation into `/load` and `/checkpoint` workflows |
| 3 | Maintain clear separation between structural and semantic validation |
| 4 | Minimize additional context consumption in already context-heavy workflows |

---

## Considered Options

### Spawn Granularity

| Option | Description |
|--------|-------------|
| A. Gate-Level Spawn | 1 Reviewer per Gate, processing all aspects within that gate |
| B. Aspect-Level Spawn | 1 Reviewer per Aspect, matching the current Instruction wording |

#### Option A: Gate-Level Spawn

**Pros:**
- Matches actual Handoff Form usage (already in practice)
- Shared overhead amortized: blueprint skill load, constitution read, target file reads happen once per gate
- Fewer spawns for Orchestrator to manage
- Aspects within a gate share target files and context (e.g., session gate aspects all read CURRENT.md, ROADMAP.md)

**Cons:**
- Reviewer handles more work per spawn
- Requires updating Reviewer Instruction to reflect multi-aspect processing

#### Option B: Aspect-Level Spawn

**Pros:**
- Maximum isolation per aspect
- Simpler Reviewer logic (one aspect, one validation pass)

**Cons:**
- `/load` would need 4+ separate spawns (one per aspect), each repeating shared overhead
- Contradicts established Handoff Form patterns already in use
- Higher total context consumption due to repeated file reads and skill loading

### Validation Strategy

| Option | Description |
|--------|-------------|
| C. Generic schema-validation Aspect | One aspect for all structural validation, file scope defined by Request Form |
| D. Workflow-Specific Aspects | Separate `save-schema` and `checkpoint-schema` aspects |

#### Option C: Generic schema-validation Aspect

**Pros:**
- Single validation logic for all contexts (format, type, enum, constraints)
- File scope differences handled by Request Forms, not aspect definitions
- Lower maintenance burden

**Cons:**
- Cannot encode workflow-specific semantic rules (e.g., "after checkpoint, PLAN status should be completed")

#### Option D: Workflow-Specific Aspects

**Pros:**
- Can encode semantic validation rules per workflow

**Cons:**
- Duplicates structural validation logic across aspects
- Conflates structural and semantic validation responsibilities
- Higher maintenance burden for each new workflow

---

## Decision

We will use **Option A (Gate-Level Spawn)** for spawn granularity and **Option C (Generic schema-validation Aspect)** for validation strategy.

### Rationale

1. **Gate-Level Spawn resolves the mismatch pragmatically**: The Handoff Forms already use gate-level invocation. Updating the Reviewer Instruction to match practice is simpler and more context-efficient than splitting existing multi-aspect calls into per-aspect spawns.

2. **Context efficiency** (Constitution II): Aspects within a gate share target files. Reading CURRENT.md, ROADMAP.md, TODO.md once for 4 session aspects is more efficient than reading them 4 times.

3. **Structural vs Semantic separation**: `schema-validation` validates format compliance (field exists, correct type, valid enum). Semantic validation ("is this the right status at this point?") is already handled by session gate aspects (`plan-progress`, `phase-completion`). Mixing them in one aspect would violate separation of concerns.

4. **Orchestrator Pattern alignment** (ADR-006): Commands decide when and what to validate. The Reviewer validates what it's told. File scope differences between `/load` and `/checkpoint` are a command-level concern, handled by separate Request Forms pointing to the same generic aspect.

### Details

#### Architecture After Change

```
/load       ──→ Reviewer (background)  ──→ session gate: 4 aspects
            ──→ Reviewer (background)  ──→ documentation gate: schema-validation
                                           (parallel with session gate)

/checkpoint ──→ Reviewer (synchronous) ──→ session gate: phase-completion
            ──→ Reviewer (synchronous) ──→ documentation gate: schema-validation
```

#### Validation Responsibility Separation

| Validation Type | Question | Owner |
|-----------------|----------|-------|
| Structural (format) | Is `PLAN-001` a valid plan-id format? | `documentation:schema-validation` |
| Structural (enum) | Is `completed` a valid status for type `brief`? | `documentation:schema-validation` |
| Structural (constraint) | Is `session-id` a number >= 1? | `documentation:schema-validation` |
| Semantic (progress) | Does current-phase in CURRENT.md match ROADMAP.md? | `session:plan-progress` |
| Semantic (completion) | Are all Tasks in this Phase complete? | `session:phase-completion` |

#### Request Forms (New)

Two new Request Forms, one shared Response Form:

**`request:review:document-schema:session`** (for `/load`):
- Files: CURRENT.md, TODO.md, ROADMAP.md, HISTORY.md
- Gate: documentation
- Aspect: schema-validation

**`request:review:document-schema:checkpoint`** (for `/checkpoint`):
- Files: CURRENT.md, TODO.md, ROADMAP.md, HISTORY.md, PLAN.md, BRIEF.md, CHECKPOINT-SUMMARY.md
- Gate: documentation
- Aspect: schema-validation

**`response:review:document-schema`** (shared):
- Per-file validation results with pass/fail status and violation details

#### Spawn Model

| Command | Gate | Aspects | Mode | New? |
|---------|------|---------|------|------|
| `/load` | session | git-state, file-integrity, plan-progress, analysis-completeness | background | Existing |
| `/load` | documentation | schema-validation | background (parallel) | **New** |
| `/checkpoint` | session | phase-completion | synchronous | Existing |
| `/checkpoint` | documentation | schema-validation | synchronous | **New** |

#### `/save` Exclusion

`/save` does not invoke the Reviewer. The workflow guarantees that `/save` is always followed by either `/load` (next session) or `/checkpoint` (phase completion), both of which validate FrontMatter. This avoids redundant validation in an already context-constrained save operation.

---

## Consequences

### Positive

- FrontMatter schema validation is enforced as a safety net for all session documents
- Reviewer Instruction aligns with actual Handoff Form usage (resolves mismatch)
- Clear boundary: structural validation (`documentation` gate) vs semantic validation (`session` gate)
- Generic `schema-validation` aspect is reusable for any future document validation needs
- `/save` remains lightweight; validation cost is deferred to `/load` and `/checkpoint`

### Negative

- `/load` spawns 2 Reviewers instead of 1 (both background, parallel — marginal impact)
- `/checkpoint` adds a synchronous Reviewer call for documentation gate (additional wait time)
- Reviewer Instruction change requires existing implementations to be reviewed for consistency

### Neutral

- The `schema-validation` aspect definition (`core/gates/documentation/aspects/schema-validation.md`) is unchanged — it already defines the correct validation criteria
- Existing session gate aspects are unaffected

---

## Confirmation

- [ ] `reviewer.md` describes gate-level multi-aspect processing (not "ONE Aspect")
- [ ] `handoff.schema.md` contains `request:review:document-schema:session` form
- [ ] `handoff.schema.md` contains `request:review:document-schema:checkpoint` form
- [ ] `handoff.schema.md` contains `response:review:document-schema` form
- [ ] `load.md` spawns documentation gate Reviewer in parallel with session gate Reviewer
- [ ] `checkpoint.md` invokes documentation gate Reviewer (synchronous)
- [ ] `schema-validation` aspect is not modified (reused as-is)

---

## References

- [ADR-001: Schema-First Contract-Based Development](./001-schema-first-development.md) — Established schema-based validation principle
- [ADR-006: Orchestrator Pattern](./006-orchestrator-pattern.md) — Commands orchestrate, agents analyze
- `core/gates/documentation/aspects/schema-validation.md` — Structural validation criteria
- `core/gates/session/gate.md` — Session continuity validation
- `core/forms/handoff.schema.md` — Handoff form definitions
