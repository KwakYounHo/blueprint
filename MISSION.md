# Mission

## What We Build

A **user interaction-centered** session management framework for Claude Code that:

1. Establishes accurate plans through dialogue with the user
2. Preserves context across sessions to maintain development continuity
3. Provides workflow control through Slash Commands

## How We Achieve It

### 1. Slash Commands

Users directly control the workflow through intuitive commands:

| Command | Purpose |
|---------|---------|
| `/plan` | Create a structured implementation plan |
| `/save` | Save session state for handoff |
| `/load` | Load previous session state |
| `/checkpoint` | Save milestone checkpoint |

### 2. Structured Plan

Decompose complex work into structured Phase/Task hierarchies:

```
Plan
├── Phase 1: Foundation
│   ├── Task 1.1: Environment setup
│   └── Task 1.2: Basic structure
├── Phase 2: Core Implementation
│   └── ...
└── Phase 3: Finalization
    └── ...
```

### 3. Session Management

Preserve development context beyond session boundaries:

```
Session 1 → /save → [External Storage] → /load → Session 2

├── Background, purpose, approach preserved
├── Continuity maintained regardless of session reset
└── Essential for large-scale development
```

### 4. Blueprint Skill

Unified CLI access to framework capabilities:

| Submodule | Purpose |
|-----------|---------|
| `aegis` | Gate validation and aspects |
| `forma` | Document templates |
| `frontis` | FrontMatter schemas |
| `hermes` | Handoff forms |
| `lexis` | Constitution viewer |
| `plan` | Plan directory and listing |
| `polis` | Agent registry |
| `project` | Project alias management |

### 5. Quality Gates

Validate at phase boundaries through structured criteria:

```
Phase N → [Gate Validation] → Phase N+1
           ├── Aspect 1
           ├── Aspect 2
           └── ...
```

### 6. SubAgent Delegation

Protect Main Session context by delegating complex tasks:

| Agent | Role |
|-------|------|
| `phase-analyzer` | Multi-dimensional complexity analysis |
| `reviewer` | Quality validation |

## What We Don't Do

| Avoid | Instead | Rationale |
|-------|---------|-----------|
| Automated implementation chains | User controls implementation | Spec completeness limitations |
| Pursuing perfect specifications | Reflect intent through interaction | Practical difficulty |
| Assuming single-session completion | Design for session continuity | Large-scale development reality |
| Complex agent orchestration | Simple command-based workflow | Maintainability and clarity |

## Guiding Principles

### Context is Precious

The foundational principle underlying all decisions.
Main Session context is a scarce resource that must be protected.

### Start Simple

Only add complexity when simpler solutions fall short.
Resist the urge to over-engineer.

### User in Control

The user is the primary agent of the workflow.
The framework supports and enables, not automates and replaces.

### Session Continuity

Design for development that spans multiple sessions.
Context preservation is not optional—it's essential.

### Isolation by Design

SubAgents operate in isolated context to protect Main Session.
Complex analysis and validation are delegated, not executed in-place.

### Quality at Boundaries

Validate at phase transitions, not continuously.
Boundary validation is more efficient and less disruptive.

### Practical over Theoretical

Patterns must work in real Claude Code sessions.
A working simple solution beats an elegant complex one.
