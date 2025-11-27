# Constitutions

> Principles that Workers must follow. The "laws" of the framework.

---

## Purpose

Constitutions define **what principles must be followed**. They are:

1. **Declarative**: State what should be, not how to do it
2. **Hierarchical**: Global (base) + Worker-specific
3. **Enforceable**: Reviewers validate compliance

---

## Background

### Why "Constitution"?

From Constitutional AI research:
> "Embedding ethical principles, rules, and constraints directly into decision-making processes"

A Constitution is not instructions—it's **principles**. Workers reference Constitutions to understand:
- What rules apply to them
- What quality standards to meet
- What boundaries not to cross

### Context Isolation Benefit

Research shows role-specific instructions outperform monolithic prompts:
- Single agent with all rules → Confusion, hallucination
- Specialized agents with focused rules → Better performance

By separating Constitutions per Worker, each Worker loads only relevant principles.

---

## Directory Structure

```
constitutions/
├── README.md                    # This file
├── base.md                      # Global principles (all Workers)
└── workers/                     # Worker-specific principles
    ├── README.md
    ├── orchestrator.md
    ├── specifier.md
    ├── implementer.md
    └── reviewer.md
```

---

## Loading Strategy

```
Orchestrator invoked:
  → Load: base.md + workers/orchestrator.md

Specifier invoked:
  → Load: base.md + workers/specifier.md

Implementer invoked:
  → Load: base.md + workers/implementer.md

Reviewer invoked:
  → Load: base.md + workers/reviewer.md
```

---

## File Structure

### Front Matter

```yaml
---
type: constitution
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [principles, ...]
related: []

# Constitution-specific
scope: global | worker-specific
target-workers: [all] | [specifier, implementer, ...]
---
```

### Content Structure

```markdown
# Constitution: {Name}

## Core Principles
[Fundamental rules that must always be followed]

## Quality Standards
[Measurable criteria for quality]

## Boundaries
[What is NOT allowed, what to avoid]

## Patterns
[Recommended patterns to follow]
References to existing code patterns if applicable.

## Exceptions
[When rules can be relaxed and under what conditions]
```

---

## Planned Files

### base.md (Global Constitution)

Applies to **all Workers**. Contains:

| Section | Content |
|---------|---------|
| Project Identity | Project purpose, domain |
| Tech Stack | Languages, frameworks, versions |
| Dependencies | Allowed/forbidden packages |
| Code Standards | Naming, formatting, structure |
| Communication | Language rules, documentation style |

### workers/*.md (Worker-Specific)

| File | Applies To | Focus |
|------|------------|-------|
| `orchestrator.md` | Orchestrator | Delegation rules, state management |
| `specifier.md` | Specifier | Requirement analysis, spec format |
| `implementer.md` | Implementer | Coding standards, patterns |
| `reviewer.md` | Reviewer | Validation criteria, feedback format |

---

## Relationship with Workers

```
.claude/agents/specifier.md          (HOW to behave - system prompt)
        │
        │ references
        ▼
blueprint/constitutions/base.md      (WHAT principles - global)
        +
blueprint/constitutions/workers/specifier.md  (WHAT principles - specific)
```

**Worker file** = Behavior definition (system prompt)
**Constitution file** = Principles to follow (rules)

---

## Status Values

| Status | Meaning |
|--------|---------|
| `draft` | Work in progress, not enforced |
| `active` | Currently in effect, must be followed |
| `deprecated` | Being phased out, replacement exists |
| `archived` | Historical reference, not enforced |

---

## Validation

Reviewers check compliance with Constitutions:

1. Reviewer loads relevant Constitutions
2. Compares artifact against principles
3. Reports violations in review

If a Constitution is `archived`, Reviewer should:
1. Stop validation
2. Report to Orchestrator for confirmation

---

## Related

- `./workers/` for Worker-specific Constitution details
- `../../claude-agents/` for Worker behavior definitions
- `../gates/` for validation criteria
