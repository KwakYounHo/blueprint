---
type: implementation-notes
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [implementation, notes]
dependencies: [PLAN.md]

plan-id: "PLAN-{NNN}"
---

# Implementation Notes: {Plan Name}

> **Purpose**: Record deviations from plan, issues encountered, and learnings.
>
> **DO NOT** use for progress tracking - see ROADMAP.md and HISTORY.md.
> Only document items that differ from the original plan or require future reference.

> **Status Markers**: ISSUE entries use `[ACTIVE]` or `[RESOLVED]` heading markers
> for selective loading. `/load` reads only `[ACTIVE]` entries to preserve context.
> `/checkpoint` archives `[RESOLVED]` entries. New entries default to `[ACTIVE]`.

---

## Deviations from Plan

> Record when implementation differs from PLAN.md and why.

| Date | Phase/Task | Original Plan | Actual Implementation | Reason |
|------|------------|---------------|----------------------|--------|
| - | - | - | - | - |

---

## Issues Encountered

> Document blockers, bugs, or problems that affected implementation.

### [ACTIVE] ISSUE-001: {Issue Title}

**Discovered**: {{date}}
**Phase/Task**: {T-N.M}
**Status**: open | resolved
**Severity**: low | medium | high | critical

**Description**:
{What happened}

**Root Cause**:
{Why it happened}

**Resolution**:
{How it was fixed, or current workaround}

---

## Learnings

> Capture insights that should inform future plans or implementations.

### LEARN-001: {Learning Title}

**Context**: {When/where this was learned}

**Insight**:
{What was learned that should be remembered}

**Application**:
{How to apply this learning in future work}

---

## Environment Notes

> Document non-obvious configuration or setup requirements.

| Item | Value | Why Relevant |
|------|-------|--------------|
| - | - | - |
