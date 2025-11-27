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

A **Workflow** is the container for a complete unit of work, answering four key questions:

| Concept | Question | File | Type |
|---------|----------|------|------|
| **Phase** | "Why" - Background and purpose | `spec.md` | Definition |
| **Stage** | "What" - Requirements to fulfill | `stage-*.md` | Definition |
| **Task** | "How" - Methods to achieve | `task-*.md` | Definition |
| **Progress** | "How much" - Completion tracking | `progress.md` | Task |

**Dependency Flow**: Phase → Stage → Task → Progress

### Validation Structure

| Term | Definition |
|------|------------|
| **Gate** | Validation checkpoint for quality assurance |
| **Code Gate** | Gate that validates code/artifact quality (`validates: code`) |
| **Document Gate** | Gate that validates document format compliance (`validates: document`) |
| **Aspect** | Area of expertise within a Gate (e.g., Code-Style, Schema Validation) |
| **Criteria** | Minimum requirements to pass an Aspect |

### Document Types

| Term | Definition |
|------|------------|
| **Constitution** | Principles that must be followed (global + per-Worker) |
| **Workflow** | Container for Phase, Stage, Task, and Progress; maps to a git branch |
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
│       ├── front-matters/               # FrontMatter Schema definitions
│       ├── constitutions/
│       ├── gates/
│       └── workflows/
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
    ├── front-matters/                   # FrontMatter Schema definitions
    ├── constitutions/
    ├── gates/
    │   ├── specification/
    │   ├── implementation/
    │   └── documentation/               # Parallel validation
    └── workflows/
        └── {workflow-id}/               # e.g., 001-initialize-documents
            ├── spec.md                  # Phase
            ├── stage-*.md               # Stages
            ├── task-*.md                # Tasks
            └── progress.md              # Progress
```

---

## Global Rules

### Front Matter (Required for all documents)

All documents MUST include YAML front matter:

```yaml
---
type: ""          # Document type (see below)
status: ""        # Document status (see below)
version: ""       # Semantic version (MAJOR.MINOR.PATCH)
created: ""       # YYYY-MM-DD
updated: ""       # YYYY-MM-DD
tags: []          # Search tags
dependencies: []  # Documents this depends on (upstream)
---
```

### Document Types (`type` field)

| Value | Description |
|-------|-------------|
| `schema` | FrontMatter schema definition |
| `constitution` | Principle definition |
| `worker` | Worker behavior definition |
| `gate` | Gate definition |
| `aspect` | Aspect with Criteria |
| `phase` | Workflow: Phase (spec.md) |
| `stage` | Workflow: Stage |
| `task` | Workflow: Task |
| `progress` | Workflow: Progress tracking |

### Status Values

**For Definition documents** (schema, constitution, gate, aspect, worker, phase, stage, task):

| Value | Meaning |
|-------|---------|
| `draft` | Work in progress, not yet active |
| `active` | Currently in effect |
| `deprecated` | No longer recommended, replacement exists |
| `archived` | Preserved for reference, not in effect |

**For Task documents** (progress):

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
    │    ├── Specifier Worker → spec.md, stage-*.md, task-*.md
    │    └── Review (required-gates: [specification, documentation])
    │        ├── Specification Gate ──┬── (parallel) ──┬── All must pass
    │        └── Documentation Gate ──┘                │
    │                                                  ▼
    │                                           Pass / Fail
    │
    ├──► Implementation Phase
    │    ├── Implementer Worker (per Task) → code
    │    ├── Progress tracking (progress.md updated)
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

## Workflow-Based Management

All work is organized by Workflow:

```
blueprint/workflows/
└── 001-workflow-name/                   # Workflow directory = Branch name
    ├── spec.md                          # Phase: Background and purpose
    ├── stage-01-requirement-analysis.md # Stage 1
    ├── stage-02-core-implementation.md  # Stage 2
    ├── task-01-01-gather-requirements.md    # Stage 1, Task 1
    ├── task-01-02-validate-scope.md         # Stage 1, Task 2
    ├── task-02-01-define-interfaces.md      # Stage 2, Task 1
    └── progress.md                      # Progress tracking
```

### Workflow ID Format

```
{number}-{short-description}
Example: 001-initialize-documents
```

### File Naming (WBS Style)

| Type | Pattern | Example |
|------|---------|---------|
| Phase | `spec.md` | `spec.md` |
| Stage | `stage-{SS}-{name}.md` | `stage-01-requirement-analysis.md` |
| Task | `task-{SS}-{TT}-{name}.md` | `task-01-02-validate-scope.md` |
| Progress | `progress.md` | `progress.md` |

### Branch Synchronization

```
Workflow Directory: blueprint/workflows/001-initialize-documents/
Branch Name:        001-initialize-documents
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
4. Start with `/specify` command to create your first Workflow

See `initializers/README.md` for detailed setup instructions.
