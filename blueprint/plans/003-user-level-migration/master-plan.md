---
type: master-plan
status: draft
version: 1.0.0
created: 2026-01-14
updated: 2026-01-14
tags: [master-plan, architecture, user-level, migration]
dependencies: [memory.md]

plan-id: "PLAN-003"
name: "User-Level Blueprint Migration"
source-memory: "memory.md"
phase-count: 5
---

# Master Plan: User-Level Blueprint Migration

## Overview

### Goal

Migrate Blueprint framework from project-level deployment (`{project}/.claude/` + `{project}/blueprint/`) to user-level deployment (`~/.claude/` with per-project data in `~/.claude/blueprint/{project-path}/`).

### Success Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | Global install places claude config in `~/.claude/` | Run `install-global.sh`, verify files exist in `~/.claude/{agents,skills,commands}/` |
| 2 | Project init creates per-project blueprint data | Run `init-project.sh` in any directory, verify `~/.claude/blueprint/{path}/` created |
| 3 | All blueprint skills work with user-level paths | Run `blueprint lexis --base` from initialized project, verify constitution loads |
| 4 | Uninitialized projects show clear error | Run blueprint skill in non-initialized project, verify error message with init instructions |
| 5 | Git worktree projects are isolated | Init two worktrees, verify separate blueprint data directories |

---

## Phases

> **IMPORTANT**: Before implementing each phase, enter Claude Code's **Plan Mode** for detailed planning.
> Master Plan defines WHAT to build. Plan Mode defines HOW to build it.

### Phase 1: Path Resolution Foundation

**Objective**: Update `_common.sh` to support user-level blueprint data paths

**Deliverables**:
- Modified `core/claude/skills/blueprint/_common.sh` with:
  - `get_blueprint_data_dir()` function returning `~/.claude/blueprint/{project-path}/`
  - `path_to_dirname()` function converting `/a/b/c` → `a-b-c`
  - `check_project_initialized()` function with error message
  - Preserved `get_project_root()` for backwards compatibility during development

**Dependencies**: None

**Key Implementation Details**:
```bash
# Path conversion: /Users/me/projects/blueprint → Users-me-projects-blueprint
path_to_dirname() {
  echo "$1" | sed 's|^/||' | tr '/' '-'
}

# Blueprint data directory
get_blueprint_data_dir() {
  local project_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"
  local dirname=$(path_to_dirname "$project_path")
  echo "$HOME/.claude/blueprint/$dirname"
}
```

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

### Phase 2: Global Installer

**Objective**: Create installer script for one-time Claude config setup

**Deliverables**:
- New `install-global.sh` script that:
  - Copies `core/claude/agents/` → `~/.claude/agents/`
  - Copies `core/claude/skills/` → `~/.claude/skills/`
  - Copies `core/claude/commands/` → `~/.claude/commands/`
  - Shows summary of installed files
  - Supports `--dry-run` flag
  - Idempotent (safe to run multiple times)

**Dependencies**: None (can run parallel with Phase 1)

**Script Interface**:
```bash
# Usage
./install-global.sh [--dry-run]

# Output
[INFO] Installing Blueprint to ~/.claude/
  agents/    → ~/.claude/agents/
  skills/    → ~/.claude/skills/
  commands/  → ~/.claude/commands/
[OK] Installation complete!
```

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

### Phase 3: Project Initializer

**Objective**: Create script for per-project Blueprint data initialization

**Deliverables**:
- New `init-project.sh` script that:
  - Detects current project via `$CLAUDE_PROJECT_DIR` or `pwd`
  - Creates `~/.claude/blueprint/{project-path}/` directory
  - Copies `core/constitutions/` → target `constitutions/`
  - Copies `core/forms/` → target `forms/`
  - Copies `core/front-matters/` → target `front-matters/`
  - Copies `core/gates/` → target `gates/`
  - Copies `core/templates/` → target `templates/`
  - Creates empty `plans/` directory
  - Shows initialization summary
  - Errors if already initialized (with `--force` override)

**Dependencies**: Phase 1 (uses `path_to_dirname()` function)

**Script Interface**:
```bash
# Usage
./init-project.sh [--force]

# Output
[INFO] Initializing Blueprint for: /Users/me/projects/myapp
[INFO] Target: ~/.claude/blueprint/Users-me-projects-myapp/
  constitutions/  [created]
  forms/          [created]
  front-matters/  [created]
  gates/          [created]
  templates/      [created]
  plans/          [created]
[OK] Project initialized!

# Already initialized
[ERROR] Project already initialized at ~/.claude/blueprint/Users-me-projects-myapp/
[INFO] Use --force to reinitialize (will overwrite existing files)
```

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

### Phase 4: Submodule Script Updates

**Objective**: Update all blueprint skill submodules to use user-level paths

**Deliverables**:
- Modified `lexis/lexis.sh`:
  - Use `get_blueprint_data_dir()` for constitutions path
  - Add initialization check at start
- Modified `forma/forma.sh`:
  - Use `get_blueprint_data_dir()` for templates path
  - Add initialization check at start
- Modified `aegis/aegis.sh`:
  - Use `get_blueprint_data_dir()` for gates path
  - Add initialization check at start
- Modified `frontis/frontis.sh`:
  - Use `get_blueprint_data_dir()` for front-matters path
  - Add initialization check at start
- Modified `hermes/hermes.sh`:
  - Use `get_blueprint_data_dir()` for forms path
  - Add initialization check at start
- Modified `polis/polis.sh`:
  - Use `~/.claude/agents/` directly (global, not per-project)
  - No initialization check needed (always available after global install)

**Dependencies**: Phase 1

**Path Mapping**:
| Script | Old Path | New Path |
|--------|----------|----------|
| lexis | `$PROJECT_ROOT/blueprint/constitutions` | `$(get_blueprint_data_dir)/constitutions` |
| forma | `$PROJECT_ROOT/blueprint/templates` | `$(get_blueprint_data_dir)/templates` |
| aegis | `$PROJECT_ROOT/blueprint/gates` | `$(get_blueprint_data_dir)/gates` |
| frontis | `$PROJECT_ROOT/blueprint/front-matters` | `$(get_blueprint_data_dir)/front-matters` |
| hermes | `$PROJECT_ROOT/blueprint/forms` | `$(get_blueprint_data_dir)/forms` |
| polis | `$PROJECT_ROOT/.claude/agents` | `$HOME/.claude/agents` |

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

### Phase 5: Cleanup and Documentation

**Objective**: Remove/deprecate old install script and update documentation

**Deliverables**:
- Deprecated or removed `install.sh` (old project-level installer)
- Updated skill `README.md` in `core/claude/skills/blueprint/`
- Updated `CLAUDE.md` "What Gets Copied" table
- New usage documentation section explaining:
  - Two-step setup: `install-global.sh` then `init-project.sh`
  - Path structure explanation
  - Git worktree usage

**Dependencies**: Phases 1-4

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

## [FIXED] Constraints

> These constraints are confirmed and MUST NOT be changed without user approval.

| ID | Constraint | Rationale |
|----|------------|-----------|
| C-001 | Project identification via `$CLAUDE_PROJECT_DIR` or `pwd` fallback | Claude Code provides this; reliable source |
| C-002 | Full path → dirname conversion (no hash, no user input) | Unique by definition; no collision possible |
| C-003 | No backwards compatibility with project-level installs | Clean break; simpler implementation |
| C-004 | Error on uninitialized project (no auto-init) | Explicit behavior is predictable |
| C-005 | All blueprint data in `~/.claude/blueprint/{project}/` | Centralized management |

---

## [INFER: technical-approach]

Based on codebase analysis:

1. **Bash scripts**: All skills are bash-based; maintain this pattern
2. **rsync for copying**: Existing `install.sh` uses rsync; reuse this pattern
3. **`_common.sh` sourcing**: All submodules source common; add new functions there
4. **Error handling**: Use existing `error()` function from `_common.sh`
5. **Color output**: Reuse color constants from `install.sh`

---

## References

| Type | Path | Description |
|------|------|-------------|
| Memory | `memory.md` | Decisions Made (D-001 to D-006), Background, Discussion |
| Current _common.sh | `core/claude/skills/blueprint/_common.sh` | Existing path resolution |
| Current install.sh | `install.sh` | Reference for rsync patterns |
| Submodule scripts | `core/claude/skills/blueprint/*/` | Files to modify in Phase 4 |
