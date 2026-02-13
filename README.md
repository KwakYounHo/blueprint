# Blueprint

> **Plan once, develop across sessions.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.5.0-blue.svg)](CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-alpha-orange.svg)]()
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet.svg)]()

[한국어](README.ko.md)

---

## Core Belief

**Context is Precious.**

Context efficiency lies at the foundation of all design decisions.

- Sufficient interaction during planning reduces correction costs during implementation
- Main Session context must be protected; complex analysis is delegated to SubAgents
- Context preservation across sessions is essential for large-scale development

---

## Features

### 1. Slash Commands

Control the workflow through intuitive commands:

| Command | Purpose |
|---------|---------|
| `/bplan` | Create a structured implementation plan |
| `/banalyze` | Analyze phase complexity for plan mode decisions |
| `/save` | Save session state for handoff |
| `/load` | Load previous session state |
| `/checkpoint` | Save milestone checkpoint |

### 2. Structured Plan

Decompose complex work into Phase/Task hierarchies:

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
| `project` | Project management (alias, setup, sync) |

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

---

## Installation

### Requirements

- Claude Code CLI
- `jq` (optional, for automatic hook configuration)

### Global Installation

```bash
git clone git@github.com:KwakYounHo/blueprint.git
cd blueprint
./install-global.sh
```

Installation targets:
- `~/.claude/agents/` - SubAgent definitions
- `~/.claude/skills/` - Blueprint skill
- `~/.claude/commands/` - Slash commands
- `~/.claude/hooks/` - Session hooks
- `~/.claude/blueprint/base/` - Core templates, schemas, constitutions

### Project Initialization

After installation, in each project:

```
1. Start a Claude Code session
2. Load the skill: /blueprint
3. Request: "Register this directory as a Blueprint project.
            Alias: 'my-project', Notes: 'Project description'"
```

### Bare Repo Support

For bare repo + worktree workflows:

```
1. Start a Claude Code session in any worktree
2. Load the skill: /blueprint
3. Request: "Register as Blueprint project. Alias: 'my-project', Type: bare"
4. Run: blueprint project setup (provisions config to all worktrees)
```

---

## Quick Start

### 1. Create Plan

```
/bplan
```

Create a structured plan (Phase/Task) through conversation with the user.

### 2. Session Continuity

| When | Command |
|------|---------|
| Before ending session | `/save` |
| Starting new session | `/load` |
| Phase completion | `/checkpoint` |

### 3. Typical Workflow

```
Session 1: /bplan → Development → /save
                              ↓
Session 2: /load → Continue development → /save
                              ↓
           (Phase complete) → /checkpoint
                              ↓
Session N: /load → Final Phase complete → /checkpoint → Done
```

---

## Installed Structure

After running `install-global.sh`:

```
~/.claude/
├── agents/                  # SubAgent definitions
├── commands/                # Slash commands (/bplan, /save, /load, /checkpoint)
├── hooks/                   # Session hooks
├── skills/                  # Blueprint skill (unified CLI)
│   └── blueprint/
├── settings.json            # SessionStart hook configured
└── blueprint/
    ├── base/                # Framework core (schemas, templates, gates)
    │   ├── constitutions/
    │   ├── forms/
    │   ├── front-matters/
    │   ├── gates/
    │   └── templates/
    └── projects/            # Per-project data (created on project init)
```

---

## Documentation

- [VISION.md](VISION.md) - The problem we solve and our approach
- [MISSION.md](MISSION.md) - What we build and how

---

## License

[MIT License](LICENSE)
