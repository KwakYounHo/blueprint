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
dependencies: [../base.md]

scope: worker-specific
target-workers: [{worker-name}]
---
```

### Content Template

```markdown
# Constitution: {Worker Name}

## Worker-Specific Principles
[Principles unique to this Worker role - what they must always follow]

## Quality Standards
[Specific quality criteria for this Worker's output]

## Boundaries
[What this Worker should NOT do]
```

> **Note**: Role Definition, Responsibilities, Input/Output Requirements, Handoff Protocol belong in **Instruction** (`.claude/agents/*.md`), not Constitution. See [ADR-002](../../../../docs/adr/002-constitution-instruction-separation.md).

---

## Planned Constitutions

### orchestrator.md

| Section | Content |
|---------|---------|
| Principles | Coordination-specific rules |
| Standards | Minimal context retention, structured handoffs |
| Boundaries | No direct implementation, no code generation |

> Role, Responsibilities → defined in Instruction (`.claude/agents/orchestrator.md`)

### specifier.md

| Section | Content |
|---------|---------|
| Principles | Specification-specific rules |
| Standards | Complete specs, clear acceptance criteria |
| Boundaries | No implementation, no code |

> Role, Responsibilities, Handoff → defined in Instruction (`.claude/agents/specifier.md`)

### implementer.md

| Section | Content |
|---------|---------|
| Principles | Implementation-specific rules |
| Standards | Output quality criteria |
| Boundaries | Only assigned Task scope, no scope creep |

> Role, Responsibilities, Handoff → defined in Instruction (`.claude/agents/implementer.md`)

### reviewer.md

| Section | Content |
|---------|---------|
| Principles | Validation-specific rules |
| Standards | Objective assessment, actionable feedback |
| Boundaries | No implementation, no direct fixes |

> Role, Responsibilities, Handoff → defined in Instruction (`.claude/agents/reviewer.md`)

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

Instead of duplicating, reference base.md principles:

```markdown
## Boundaries
In addition to `../base.md#boundaries`:
- [Worker-specific boundary additions]
```

> **Note**: Code Standards are validated by Gate/Aspects, not defined in Constitution.

### Version Together

When updating base.md, review Worker constitutions for:
- Conflicts with new global principles
- Opportunities to move common patterns to base.md

---

## Related

- `../base.md` for global principles
- `../../../claude-agents/` for Worker behavior definitions
- `../../gates/` for validation criteria that Reviewers check
