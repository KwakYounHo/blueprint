---
type: master-plan
status: in-progress
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [master-plan, constitution, terminology, agent]
dependencies: [memory.md]

plan-id: "PLAN-002"
name: "Constitution Revision: Worker to Agent Terminology"
source-memory: "memory.md"
phase-count: 3
---

# Master Plan: Constitution Revision

## Overview

### Goal

Blueprint 프레임워크의 용어 체계를 정리한다: Worker → Agent (Subagent 전용), Main Session → "You" (2인칭 직접 지시).

### Success Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | `core/constitutions/base.md`에 Worker 용어 없음 | `grep -i worker core/constitutions/base.md` 결과 없음 |
| 2 | `agents/` 디렉토리로 리네임 완료 | `ls core/constitutions/agents/` 성공 |
| 3 | Skills에서 Agent 용어 사용 | `blueprint polis --list` 출력에 "Agent" 표시 |
| 4 | Default Principles 섹션 제거됨 | base.md에 "Principles with Defaults" 없음 |

---

## Phases

> **IMPORTANT**: Before implementing each phase, enter Claude Code's **Plan Mode** for detailed planning.
> Master Plan defines WHAT to build. Plan Mode defines HOW to build it.

### Phase 1: Analysis & Memory

**Objective**: Git log와 codebase 분석으로 Constitution 개정 필요사항 식별

**Deliverables**:
- [x] Git log 분석 (+23 commits)
- [x] `memory.md` 생성 및 결정 사항 기록
- [x] D-001 ~ D-004 결정 완료
- [x] D-001 재검토 및 수정 (Session 2)

**Dependencies**: None

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

**Status**: Completed

---

### Phase 2: Master Plan Creation

**Objective**: 구현 계획 수립 및 사용자 승인 획득

**Deliverables**:
- [x] `master-plan.md` 생성
- [x] 사용자 승인

**Dependencies**: Phase 1

**Implementation**:
```
1. Enter Plan Mode
2. Execute with user approval
3. Update implementation-notes.md if deviations occur
```

**Status**: Completed

---

### Phase 3: Implementation

**Objective**: 승인된 계획에 따라 파일 수정

**Deliverables**:
- [ ] 3.1: `core/constitutions/base.md` 수정 (Worker→You/Agent, Default Principles 제거)
- [ ] 3.2: `workers/` → `agents/` 디렉토리 리네임 + symlink 업데이트
- [ ] 3.3: Skills 업데이트 (polis, lexis, blueprint.sh, SKILL.md)
- [ ] 3.4: `handoff.schema.md` 수정 (필요시)

**Dependencies**: Phase 2

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
| C-001 | `blueprint/constitutions/base.md` 수정 제외 | 프로젝트 Dogfooding용, 별도 유지 |
| C-002 | Project-Level Rules 도입 제외 | 이번 Scope 외, 별도 Plan으로 분리 |
| C-003 | Reviewer agent만 유지 | 유일한 Subagent, 문서 검증용 |

---

## [INFER: technical-approach]

<!--
Analysis targets: Codebase patterns, existing implementations
Output: Recommended technical approach based on analysis
-->

**Terminology Mapping** (from memory.md):

| Current | Proposed | Notes |
|---------|----------|-------|
| Worker | Agent | Subagent 전용 |
| (implicit) | Main Session / You | 2인칭 직접 지시 |
| All Workers MUST | You and delegated Agents MUST | Constitution 규칙 |
| target-workers | target-agents | FrontMatter 필드 |
| workers/ | agents/ | 디렉토리명 |

**File Changes**:

| File/Directory | Change Type |
|----------------|-------------|
| `core/constitutions/base.md` | modify |
| `core/constitutions/workers/` | rename → `agents/` |
| `core/constitutions/workers/reviewer.md` | modify FrontMatter |
| `core/claude/skills/blueprint/polis/polis.sh` | modify |
| `core/claude/skills/blueprint/lexis/lexis.sh` | modify |
| `core/claude/skills/blueprint/blueprint.sh` | modify |
| `core/claude/skills/blueprint/SKILL.md` | modify |
| `blueprint/constitutions/workers/` (symlink) | update |

---

## References

| Type | Path | Description |
|------|------|-------------|
| Memory | `memory.md` | Decisions Made (D-001~D-004), Terminology Mapping, Scope |
| Target | `core/constitutions/base.md` | Primary file to modify |
| Target | `core/constitutions/workers/` | Directory to rename |
