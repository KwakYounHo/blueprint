---
type: memory
status: active
version: 1.0.0
created: 2025-01-14
updated: 2025-01-14
tags: [memory, project-identity, cross-machine]
dependencies: []

plan-id: "PLAN-004"
source-discussion: null
session-count: 1
last-session: 2025-01-14
---

# Memory: Cross-Machine Project Identity

## CRITICAL: Specification Principles

### Implementer Rules
- **Deterministic**: Any Implementer MUST produce identical code
- **No Ambiguity**: If two interpretations possible, Spec is incomplete
- **Specifier's Job**: Eliminate all ambiguous points before Spec completion

---

## Background

현재 Blueprint 시스템은 프로젝트를 절대 경로 기반으로 식별합니다 (`/Users/me/project` → `Users-me-project`). 이 방식은 단일 머신에서는 문제가 없으나, 여러 환경에서 동일 프로젝트 작업 시 다음 문제가 발생합니다:

- **Machine A**: `/Users/duyo/dev/myproject` → `Users-duyo-dev-myproject`
- **Machine B**: `/home/user/myproject` → `home-user-myproject`
- **Result**: 동일 프로젝트임에도 별도 Plan 추적

### Goals
- 여러 머신에서 동일 프로젝트를 같은 alias로 인식
- 사용자가 프로젝트 alias를 수동 지정 가능
- 저장된 경로로 자동 프로젝트 인식
- 기존 절대경로 기반 시스템과 호환성 유지
- 프로젝트 리스트 조회 시 notes 필드로 식별 용이

---

## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | Registry file 위치: `~/.claude/blueprint/.blueprint` | 프로젝트별 데이터와 분리된 central registry가 필요 | 1 |
| D-002 | Alias는 고유해야 함 (unique constraint) | 동일 alias가 여러 프로젝트를 참조하면 혼란 | 1 |
| D-003 | 기존 path 기반 시스템을 fallback으로 유지 | 하위 호환성 보장 | 1 |
| D-004 | Registry 파일 형식: JSON | `jq`로 파싱 가능, 표준 형식 | 1 |
| D-005 | Resolution 우선순위: alias 먼저 → path fallback | alias 기반 프로젝트 인식 우선 | 1 |
| D-006 | ~~신규 프로젝트: 절대경로로 최초 생성, 세션마다 alias 지정 여부 1회 prompt~~ **→ D-009로 대체** | - | 1 |
| D-007 | `blueprint project` 서브모듈로 추가 | 기존 blueprint CLI 구조 일관성 유지 | 1 |
| D-008 | Project에 `notes` 필드 추가 | 사용자 식별용 개인 메모 저장 목적 | 1 |
| D-009 | init-project.sh를 `blueprint project init`으로 통합 | 단일 CLI 진입점, init과 registry 등록 통합 | 1 |
| D-010 | Shell script는 alias 인자만 받음, AskUserQuestion은 SKILL.md에서 처리 | 관심사 분리: script는 실행, skill은 UX | 1 |
| D-011 | notes 필드는 list/show에 통합 표시, 별도 명령어 없음 | 기존 aegis/polis 패턴과 일관성 | 1 |
| D-012 | Sub commands: `init`, `list`, `show`, `remove`, `link`, `unlink` | 직관적 네이밍 + 기존 스킬 일관성 | 1 |
| D-013 | 충돌 처리 - 경로 중복: 에러 출력 | 명시적 동작, 암묵적 변경 방지 | 1 |
| D-014 | 충돌 처리 - alias 중복: 에러 + link 안내 | 사용자가 의도적으로 link 선택하도록 유도 | 1 |
| D-015 | 레거시 디렉토리 존재 시: 기존 사용 + registry 등록 | 기존 데이터 보존, 마이그레이션 용이 | 1 |

---

## [DECIDE] Items

| ID | Question | Options | Decision | Status |
|----|----------|---------|----------|--------|
| DECIDE-001 | Registry 파일 형식? | A: INI-like, B: JSON, C: YAML | **B: JSON** | ✅ resolved |
| DECIDE-002 | 자동 인식 우선순위? | A: alias 먼저 → path fallback, B: path 먼저 → alias fallback | **A** | ✅ resolved |
| DECIDE-003 | 새 프로젝트에서 alias 자동 생성? | A: git remote, B: dirname, C: 수동 입력 | **C (수동) + SKILL.md에서 AskUserQuestion** | ✅ resolved |
| DECIDE-004 | Skill 구조? | A: 별도 skill, B: blueprint 서브모듈 | **B** | ✅ resolved |
| DECIDE-005 | init-project.sh 통합? | A: `blueprint project init`으로 통합, B: 독립 유지 | **A** | ✅ resolved |

---

## Codebase Analysis

### Existing Patterns

1. **Path-to-dirname 변환** (`_common.sh:29-34`):
   ```bash
   path_to_dirname() {
     local path="$1"
     path="${path#/}"        # Remove leading /
     path="${path// /-}"     # Replace spaces with -
     echo "${path//\//-}"    # Replace / with -
   }
   ```

2. **Blueprint data directory 결정** (`_common.sh:38-43`):
   ```bash
   get_blueprint_data_dir() {
     local project_path="${CLAUDE_PROJECT_DIR:-$(pwd)}"
     local dirname
     dirname=$(path_to_dirname "$project_path")
     echo "$HOME/.claude/blueprint/$dirname"
   }
   ```

3. **프로젝트 초기화 검증** (`_common.sh:47-60`):
   - `check_project_initialized()` 함수가 디렉토리 존재 여부만 확인

### File Locations

| Context | Pattern | Example |
|---------|---------|---------|
| Skills | `core/claude/skills/blueprint/*.sh` | `blueprint.sh`, `_common.sh` |
| Project init | `init-project.sh` | Root level |
| User data | `~/.claude/blueprint/{project-path}/` | `~/.claude/blueprint/Users-me-project/` |

### Current Flow

```
User runs skill → _common.sh loaded → get_blueprint_data_dir() called
                                      ↓
                      path_to_dirname(CLAUDE_PROJECT_DIR or pwd)
                                      ↓
                      ~/.claude/blueprint/{generated-dirname}/
```

### Proposed Flow

```
User runs skill → _common.sh loaded → resolve_project_dir() called
                                      ↓
                      1. Read ~/.claude/blueprint/.blueprint
                      2. Match current path against registered paths
                      3. If match found: return alias-based dir
                      4. If no match: fallback to path_to_dirname()
                                      ↓
                      ~/.claude/blueprint/{alias OR generated-dirname}/
```

---

## Scope Summary

### Proposed Structure

| ID | Type | Purpose | Dependencies |
|----|------|---------|--------------|
| MOD-registry-format | design | Registry 파일 형식 결정 | none |
| MOD-common-resolve | modify | `_common.sh`에 새 resolution 로직 추가 | MOD-registry-format |
| MOD-init-project | modify | `init-project.sh`에 registry 등록 로직 추가 | MOD-common-resolve |
| FEAT-project-management | feature | 프로젝트 alias/path 관리 명령어 | MOD-registry-format |

### Implementation Order
1. MOD-registry-format - 형식 결정이 모든 후속 작업의 기반
2. MOD-common-resolve - 핵심 resolution 로직 구현
3. MOD-init-project - 초기화 시 registry 자동 등록
4. FEAT-project-management - 사용자 관리 명령어

### Affected Files

| File | Change Type | Notes |
|------|-------------|-------|
| `~/.claude/blueprint/.blueprint` | create | Central project registry |
| `core/claude/skills/blueprint/_common.sh` | modify | Add resolve_project_dir() |
| `init-project.sh` | modify | Add registry registration |
| `core/claude/skills/blueprint/project/` | create | New submodule (if DECIDE-004 = B) |

---

## Design Considerations

### Registry File Format Options

**Option A: INI-like (User Proposed)**
```ini
[Project]
alias: "cutple"
paths:
 - "/Users/duyo/dev/cutple"
 - "/home/user/cutple"

[Project]
alias: "blueprint"
paths:
 - "/Users/duyo/Desktop/git-repos/test/blueprint"
```
- Pros: Human-readable, familiar format
- Cons: Custom parser needed, multi-line path handling 복잡

**Option B: JSON**
```json
{
  "projects": [
    {
      "alias": "cutple",
      "paths": ["/Users/duyo/dev/cutple", "/home/user/cutple"]
    }
  ]
}
```
- Pros: Standard format, `jq` 사용 가능
- Cons: Multi-line editing 불편

**Option C: YAML**
```yaml
projects:
  - alias: cutple
    paths:
      - /Users/duyo/dev/cutple
      - /home/user/cutple
```
- Pros: Human-readable, standard format
- Cons: `yq` 필요 (기본 설치 아님)

### Bash Parsing Considerations

- `jq`는 macOS/Linux 대부분에서 사용 가능 (설치 필요할 수 있음)
- Pure bash parsing은 INI/JSON 모두 가능하나 edge cases 처리 어려움
- `yq`는 기본 설치 아님

---

## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | blueprint/plans/004-cross-machine-project-identity/memory.md | active |
| Master Plan | blueprint/plans/004-cross-machine-project-identity/master-plan.md | draft |
