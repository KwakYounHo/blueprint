---
type: master-plan
status: in-progress
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [master-plan, framework-refactor]
dependencies: [memory.md]

plan-id: "PLAN-001"
name: "Master Plan System Implementation"
source-memory: "memory.md"
phase-count: 6
---

# Master Plan: Master Plan System Implementation

## Overview

### Goal

Blueprint 프레임워크를 Agent 중심에서 사용자 중심의 Slash Commands 기반 프레임워크로 전환한다.

### Success Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | `/master` 명령어 작동 | 실행 시 올바른 Context 주입 확인 |
| 2 | 템플릿 조회/복사 가능 | `forma show/copy` 명령어 테스트 |
| 3 | 스키마 조회 가능 | `frontis schema` 명령어 테스트 |
| 4 | 불필요한 파일 제거 | `polis --list`로 reviewer만 표시 확인 |

---

## Phases

### Phase 1: Directory & Dogfooding Setup

**Objective**: 새로운 디렉토리 구조 생성 및 첫 번째 케이스로 이 구현 자체를 사용

**Deliverables**:
- [x] `blueprint/plans/` 디렉토리 생성
- [x] `blueprint/plans/001-master-plan-system/memory.md`
- [x] `blueprint/plans/001-master-plan-system/master-plan.md`

**Status**: Completed

---

### Phase 2: Create `/master` Command

**Objective**: Main Session에서 Master Plan 워크플로우를 실행하는 진입점 생성

**Deliverables**:
- [ ] `core/claude/commands/master.md`

**Dependencies**: None

---

### Phase 3: Create New Templates

**Objective**: Master Plan 시스템에 필요한 템플릿 파일 생성

**Deliverables**:
- [ ] `core/templates/master-plan.template.md`
- [ ] `core/templates/implementation-notes.template.md`
- [ ] RENAME `spec-lib.template.md` → `lib-spec.template.md`
- [ ] RENAME `spec-feat.template.md` → `feature-spec.template.md`
- [ ] UPDATE `memory.template.md` (경로, plan-id, Decisions Made 섹션)

**Dependencies**: Phase 2

---

### Phase 4: Create New Schemas

**Objective**: FrontMatter 검증을 위한 스키마 파일 생성

**Deliverables**:
- [ ] `core/front-matters/master-plan.schema.md`
- [ ] `core/front-matters/implementation-notes.schema.md`
- [ ] `core/front-matters/lib-spec.schema.md`
- [ ] `core/front-matters/feature-spec.schema.md`
- [ ] UPDATE `base.schema.md` (새 타입 추가, tokens/ast 제거)
- [ ] UPDATE `memory.schema.md` (plan-id 필드 추가)

**Dependencies**: Phase 3

---

### Phase 5: Cleanup - Delete Old Files

**Objective**: 불필요한 파일 제거

**Deliverables**:
- [ ] Delete Output Styles (3 files)
- [ ] Delete old Commands (3 files)
- [ ] Delete Agents (6 files, keep reviewer.md)
- [ ] Delete Constitutions/workers (6 files, keep reviewer.md)
- [ ] Delete Lexer/Parser templates & schemas (4 files)

**Dependencies**: Phase 4

---

### Phase 6: Update Skills

**Objective**: CLI 도구 업데이트

**Deliverables**:
- [ ] `forma.sh`: 새 템플릿 이름 + `copy` 기능 추가
- [ ] `frontis.sh`: 새 스키마 이름 (필요시)
- [ ] `hermes.sh`: Lexer/Parser handoff 제거 (필요시)

**Dependencies**: Phase 5

---

## [FIXED] Constraints

> These constraints are confirmed and MUST NOT be changed without user approval.

| ID | Constraint | Rationale |
|----|------------|-----------|
| C-001 | Reviewer SubAgent만 유지 | 문서 유효성 검사용 Supporter |
| C-002 | base.md는 범용 유지 | 프로젝트별 원칙 정의용 |
| C-003 | D-NNN, DECIDE-NNN ID 체계 사용 | 실제 프로젝트에서 검증됨 |

---

## Lib/Feature Classification

> 이 구현은 인프라 변경이므로 Lib/Feature 분류 해당 없음

---

## Implementation Order

```
Phase 1: Directory & Dogfooding Setup ✓
└── memory.md, master-plan.md

Phase 2: /master Command
└── core/claude/commands/master.md

Phase 3: Templates
├── master-plan.template.md
├── implementation-notes.template.md
├── lib-spec.template.md (rename)
├── feature-spec.template.md (rename)
└── memory.template.md (update)

Phase 4: Schemas
├── master-plan.schema.md
├── implementation-notes.schema.md
├── lib-spec.schema.md
├── feature-spec.schema.md
├── base.schema.md (update)
└── memory.schema.md (update)

Phase 5: Cleanup
├── Delete Output Styles (3)
├── Delete Commands (3)
├── Delete Agents (6)
├── Delete Constitutions (6)
└── Delete Templates/Schemas (4)

Phase 6: Skills
├── forma.sh (copy feature)
└── frontis.sh (if needed)
```

---

## Next Steps

1. [x] Phase 1 완료
2. [ ] Phase 2 진행: `/master` Command 생성
