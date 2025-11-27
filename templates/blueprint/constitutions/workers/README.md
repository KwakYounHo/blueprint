# Worker Constitutions

> Worker-specific principles. Each Worker loads base.md + their specific constitution.

---

## Purpose

Worker-specific Constitutions define **principles unique to each Worker role**:

- **Orchestrator**: Delegation rules, state management principles
- **Specifier**: Requirement analysis rules, specification standards
- **Implementer**: Coding standards, implementation patterns
- **Reviewer**: Validation criteria, feedback format

---

## Background

### Why Separate per Worker?

Research on Context Pollution shows:
- Long prompts with mixed concerns → Performance degradation
- Focused, role-specific instructions → Better results

From Chroma Research:
> "Models perform worse when context preserves a logical flow of ideas"
> Tool calling efficiency can drop up to 70% with irrelevant context

### Loading Strategy

Each Worker loads only what they need:

```
Specifier Context:
├── base.md (~500 tokens)           # Global principles
└── workers/specifier.md (~800 tokens)  # Specifier-specific
Total: ~1,300 tokens (vs 3,000+ if all loaded)
```

---

## Directory Structure

```
workers/
├── README.md               # This file
├── orchestrator.md         # Orchestrator principles
├── specifier.md            # Specifier principles
├── implementer.md          # Implementer principles
└── reviewer.md             # Reviewer principles
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
tags: [worker, {worker-name}]
related: [../base.md]

scope: worker-specific
target-workers: [{worker-name}]
---
```

### Content Template

```markdown
# Constitution: {Worker Name}

## Role Definition
[Clear statement of this Worker's purpose]

## Core Responsibilities
[What this Worker is responsible for]

## Quality Standards
[Specific quality criteria for this Worker's output]

## Input Requirements
[What this Worker expects to receive]

## Output Requirements
[What this Worker must produce]

## Boundaries
[What this Worker should NOT do]

## Handoff Protocol
[How to communicate results back to Orchestrator]
```

---

## Planned Constitutions

### orchestrator.md

| Section | Content |
|---------|---------|
| Role | Coordinate Workers, manage state, handle user decisions |
| Responsibilities | Task delegation, result aggregation, confirmation requests |
| Standards | Minimal context retention, structured handoffs |
| Boundaries | No direct implementation, no code generation |
| Handoff | N/A (top-level coordinator) |

### specifier.md

| Section | Content |
|---------|---------|
| Role | Analyze requirements, create specifications |
| Responsibilities | Requirement extraction, feasibility check, Stage/Task breakdown |
| Standards | Complete specs, clear acceptance criteria |
| Boundaries | No implementation, no code |
| Handoff | spec.md, plan.md with structured summary |

### implementer.md

| Section | Content |
|---------|---------|
| Role | Implement code based on Tasks |
| Responsibilities | Code generation, test writing, documentation |
| Standards | Follow base.md coding standards, pass linters |
| Boundaries | Only assigned Task scope, no scope creep |
| Handoff | File paths, changes summary |

### reviewer.md

| Section | Content |
|---------|---------|
| Role | Validate artifacts against Criteria |
| Responsibilities | Check compliance, provide feedback |
| Standards | Objective assessment, actionable feedback |
| Boundaries | No implementation, no direct fixes |
| Handoff | Pass/Fail status, detailed findings |

---

## Relationship Diagram

```
base.md (Global)
    │
    ├──────────────────┬──────────────────┬──────────────────┐
    ▼                  ▼                  ▼                  ▼
orchestrator.md    specifier.md    implementer.md    reviewer.md
    │                  │                  │                  │
    ▼                  ▼                  ▼                  ▼
.claude/agents/    .claude/agents/    .claude/agents/    .claude/agents/
orchestrator.md    specifier.md       implementer.md     reviewer.md
(behavior)         (behavior)         (behavior)         (behavior)
```

---

## Best Practices

### Keep Focused

Each constitution should be:
- **Short**: ~500-1000 tokens
- **Specific**: Only principles relevant to this Worker
- **Non-overlapping**: Don't repeat base.md content

### Use References

Instead of duplicating, reference:

```markdown
## Coding Standards
Follow all standards defined in `../base.md#code-standards`.
Additionally, for this Worker:
- [Worker-specific additions]
```

### Version Together

When updating base.md, review Worker constitutions for:
- Conflicts with new global principles
- Opportunities to move common patterns to base.md

---

## Related

- `../base.md` for global principles
- `../../../claude-agents/` for Worker behavior definitions
- `../../gates/` for validation criteria that Reviewers check
