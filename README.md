# Agent Orchestration Framework

> A reusable framework for orchestrating LLM agents with structured workflows, quality gates, and context-efficient multi-agent patterns.

---

## Overview

> See [VISION.md](./VISION.md) for the problem we're solving and [MISSION.md](./MISSION.md) for our approach.

This framework provides a **structure** and **schema** for managing LLM-based agent workflows. It is designed to:

1. **Preserve Context Window**: Main session (Orchestrator) delegates work to specialized Workers
2. **Ensure Quality**: Gate-based validation with aspect-specific Reviewers
3. **Maintain Consistency**: Constitutions define principles that Workers must follow
4. **Enable Reusability**: One framework, multiple projects

---

## Terminology

### Agent Hierarchy

| Term | Definition |
|------|------------|
| **Agent** | Top-level concept: LLM + Tools + Memory |
| **Orchestrator** | Special Agent that coordinates Workers, manages state, and handles user decisions |
| **Worker (=Subagent)** | Agent that receives delegated tasks and executes them |

### Worker Types

| Worker | Role |
|--------|------|
| **Specifier** | Analyzes requirements, creates Specification documents |
| **Implementer** | Implements code based on Tasks |
| **Reviewer** | Validates artifacts against Gate Criteria |

### Workflow Structure

| Term | Definition |
|------|------------|
| **Phase** | Major stage in workflow lifecycle (e.g., Specification, Implementation) |
| **Stage** | Logical grouping within a Phase (e.g., Package Initialize, Configuration) |
| **Task** | Concrete unit of work, dynamically created during execution |

### Validation Structure

| Term | Definition |
|------|------------|
| **Gate** | Validation checkpoint for quality assurance |
| **Phase Gate** | Sequential gate at phase boundaries (Specification, Implementation) |
| **Document Gate** | Parallel gate triggered on document changes (Documentation) |
| **Aspect** | Area of expertise within a Gate (e.g., Code-Style, Schema Validation) |
| **Criteria** | Minimum requirements to pass an Aspect |

### Document Types

| Term | Definition |
|------|------------|
| **Constitution** | Principles that must be followed (global + per-Worker) |
| **Feature** | Container for related Artifacts; maps to a git branch |
| **Artifact** | Output produced by Workers (spec.md, task.md, review.md, code, etc.) |
| **Handoff** | Structured format for inter-agent communication (Worker↔Orchestrator↔Reviewer) |

---

## Directory Structure

### Framework (this repository)

```
agent-docs/
├── README.md                            # This file
├── templates/
│   ├── claude-agents/                   # → .claude/agents/ (Claude Code integration)
│   └── blueprint/                       # → blueprint/ (Framework core)
│       ├── schemas/                     # Document format definitions
│       ├── constitutions/
│       ├── gates/
│       ├── workflows/
│       └── features/
├── initializers/                        # Initialization scripts
└── commands/                            # Claude Code slash commands
```

### Project Instance (after initialization)

```
target-project/
├── .claude/
│   └── agents/                          # Claude Code Workers
│       ├── orchestrator.md
│       ├── specifier.md
│       ├── implementer.md
│       └── reviewer.md
└── blueprint/                           # Framework core
    ├── schemas/                         # Document format definitions
    ├── constitutions/
    ├── gates/
    │   ├── specification/
    │   ├── implementation/
    │   └── documentation/               # Parallel validation
    ├── workflows/
    └── features/
```

---

## Global Rules

### Front Matter (Required for all documents)

All documents MUST include YAML front matter:

```yaml
---
type: ""          # Document type (see below)
status: ""        # Document status (see below)
created: ""       # YYYY-MM-DD
updated: ""       # YYYY-MM-DD
tags: []          # Search tags
related: []       # Related document paths
---
```

### Document Types (`type` field)

| Value | Description |
|-------|-------------|
| `constitution` | Principle definition |
| `worker` | Worker behavior definition |
| `gate` | Gate definition |
| `aspect` | Aspect with Criteria |
| `phase` | Phase definition |
| `stage` | Stage definition |
| `feature` | Feature metadata |
| `artifact` | Generated output (spec, plan, task, review) |

### Status Values

**For definition documents** (Constitution, Gate, Worker, etc.):

| Value | Meaning |
|-------|---------|
| `draft` | Work in progress, not yet active |
| `active` | Currently in effect |
| `deprecated` | No longer recommended, replacement exists |
| `archived` | Preserved for reference, not in effect |

**For task documents** (Task, Feature):

| Value | Meaning |
|-------|---------|
| `pending` | Not yet started |
| `in-progress` | Currently being worked on |
| `completed` | Successfully finished |
| `failed` | Failed, needs retry or decision |

---

## Workflow Overview

```
User Request
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│ ORCHESTRATOR                                                │
│ - Receives request                                          │
│ - Delegates to appropriate Worker                           │
│ - Sends documents to Reviewer with required-gates           │
│ - Manages state and user confirmations                      │
└─────────────────────────────────────────────────────────────┘
    │
    ├──► Specification Phase
    │    ├── Specifier Worker → spec.md, plan.md
    │    └── Review (required-gates: [specification, documentation])
    │        ├── Specification Gate ──┬── (parallel) ──┬── All must pass
    │        └── Documentation Gate ──┘                │
    │                                                  ▼
    │                                           Pass / Fail
    │
    ├──► Implementation Phase
    │    ├── Implementer Worker (per Task) → code
    │    └── Review (required-gates: [implementation, documentation])
    │        ├── Implementation Gate ──┬── (parallel) ──┬── All must pass
    │        └── Documentation Gate ───┘                │
    │                                                   ▼
    │                                            Pass / Fail
    │
    └──► User Confirmation
         └── Accept / Request Changes
```

**Note**: Multiple Gates run in parallel during review, but all required Gates must pass for the review to succeed.

---

## Feature-Based Artifact Management

All Artifacts are grouped by Feature:

```
blueprint/features/
└── 001-feature-name/              # Feature directory = Branch name
    ├── feature.md                 # Feature metadata
    ├── spec.md                    # Specification
    ├── plan.md                    # Implementation plan
    ├── tasks/                     # Task documents
    │   ├── task-001.md
    │   └── task-002.md
    └── reviews/                   # Review results
        ├── spec-gate-review.md
        └── impl-gate-review.md
```

### Feature ID Format

```
{number}-{short-description}
Example: 001-statement-split-merge
```

### Branch Synchronization

```
Feature Directory: blueprint/features/001-statement-split-merge/
Branch Name:       feature/001-statement-split-merge
```

---

## References

### Project Background

- [VISION.md](./VISION.md) - Problem statement and project goals
- [MISSION.md](./MISSION.md) - Implementation approach and guiding principles

### Key Sources

- [Anthropic - Building Effective AI Agents](https://www.anthropic.com/research/building-effective-agents)
- [Anthropic - Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Claude Code Subagents Documentation](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
- [LangChain - Context Engineering for Agents](https://blog.langchain.com/context-engineering-for-agents/)

---

## Getting Started

1. Run initializer to set up project structure
2. Configure Constitutions for your project
3. Define Gates and Criteria
4. Start with `/specify` command to create your first Feature

See `initializers/README.md` for detailed setup instructions.
