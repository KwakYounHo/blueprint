# Gates

> Validation checkpoints for quality assurance. Each Gate contains Aspects with Criteria.

---

## Purpose

Gates are **quality checkpoints** that validate work artifacts:

### Phase Gates (Sequential)
1. **Specification Gate**: Validates specs before implementation
2. **Implementation Gate**: Validates code before completion

### Document Gates (Parallel)
3. **Documentation Gate**: Validates document format on every creation/modification

Gates ensure quality is maintained throughout the workflow.

---

## Background

### Why Gates?

From DevOps Quality Gate patterns:
> "A Quality Gate is a checkpoint where specific quality criteria must be met before progressing"

Gates prevent:
- Incomplete specifications reaching implementation
- Low-quality code reaching production
- Errors propagating through phases
- Invalid document formats causing confusion

### Gate Classification

| Type | Focus | Examples |
|------|-------|----------|
| **Phase Gate** | Work quality | Specification, Implementation |
| **Document Gate** | Format quality | Documentation |

**Multiple Gates can run in parallel**, but **all required Gates must pass** for the review to succeed.

### Gate-Aspect-Criteria Hierarchy

```
Gate (Phase boundary checkpoint)
├── Aspect (Area of expertise)
│   └── Criteria (Specific checks)
└── Aspect
    └── Criteria
```

Each **Aspect** is validated by a dedicated **Reviewer Worker**.

---

## Directory Structure

```
gates/
├── README.md                    # This file
│
├── specification/               # Specification Phase Gate
│   ├── gate.md                  # Gate metadata
│   └── aspects/
│       ├── completeness.md      # Aspect: Requirements completeness
│       └── feasibility.md       # Aspect: Technical feasibility
│
├── implementation/              # Implementation Phase Gate
│   ├── gate.md                  # Gate metadata
│   └── aspects/
│       ├── code-style.md        # Aspect: Code style compliance
│       ├── architecture.md      # Aspect: Architecture principles
│       └── component.md         # Aspect: Component design
│
└── documentation/               # Documentation Gate (parallel)
    ├── gate.md                  # Gate metadata
    └── aspects/
        └── schema-validation.md # Aspect: Front matter schema compliance
```

---

## Gate Definition (`gate.md`)

### Front Matter

```yaml
---
type: gate
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [gate, {gate-name}]
related: [../../workflows/phases.md]

# Gate-specific
gate-type: phase | document
trigger: phase-boundary | document-change
pass-condition: all-aspects | percentage
pass-threshold: 100  # If percentage
---
```

### Gate Type Differences

| Field | Phase Gate | Document Gate |
|-------|------------|---------------|
| `gate-type` | `phase` | `document` |
| `trigger` | `phase-boundary` | `document-change` |
| `related` | workflows/phases.md | `../schemas/` |

### Content Structure

```markdown
# Gate: {Phase} Gate

## Description
[Purpose of this gate]

## When Applied
[At what point in the workflow]

## Aspects
| Aspect | Reviewer | Description |
|--------|----------|-------------|
| completeness | Completeness Reviewer | ... |
| feasibility | Feasibility Reviewer | ... |

## Pass Condition
[all-aspects | X% of criteria]

## On Pass
[What happens when gate passes]

## On Failure
[What happens when gate fails]
```

---

## Aspect Definition

### Front Matter

```yaml
---
type: aspect
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [aspect, {gate-name}, {aspect-name}]
related: [../gate.md]

# Aspect-specific
gate: specification | implementation | documentation
reviewer: {reviewer-type}
---
```

### Content Structure

```markdown
# Aspect: {Name}

## Description
[What this aspect validates]

## Criteria

### Required (Must Pass)
- [ ] Criterion 1
- [ ] Criterion 2

### Recommended (Should Pass)
- [ ] Criterion 3
- [ ] Criterion 4

## Validation Method
[How the Reviewer should check each criterion]

## Feedback Format
[How to report findings]
```

---

## Planned Gates

### Phase Gates

#### Specification Gate

| Aspect | Focus | Criteria Examples |
|--------|-------|-------------------|
| **Completeness** | Are all requirements captured? | Functional reqs, Non-functional reqs, Edge cases |
| **Feasibility** | Is it technically achievable? | Tech stack compatibility, Resource estimation |

#### Implementation Gate

| Aspect | Focus | Criteria Examples |
|--------|-------|-------------------|
| **Code-Style** | Does code follow standards? | Naming, Formatting, Comments |
| **Architecture** | Does structure follow principles? | Single responsibility, Dependency direction |
| **Component** | Is component design sound? | Props design, Reusability, Composition |

### Document Gates

#### Documentation Gate

| Aspect | Focus | Criteria Examples |
|--------|-------|-------------------|
| **Schema Validation** | Does front matter conform to schema? | Required fields, Valid status values, Correct types |

---

## Reviewer-Aspect Relationship

Each Aspect maps to a Reviewer instance:

```
Implementation Gate
├── Aspect: code-style ────► Reviewer Worker (Code-Style)
├── Aspect: architecture ──► Reviewer Worker (Architecture)
└── Aspect: component ─────► Reviewer Worker (Component)
```

Reviewers can run in **parallel** since Aspects are independent.

---

## Validation Flow

### Overview

```
Worker (Specifier/Implementer)
        │
        ▼
    Document Created (e.g., spec.md)
        │
        ▼
    Handoff to Orchestrator
        │
        ▼
┌─────────────────────────────────────────────────────────────┐
│ ORCHESTRATOR                                                │
│                                                             │
│ Handoff to Reviewer:                                        │
│   document: spec.md                                         │
│   required-gates: [specification, documentation]            │
└─────────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────────┐
│ REVIEWER                                                    │
│                                                             │
│   ┌───────────────────┐       ┌───────────────────┐        │
│   │ Specification     │       │ Documentation     │        │
│   │ Gate              │ 병렬   │ Gate              │        │
│   │ ├─ Completeness   │       │ └─ Schema         │        │
│   │ └─ Feasibility    │       │    Validation     │        │
│   └─────────┬─────────┘       └─────────┬─────────┘        │
│             │                           │                   │
│             └─────────────┬─────────────┘                   │
│                           ▼                                 │
│                   Aggregate Results                         │
│                           │                                 │
│            ┌──────────────┴──────────────┐                  │
│            ▼                             ▼                  │
│       All Pass                      Any Fail                │
│            │                             │                  │
│            ▼                             ▼                  │
│    Handoff: Pass                 Handoff: Fail + Details    │
└─────────────────────────────────────────────────────────────┘
        │
        ▼
    Orchestrator decides next step
```

### Key Points

- **Parallel Execution**: Multiple Gates run simultaneously
- **All Must Pass**: Every required Gate must pass for overall success
- **Aggregated Result**: Reviewer combines all Gate results into single Handoff

---

## Handoff Structure

### Orchestrator → Reviewer

```yaml
handoff:
  action: review
  document: blueprint/features/001-auth/spec.md
  required-gates:
    - specification
    - documentation
  context:
    feature-id: "001-auth"
    phase: specification
```

| Field | Required | Description |
|-------|----------|-------------|
| `action` | Yes | Always `review` for gate validation |
| `document` | Yes | Path to document being reviewed |
| `required-gates` | Yes | List of gates that must all pass |
| `context` | No | Additional context for reviewers |

### Reviewer → Orchestrator

```yaml
handoff:
  status: fail
  document: blueprint/features/001-auth/spec.md
  gates:
    specification:
      status: pass
      aspects:
        completeness:
          status: pass
          criteria: [...]
        feasibility:
          status: pass
          criteria: [...]
    documentation:
      status: fail
      aspects:
        schema-validation:
          status: fail
          violations:
            - field: status
              expected: "pending | in-progress | completed | failed"
              actual: "active"
              suggestion: "Use 'in-progress' for artifact documents"
  summary: "Documentation Gate failed: invalid status value for artifact"
  needs-fix: true
```

| Field | Required | Description |
|-------|----------|-------------|
| `status` | Yes | `pass` or `fail` (overall result) |
| `document` | Yes | Path to reviewed document |
| `gates` | Yes | Per-gate results with aspects |
| `summary` | Yes | Human-readable summary |
| `needs-fix` | Yes | Whether document requires modification |

---

## Status Values

| Status | Meaning |
|--------|---------|
| `draft` | Gate/Aspect being defined, not enforced |
| `active` | Currently in effect, must pass |
| `deprecated` | Being phased out |
| `archived` | Historical reference |

---

## Best Practices

### Keep Criteria Specific

Bad: "Code should be clean"
Good: "Functions must be under 50 lines"

### Make Criteria Verifiable

Bad: "Architecture should be good"
Good: "No circular dependencies between modules"

### Balance Strictness

- Too strict → Development slows
- Too loose → Quality suffers
- Start stricter, relax based on experience

---

## Related

- `./documentation/` for Documentation Gate (parallel validation)
- `../workflows/` for Phase definitions
- `../schemas/` for schema definitions (Documentation Gate)
- `../constitutions/workers/reviewer.md` for Reviewer principles
- `../../claude-agents/` for Reviewer behavior definition
