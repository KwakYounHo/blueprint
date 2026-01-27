---
type: adr
status: proposed
version: 0.0.1
created: {{date}}
updated: {{date}}
tags: [{{tags}}]
dependencies: []

deciders: [{{names}}]
supersedes: []
superseded-by: []
---

# ADR-NNN: {{Title}}

<!--
=============================================================================
TEMPLATE RULES - READ BEFORE WRITING
=============================================================================

1. REQUIRED SECTIONS (##) must always be present:
   - Context
   - Decision
   - Consequences

2. CONDITIONALLY REQUIRED SECTIONS:
   - If content exists for a section, that section MUST be included
   - Do NOT omit sections because they seem redundant
   - Do NOT summarize or compress content to fit the template

3. EXTENSION PRINCIPLE:
   - This template defines MINIMUM structure
   - Add subsections (###, ####) freely as needed
   - Add tables, diagrams, code blocks as needed
   - The goal is complete documentation, not template conformance

4. ANTI-PATTERNS TO AVOID:
   - Omitting "Considered Options" because "there was only one choice"
   - Merging "Problem" into "Context" to save space
   - Skipping "Negative Consequences" because the decision was good
   - Removing "References" because links might break

=============================================================================
-->

## Context

<!--
REQUIRED: Why was this decision needed?

Include background, current state, and what triggered the need for a decision.
-->

### Current State

<!--
CONDITIONAL: Include if describing an existing system or architecture.
Diagrams (ASCII or Mermaid) are encouraged.
-->

```
[Current architecture diagram]
```

### Problem

<!--
CONDITIONAL: Include if the problem is distinct from context.
What specific issue needs to be solved?
-->

### Requirements

<!--
CONDITIONAL: Include if explicit requirements or constraints exist.
What must the solution satisfy?
-->

---

## Considered Options

<!--
CONDITIONAL: Include if multiple alternatives were evaluated.
Even if one option was obvious, documenting why others were rejected is valuable.
-->

| Option | Description |
|--------|-------------|
| A. {{Option A}} | {{Description}} |
| B. {{Option B}} | {{Description}} |

### Option A: {{Option A}}

**Pros:**
- ...

**Cons:**
- ...

### Option B: {{Option B}}

**Pros:**
- ...

**Cons:**
- ...

---

## Decision

<!--
REQUIRED: What was decided?

This is the core of the ADR. Be specific and unambiguous.
-->

We will use **{{chosen option}}**.

### Rationale

<!--
CONDITIONAL: Include if the decision needs justification.
Why was this option chosen over alternatives?
-->

### Details

<!--
CONDITIONAL: Include if implementation specifics exist.
This section can be freely extended with subsections.

Examples of what might go here:
- Directory structure
- Configuration examples
- Workflow diagrams
- API contracts
- Network topology
-->

---

## Consequences

<!--
REQUIRED: What are the results of this decision?

At least one of Positive, Negative, or Neutral must be included.
If any category has relevant content, it MUST be included.
-->

### Positive

<!--
CONDITIONAL: Include if there are positive outcomes.
-->

- ...

### Negative

<!--
CONDITIONAL: Include if there are negative outcomes or tradeoffs.
Do NOT skip this section just because the decision seems good.
-->

- ...

### Neutral

<!--
CONDITIONAL: Include if there are neutral observations.
Things that change but are neither good nor bad.
-->

- ...

---

## Confirmation

<!--
CONDITIONAL: Include if there's a way to verify the decision was implemented correctly.

Examples:
- Tests that should pass
- Metrics to monitor
- Review checklist
-->

---

## References

<!--
CONDITIONAL: Include if external sources, related ADRs, or documentation exist.
-->

- [Related ADR](./NNN-related.md)
- [External Documentation](https://example.com)
