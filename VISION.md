# Vision

## The Problem

Fundamental limitations encountered in LLM-based development:

### 1. Session Discontinuity

Large-scale development inevitably spans multiple sessions.
Each time a session resets, the development context—background, purpose, and progress—is lost.

### 2. Cost of Inaccurate Plans

Automated specification writing struggles to accurately reflect user intent.
The cost of corrections frequently exceeds the cost of planning itself.

### 3. Limitations of Automated Implementation Chains

"Deterministic code generation" through perfect specifications,
combined with automated implementation chains, is realistically unattainable.

## The Vision

> **Plan once, develop across sessions.**

We pursue the following:

1. **Accurate Plans** - Precisely reflect user intent through sufficient interaction
2. **Session Continuity** - Guarantee development continuity beyond session boundaries
3. **Continuous Development** - Enable large-scale development through context preservation

## Core Belief

**Context is Precious.**

Context efficiency lies at the foundation of all design decisions.

- Sufficient interaction during planning reduces correction costs during implementation
- Main Session context must be protected; complex analysis is delegated to SubAgents
- Context preservation across sessions is essential for large-scale development
