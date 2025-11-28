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
dependencies: []

# Constitution-specific
scope: global | worker-specific
target-workers: [all] | [specifier, implementer, ...]
---
```

### Content Structure (base.md)

```markdown
# Constitution: {Name}

## Project Identity [INFER]
[Vision and Mission - compressed for Worker context]

## Document Standards [FIXED]
[FrontMatter requirements, Schema compliance]

## Handoff Protocol [FIXED]
[Result reporting rules, required fields]

## Boundaries [FIXED]
[What is NOT allowed, framework constraints]

## Governance [FIXED]
[Amendment process, version policy]
```

> **Note**: Tech Stack, Code Standards, Quality Standards are validated by Gate/Aspects, not defined in base Constitution.

---

## Planned Files

### base.md (Global Constitution)

Applies to **all Workers**. Contains:

| Section | Annotation | Content |
|---------|------------|---------|
| Project Identity | `[INFER]` | Vision and Mission (compressed) |
| Document Standards | `[FIXED]` | FrontMatter requirements |
| Handoff Protocol | `[FIXED]` | Result reporting rules |
| Boundaries | `[FIXED]` | Framework constraints |
| Governance | `[FIXED]` | Amendment process |

> Tech Stack, Code Standards → handled by Gate/Aspects (see `../gates/`)

### workers/*.md (Worker-Specific)

| File | Applies To | Focus |
|------|------------|-------|
| `orchestrator.md` | Orchestrator | Delegation rules, state management |
| `specifier.md` | Specifier | Requirement analysis, spec format |
| `implementer.md` | Implementer | Coding standards, patterns |
| `reviewer.md` | Reviewer | Validation criteria, feedback format |

---

## Relationship with Instructions

Constitution and Instruction are clearly separated concepts (see [ADR-002](../../../docs/adr/002-constitution-instruction-separation.md)):

| | Constitution | Instruction |
|---|-------------|-------------|
| **Essence** | Law to obey | Responsibility to fulfill |
| **Nature** | Declarative (what should be) | Imperative (what to do, how) |
| **Content** | Principles, boundaries, quality standards | Role, workflow, output format |
| **Location** | `blueprint/constitutions/` | `.claude/agents/` |

```
Worker Runtime
├── Constitution (laws to obey)
│   └── blueprint/constitutions/base.md + workers/*.md
│
└── Instruction (responsibilities to fulfill)
    └── .claude/agents/*.md
```

**Worker** obeys Constitution while fulfilling Instruction.

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

## Template Annotations

Constitution templates use a four-level annotation system (`[FIXED]`, `[INFER]`, `[DECIDE]`, `[ADAPT]`) for LLM-guided initialization. See [ADR-003](../../../docs/adr/003-template-annotation-system.md) for details.

---

## Related

- `./workers/` for Worker-specific Constitution details
- `../../claude-agents/` for Instruction (Worker behavior) definitions
- `../gates/` for validation criteria
- [ADR-002](../../../docs/adr/002-constitution-instruction-separation.md) for Constitution/Instruction separation
- [ADR-003](../../../docs/adr/003-template-annotation-system.md) for template annotation system
