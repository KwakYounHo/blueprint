---
type: memory
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [memory, master-plan-system, framework-refactor]
dependencies: []

plan-id: "PLAN-001"
source-discussion: null
---

# Memory: Master Plan System Implementation

## Background

Blueprint 프레임워크를 Agent 중심의 자동화 파이프라인에서 **사용자 중심의 Slash Commands 기반** 프레임워크로 전환하는 작업.

### Goals

1. Lexer/Parser 파이프라인 제거
2. 대부분의 Workers 제거 (Reviewer만 유지)
3. Output Styles 전체 제거
4. `/master` Slash Command로 Main Session에서 직접 작업
5. `lexis --base`로 프로젝트별 Constitution 동적 로드

---

## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | Agent 중심 → 사용자 중심으로 전환 | Agent 자동화보다 사용자 제어 선호 | 1 |
| D-002 | Lexer/Parser 파이프라인 제거 | Memory만으로 충분, 불필요한 복잡성 제거 | 1 |
| D-003 | Reviewer만 SubAgent로 유지 | Token 절약용 Supporter 역할 | 1 |
| D-004 | /master를 Slash Command로 구현 | Output Style 대신 Command로 동적 Context 주입 | 1 |
| D-005 | base.md 범용 유지 | Master Plan 원칙은 /master에만 포함 | 1 |
| D-006 | Directive Markers는 Master Plan에 삽입 | Plan Mode 시작 전 결정 해결 필요 | 1 |
| D-007 | blueprint/specs/ → blueprint/plans/로 완전 대체 | 단순화된 구조 | 1 |
| D-008 | D-NNN, DECIDE-NNN ID 체계 사용 | 실제 프로젝트에서 검증된 패턴 | 1 |
| D-009 | Session Log 제외 | Decisions Made 테이블로 충분 | 1 |
| D-010 | forma copy 기능 추가 | Context 절약을 위한 템플릿 복사 | 1 |

---

## [DECIDE] Items

| ID | Question | Options | Decision | Status |
|----|----------|---------|----------|--------|
| - | - | - | - | (all resolved) |

---

## Scope Summary

### Proposed Structure

| ID | Type | Purpose | Dependencies |
|----|------|---------|--------------|
| - | command | `/master` Slash Command | none |
| - | template | master-plan.template.md | none |
| - | template | implementation-notes.template.md | none |
| - | schema | master-plan.schema.md | base.schema.md |
| - | schema | implementation-notes.schema.md | base.schema.md |

### Files to Create

| File | Type | Notes |
|------|------|-------|
| `core/claude/commands/master.md` | command | Main entry point |
| `core/templates/master-plan.template.md` | template | Master Plan structure |
| `core/templates/implementation-notes.template.md` | template | Implementation tracking |
| `core/front-matters/master-plan.schema.md` | schema | FrontMatter validation |
| `core/front-matters/implementation-notes.schema.md` | schema | FrontMatter validation |
| `core/front-matters/lib-spec.schema.md` | schema | Split from spec.schema |
| `core/front-matters/feature-spec.schema.md` | schema | Split from spec.schema |

### Files to Delete

- Output Styles: 3 files
- Commands: 3 files
- Agents: 6 files (keep reviewer.md)
- Constitutions/workers: 6 files (keep reviewer.md)
- Templates: 2 files (tokens, ast)
- Schemas: 2 files (tokens, ast)

---

## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | blueprint/plans/001-master-plan-system/memory.md | active |
| Master Plan | blueprint/plans/001-master-plan-system/master-plan.md | draft |
