---
type: todo
status: active
version: 1.0.0
created: 2026-01-14
updated: 2026-01-14
tags: [todo, tasks, tracking]
dependencies: [../master-plan.md, CURRENT.md]

plan-id: "PLAN-003"
current-phase: 1
---

# TODO: User-Level Blueprint Migration

**Current Phase:** Phase 1 - Path Resolution Foundation

---

## In Progress (Current Session)

- [ ] Session Context initialization

## This Phase Tasks

- [ ] Update `_common.sh` with new path resolution
  - [ ] Add `path_to_dirname()` function
  - [ ] Add `get_blueprint_data_dir()` function
  - [ ] Add `check_project_initialized()` function
  - [ ] Preserve `get_project_root()` for compatibility
- [ ] Test path conversion logic

## Backlog (Future Phases)

### Phase 2: Global Installer
- [ ] Create `install-global.sh` script

### Phase 3: Project Initializer
- [ ] Create `init-project.sh` script

### Phase 4: Submodule Script Updates
- [ ] Update lexis.sh, forma.sh, aegis.sh, frontis.sh, hermes.sh, polis.sh

### Phase 5: Cleanup and Documentation
- [ ] Deprecate/remove old `install.sh`
- [ ] Update documentation

---

## Completed

- [x] Create memory.md (Session 1)
- [x] Create master-plan.md (Session 1)
- [x] Initialize session-context/ (Session 1)

---

*Last updated: 2026-01-14*
