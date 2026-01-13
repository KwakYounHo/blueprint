---
type: memory
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [memory, architecture, user-level, migration]
dependencies: []

plan-id: "PLAN-003"
source-discussion: "User proposal for user-level Blueprint deployment"
session-count: 1
last-session: 2026-01-13
---

# Memory: User-Level Blueprint Migration

## CRITICAL: Specification Principles

### Implementer Rules
- **Deterministic**: Any Implementer MUST produce identical code
- **No Ambiguity**: If two interpretations possible, Spec is incomplete
- **Specifier's Job**: Eliminate all ambiguous points before Spec completion

---

## Background

User proposes changing Blueprint's deployment strategy from **project-level** to **user-level** (`~/.claude/`). This fundamentally changes how the framework is distributed and used.

### Current Architecture
```
Target Project/
├── .claude/           ← Claude Code config (copied from core/claude)
│   ├── agents/
│   ├── skills/
│   └── commands/
└── blueprint/         ← Framework data (copied from core/*)
    ├── constitutions/
    ├── forms/
    ├── front-matters/
    ├── gates/
    └── templates/
```

### Proposed Architecture
```
~/.claude/
├── agents/            ← Shared across ALL projects (one-time install)
├── skills/
├── commands/
└── blueprint/
    └── {project-name}/   ← Per-project instance
        ├── constitutions/
        ├── forms/
        ├── front-matters/
        ├── gates/
        └── templates/
```

### Goals
- Enable Blueprint to work across multiple projects from a single installation
- Maintain project-specific customization (Base Constitution, etc.)
- Simplify installation process (install once, use everywhere)
- Preserve context efficiency principles

---

## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | Separate `core/claude` from other `core/*` in install flow | Claude config is shared; framework data is per-project | 1 |
| D-002 | Use `$CLAUDE_PROJECT_DIR` for project identification | Claude Code provides this env var to hooks; reliable | 1 |
| D-003 | Error with init instructions for uninitialized projects | Explicit behavior is more predictable than auto-magic | 1 |
| D-004 | Full path → dirname conversion for project naming | Absolute path is unique; no collision possible | 1 |
| D-005 | Clean break - no backwards compatibility | Simpler implementation; avoid legacy code paths | 1 |
| D-006 | All blueprint data in `~/.claude/blueprint/{project}/` including plans | Centralized management; consistent location | 1 |

---

## [DECIDE] Items

| ID | Question | Options | Decision | Status |
|----|----------|---------|----------|--------|
| DECIDE-001 | How to identify current project in skills? | A: `$CLAUDE_PROJECT_DIR` env var, B: Git root detection, C: Explicit config file | **A** | ✅ resolved |
| DECIDE-002 | What happens when project not initialized? | A: Error with init instructions, B: Auto-initialize with defaults, C: Fallback to global defaults | **A** | ✅ resolved |
| DECIDE-003 | How to handle project name collisions? | A: Full path → dirname, B: Path hash, C: User-specified, D: Hybrid | **A** | ✅ resolved |
| DECIDE-004 | Should existing project-level installs be supported? | A: No (clean break), B: Yes (detect and use), C: Migration tool | **A** | ✅ resolved |
| DECIDE-005 | Where should `plans/` directory live? | A: `~/.claude/blueprint/{project}/plans/`, B: `{project}/blueprint/plans/` (keep in project) | **A** | ✅ resolved |

---

## Codebase Analysis

### Current Path Resolution in Scripts

`_common.sh` uses:
```bash
get_project_root() {
  if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    echo "$CLAUDE_PROJECT_DIR"
  else
    # From .claude/skills/blueprint/_common.sh, go up 3 levels to project root
    cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd
  fi
}
```

**Problem**: In user-level deployment, `../../..` from `~/.claude/skills/blueprint/` points to `~`, NOT the current project.

### Scripts Affected

All submodule scripts reference `$PROJECT_ROOT/blueprint/`:
- `lexis.sh`: `$PROJECT_ROOT/blueprint/constitutions`
- `forma.sh`: `$PROJECT_ROOT/blueprint/templates`
- `aegis.sh`: `$PROJECT_ROOT/blueprint/gates`
- `frontis.sh`: `$PROJECT_ROOT/blueprint/front-matters`
- `hermes.sh`: `$PROJECT_ROOT/blueprint/forms`
- `polis.sh`: `$PROJECT_ROOT/.claude/agents` (different path!)

### Install Script Analysis

Current `install.sh`:
- Copies `core/claude/*` → `{target}/.claude/`
- Copies `core/*` (others) → `{target}/blueprint/`
- No separation between shared and per-project content

### Key Observations

1. **`$CLAUDE_PROJECT_DIR`**: Claude Code provides this env var to hooks
   - Value = **CWD where `claude` command was invoked** (NOT git root)
   - Available only during hooks execution
   - Full absolute path (e.g., `/Users/me/projects/blueprint`)
2. **Git Worktree**: Each worktree treated as independent project
   - Different absolute paths → no collision
   - Sessions are stored per-project-directory
3. **Path Conversion Strategy**: `/Users/me/projects/blueprint` → `Users-me-projects-blueprint/`
4. **Agent instructions**: Currently in `.claude/agents/`, will become global (shared)

---

## Architecture Considerations

### Pros of User-Level Deployment

| Benefit | Description |
|---------|-------------|
| Single installation | Install once, use in all projects |
| Shared updates | Update agents/skills centrally |
| Consistency | Same tooling across projects |
| Disk efficiency | No duplicate files per project |

### Cons / Challenges

| Challenge | Description |
|-----------|-------------|
| Path resolution | Scripts need different logic for finding blueprint data |
| Project isolation | Per-project constitutions need clear separation |
| Initialization | New projects need explicit setup step |
| Migration | Existing project-level installs need handling |
| `polis` special case | Agent instructions remain in `.claude/agents/` (shared) |

### Critical Path Changes

| Script | Current Path | User-Level Path |
|--------|--------------|-----------------|
| lexis | `$PROJECT_ROOT/blueprint/constitutions` | `~/.claude/blueprint/{project}/constitutions` |
| forma | `$PROJECT_ROOT/blueprint/templates` | `~/.claude/blueprint/{project}/templates` |
| aegis | `$PROJECT_ROOT/blueprint/gates` | `~/.claude/blueprint/{project}/gates` |
| frontis | `$PROJECT_ROOT/blueprint/front-matters` | `~/.claude/blueprint/{project}/front-matters` |
| hermes | `$PROJECT_ROOT/blueprint/forms` | `~/.claude/blueprint/{project}/forms` |
| polis | `$PROJECT_ROOT/.claude/agents` | `~/.claude/agents` (no change in path, becomes global) |

---

## Scope Summary

### Proposed Changes

| ID | Type | Purpose | Dependencies |
|----|------|---------|--------------|
| SCRIPT-001 | modify | Update `_common.sh` path resolution | none |
| SCRIPT-002 | modify | Update all submodule scripts | SCRIPT-001 |
| INSTALL-001 | create | Create `install-global.sh` for claude config | none |
| INSTALL-002 | create | Create `init-project.sh` for per-project setup | INSTALL-001 |
| INSTALL-003 | modify/deprecate | Update/remove `install.sh` | INSTALL-001, INSTALL-002 |

### Implementation Order
1. DECIDE items resolution - Critical architectural decisions
2. SCRIPT-001 - Foundation for all other scripts
3. INSTALL-001 - Global installation capability
4. INSTALL-002 - Project initialization capability
5. SCRIPT-002 - Update all submodules
6. INSTALL-003 - Clean up old install script

### Affected Files

| File | Change Type | Notes |
|------|-------------|-------|
| `core/claude/skills/blueprint/_common.sh` | modify | New path resolution logic |
| `core/claude/skills/blueprint/*/\*.sh` | modify | Use new path resolution |
| `install.sh` | modify/deprecate | Split or replace |
| `install-global.sh` | create | New global installer |
| `init-project.sh` | create | New project initializer |

---

## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | blueprint/plans/003-user-level-migration/memory.md | active |
| Master Plan | blueprint/plans/003-user-level-migration/master-plan.md | approved |
| ROADMAP | blueprint/plans/003-user-level-migration/ROADMAP.md | active |
| Implementation Notes | blueprint/plans/003-user-level-migration/implementation-notes.md | active |
| CURRENT | blueprint/plans/003-user-level-migration/session-context/CURRENT.md | active |
| TODO | blueprint/plans/003-user-level-migration/session-context/TODO.md | active |
| HISTORY | blueprint/plans/003-user-level-migration/session-context/HISTORY.md | active |

---

## Open Questions for User

~~All questions resolved - see [DECIDE] Items table above.~~

**All Resolved** ✅

---

## Session Notes

### Session 1 (2026-01-14)

**User's Initial Proposal**:
- `core/claude` → `~/.claude/` (one-time, shared)
- `core/*` (others) → `~/.claude/blueprint/{project-name}/` (per-project)
- Install script split needed
- Skills path adjustment needed

**Analysis Completed**:
- Current architecture documented
- Script dependencies mapped
- Key [DECIDE] items identified
- Pros/cons evaluated

**Key Discovery - `$CLAUDE_PROJECT_DIR`**:
- Value = CWD where `claude` command was invoked
- NOT based on git repository root
- Full absolute path provided
- Git worktree: each worktree has unique absolute path → no collision

**All [DECIDE] Items Resolved**:
- DECIDE-001: A (`$CLAUDE_PROJECT_DIR`)
- DECIDE-002: A (Error with init instructions)
- DECIDE-003: A (Full path → dirname conversion)
- DECIDE-004: A (Clean break, no backwards compat)
- DECIDE-005: A (Plans in `~/.claude/blueprint/{project}/plans/`)

**Phase 1 Complete** ✅

**Next Steps**:
- Create Master Plan (Phase 2)
