---
type: master-plan
status: ready
version: 1.1.0
created: 2025-01-14
updated: 2025-01-14
tags: [master-plan, project-identity, cross-machine]
dependencies: [memory.md]

plan-id: "PLAN-004"
name: "Cross-Machine Project Identity"
source-memory: "memory.md"
phase-count: 3
---

# Master Plan: Cross-Machine Project Identity

## Overview

### Goal

다중 머신 환경에서 동일 프로젝트를 alias 기반으로 인식하여 일관된 Plan 추적을 가능하게 한다.

### Success Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | `blueprint project init <alias>` 로 새 프로젝트 초기화 + registry 등록 | 명령어 실행 후 `~/.claude/blueprint/{alias}/` 생성 확인 |
| 2 | 등록된 프로젝트가 다른 경로에서도 동일 alias로 인식됨 | `blueprint project link` 후 다른 경로에서 skill 실행 |
| 3 | 미등록 프로젝트는 기존 절대경로 방식으로 동작 | 새 프로젝트에서 registry 없이 skill 실행 시 path-based dir 사용 |
| 4 | 프로젝트 리스트에서 notes 필드 조회 가능 | `blueprint project list` 출력에 notes 표시 |
| 5 | `init-project.sh` 삭제, `blueprint project init`으로 대체 | 레거시 스크립트 제거 확인 |

---

## Phases

> **IMPORTANT**: Before implementing each phase, enter Claude Code's **Plan Mode** for detailed planning.
> Master Plan defines WHAT to build. Plan Mode defines HOW to build it.

### Phase 1: JSON Registry & Core Resolution

**Objective**: Registry 파일 형식 정의 및 `_common.sh`에 alias 기반 resolution 로직 추가

**Deliverables**:
- `~/.claude/blueprint/.blueprint` JSON 파일 형식 정의
- `_common.sh`에 `resolve_project_alias()` 함수 추가
- `get_blueprint_data_dir()` 수정: alias 우선 → path fallback

**Dependencies**: None

**Specification**:

1. **Registry JSON Format**:
```json
{
  "version": "1.0.0",
  "projects": [
    {
      "alias": "blueprint",
      "paths": [
        "/Users/duyo/Desktop/git-repos/test/blueprint",
        "/home/user/blueprint"
      ],
      "notes": "Blueprint framework development"
    }
  ]
}
```

2. **Resolution Logic** (`_common.sh`):
```
resolve_project_alias(current_path):
  1. If .blueprint file does not exist: return null
  2. If jq not available: print warning, return null
  3. Search projects[].paths for current_path match
  4. If found: return projects[].alias
  5. Return null

get_blueprint_data_dir():
  1. alias = resolve_project_alias(current_path)
  2. If alias: return ~/.claude/blueprint/{alias}/
  3. Else: return ~/.claude/blueprint/{path_to_dirname(current_path)}/
```

3. **jq Dependency**:
   - If `jq` not available: fall back to path-based resolution
   - Print warning once per session: "jq not found, alias resolution disabled"

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

### Phase 2: Project Submodule

**Objective**: `blueprint project` 서브모듈 생성 - 프로젝트 초기화 및 관리 CLI 통합

**Deliverables**:
- `core/claude/skills/blueprint/project/project.sh` 생성
- `core/claude/skills/blueprint/project/SKILL.md` 생성
- `blueprint.sh`에 project 서브모듈 등록
- `init-project.sh` deprecated 처리 (경고 메시지 출력 후 `blueprint project init` 안내)

**Dependencies**: Phase 1

**Specification**:

1. **Command Interface**:

| Command | Description | Example |
|---------|-------------|---------|
| `blueprint project init <alias> [--notes "text"]` | 새 프로젝트 초기화 + registry 등록 | `blueprint project init myproject` |
| `blueprint project list` | 전체 프로젝트 리스트 (alias, paths count, notes) | - |
| `blueprint project show <alias>` | 특정 프로젝트 상세 정보 (모든 paths 표시) | `blueprint project show blueprint` |
| `blueprint project remove <alias>` | 프로젝트 삭제 (확인 prompt, 데이터 디렉토리 삭제 여부 질문) | `blueprint project remove myproject` |
| `blueprint project link <alias>` | 현재 경로를 기존 프로젝트에 추가 | `blueprint project link blueprint` |
| `blueprint project unlink <alias> [path]` | 경로 제거 (path 생략 시 현재 경로) | `blueprint project unlink blueprint /old/path` |

2. **`init` 상세 동작**:
```
blueprint project init <alias> [--notes "text"]:
  1. Validate alias format (alphanumeric, dash, underscore only)
  2. Check: current path already in registry?
     → Yes: Error "Path already registered as '{existing_alias}'"
  3. Check: alias already exists?
     → Yes: Error "Alias already exists. Use 'blueprint project link {alias}' to add this path"
  4. Check: legacy directory exists (~/.claude/blueprint/{path-based-name})?
     → Yes: Rename to {alias}, register in registry
     → No: Create new directory, copy framework files
  5. Register in .blueprint: { alias, paths: [current_path], notes }
  6. Print success message with data directory path
```

3. **Output Formats**:

`list`:
```
Projects (3):
  blueprint       (2 paths)  Blueprint framework development
  cutple          (3 paths)  YouTube shorts generator
  my-project      (1 path)   -
```

`show`:
```
Project: blueprint
Notes: Blueprint framework development
Paths:
  - /Users/duyo/Desktop/git-repos/test/blueprint
  - /home/user/blueprint
Data: ~/.claude/blueprint/blueprint/
```

4. **Error Messages**:

| Situation | Message |
|-----------|---------|
| Path already registered | `Error: Path already registered as '{alias}'. Use 'blueprint project show {alias}' to view details.` |
| Alias already exists | `Error: Alias '{alias}' already exists. Use 'blueprint project link {alias}' to add current path.` |
| Alias not found | `Error: Project '{alias}' not found. Available projects: {list}` |
| Invalid alias format | `Error: Invalid alias. Use alphanumeric characters, dashes, and underscores only.` |
| Last path removal | `Warning: This is the last path for '{alias}'. Remove project entirely? [y/N]` |

5. **SKILL.md Content**:
```markdown
# Project Management

Before running `blueprint project init`, ask user:
1. Project alias (suggest directory name as default)
2. Notes (optional description)

Use AskUserQuestion tool to gather this information.
```

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

---

### Phase 3: Legacy Migration & Cleanup

**Objective**: 기존 `init-project.sh` deprecated 처리 및 레거시 프로젝트 마이그레이션 지원

**Deliverables**:
- `init-project.sh` 수정: deprecated 경고 + `blueprint project init` 안내
- `blueprint project migrate` 명령어 추가 (optional)
- `install-global.sh` 수정: 안내 메시지 업데이트

**Dependencies**: Phase 2

**Specification**:

1. **`init-project.sh` Deprecated 동작**:
```bash
#!/usr/bin/env bash
echo "[DEPRECATED] init-project.sh is deprecated."
echo ""
echo "Use 'blueprint project init <alias>' instead:"
echo "  blueprint project init myproject"
echo "  blueprint project init myproject --notes 'My project description'"
echo ""
echo "For more information: blueprint project --help"
exit 1
```

2. **`install-global.sh` 메시지 업데이트**:
```
Next step: Run 'blueprint project init <alias>' in your project directory.
```

3. **Optional: `blueprint project migrate`**:
```
blueprint project migrate:
  1. Scan ~/.claude/blueprint/ for directories without registry entry
  2. For each unregistered directory:
     - Extract original path from directory name
     - Ask user for alias (suggest based on directory name)
     - Register in .blueprint
  3. Print migration summary
```

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
| C-001 | Registry file: `~/.claude/blueprint/.blueprint` (JSON) | D-001, D-004 |
| C-002 | Alias uniqueness enforced | D-002 |
| C-003 | Path-based fallback always available | D-003 |
| C-004 | Shell script receives alias as argument only | D-010 |
| C-005 | AskUserQuestion handled in SKILL.md, not shell | D-010 |
| C-006 | Sub commands: `init`, `list`, `show`, `remove`, `link`, `unlink` | D-012 |
| C-007 | Path conflict → Error (no silent override) | D-013 |
| C-008 | Alias conflict → Error + link suggestion | D-014 |
| C-009 | Legacy directory → Reuse + register | D-015 |

---

## [INFER: technical-approach]

Based on codebase analysis:

1. **Bash + jq Approach**:
   - `_common.sh` provides shared functions
   - `jq` for JSON parsing with graceful degradation
   - Pure bash fallback for path-based resolution

2. **Submodule Pattern**:
   - Follow existing `aegis`, `forma`, `frontis` structure
   - `blueprint.sh` dispatches to `project/project.sh`
   - `project/SKILL.md` provides Claude Code instructions

3. **File Operations**:
   - Use `rsync` for directory copying (existing pattern)
   - Atomic registry updates with temp file + mv

---

## References

| Type | Path | Description |
|------|------|-------------|
| Memory | `memory.md` | Decisions Made (D-001~D-015), Background |
| Current Code | `core/claude/skills/blueprint/_common.sh` | Existing path resolution |
| Current Code | `init-project.sh` | Legacy initialization (to be deprecated) |
| Pattern Reference | `core/claude/skills/blueprint/aegis/` | Submodule structure example |
