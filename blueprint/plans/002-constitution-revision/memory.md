---
type: memory
status: active
version: 1.1.0
created: 2026-01-13
updated: 2026-01-13
tags: [memory, constitution, refactor, terminology, agent]
dependencies: []

plan-id: "PLAN-002"
source-discussion: null
session-count: 2
last-session: 2026-01-13
---

# Memory: Constitution Revision (Agent → Slash Command Alignment)

## CRITICAL: Specification Principles

### Implementer Rules
- **Deterministic**: Any Implementer MUST produce identical code
- **No Ambiguity**: If two interpretations possible, Spec is incomplete
- **Specifier's Job**: Eliminate all ambiguous points before Spec completion

---

## Background

Blueprint Framework의 방향성이 **Agent 중심 워크플로우**에서 **Slash Command 중심 User Interaction**으로 변경됨. 최근 23개 커밋 분석 결과, 대규모 Worker 삭제(3f2359d)와 Session 시스템 추가가 이루어졌으나, `core/constitutions/base.md` 템플릿은 여전히 Agent 중심 용어를 사용 중.

### Goals
- `core/constitutions/base.md` 템플릿의 Agent 중심 용어를 현재 프레임워크 방향에 맞게 수정
- Handoff Protocol의 적용 범위를 명확히 정의
- 불필요한 Default Principles 섹션 제거
- 관련 파일들(hermes, skills 등)의 용어 일관성 확보

---

## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | ~~용어를 Session/Agent 혼용으로 변경~~ → **Worker → Agent 통합, Main Session은 "You"로 명시** | Worker를 Agent(Subagent 전용)로 확립, Main Session은 2인칭 "You"로 직접 지시 | 1→2 |
| D-002 | Default Principles 섹션 전체 제거 | Slash Command 중심에서 multi-worker 환경 아님 | 1 |
| D-003 | Project-Level Rules 도입은 이번 Scope 제외 | 별도 Plan으로 분리 가능 | 1 |
| D-004 | Handoff 개념 재정의: Session Handoff + Agent Handoff | 현재 사용 패턴이 두 가지 목적으로 구분됨 | 1 |

---

## [DECIDE] Items

| ID | Question | Options | Decision | Status |
|----|----------|---------|----------|--------|
| DECIDE-001 | Handoff Protocol 적용 범위 | A: Subagent 위임시만, B: 모든 Agent 작업, C: 재정의 | **C: 재정의** - Session Handoff + Agent Handoff | ✅ resolved |

---

## Codebase Analysis

### Git Log Summary (Latest 23 Commits)

| Commit | Summary | Impact on Constitution |
|--------|---------|----------------------|
| 3f2359d | Lexer/Parser/Orchestrator/Specifier 등 대규모 Worker 삭제 | Worker 중심 용어 부적합 확인 |
| b8c9c84~88eb2c0 | /master, Master Plan 시스템 추가 | Slash Command 중심 확인 |
| 6c2804e~5d2b4b4 | /save, /load, /checkpoint + Session Gate | Session 개념 도입 확인 |

### Handoff Usage Analysis

| Category | Usage | Description |
|----------|-------|-------------|
| Session Commands | `/save`, `/load`, `/checkpoint` | Main Session → User 결과 전달 (Output Format) |
| Reviewer Delegation | `/load`, `/checkpoint` | Main Session ↔ Reviewer Subagent |
| Review Request/Response | `request:review:*`, `response:review:*` | Structured communication |

**Key Finding**: Handoff는 두 가지 의미로 사용됨
1. **Session Handoff**: 세션 간 상태 전달 (Main Session → 다음 Session)
2. **Agent Handoff**: Subagent 작업 결과 반환 (Reviewer → Main Session)

### Handoff Concept Redefinition (D-004)

**새로운 정의**: Handoff = 작업 컨텍스트의 구조화된 전달

```
Handoff Protocol
├── Session Handoff
│   ├── Save: Session → Next Session (via CURRENT.md)
│   ├── Load: Previous Session → Current Session
│   └── Checkpoint: Phase → Archive
│
└── Agent Handoff
    ├── Request: Main Session → Subagent
    └── Response: Subagent → Main Session
```

| 형식 | 유형 | 방향 | 목적 |
|------|------|------|------|
| `after-save` | Session | Session → User | 저장 결과 알림 |
| `after-load:*` | Session | Prev → Current | 상태 브리핑 |
| `after-checkpoint` | Session | Phase → Archive | Phase 완료 |
| `request:review:*` | Agent | Main → Subagent | 작업 위임 |
| `response:review:*` | Agent | Subagent → Main | 결과 반환 |

### Files Requiring Updates

| File | Current Issue | Required Change |
|------|--------------|-----------------|
| `core/constitutions/base.md` | "Worker" 용어, Default Principles | 용어 변경 + 섹션 제거 |
| `core/forms/handoff.schema.md` | "Worker handoff" 표현 | 용어 정리 |
| `core/claude/skills/blueprint/` | 일부 "Worker" 표현 | 용어 일관성 |

### Terminology Mapping (Revised in Session 2)

| Current | Proposed | Notes |
|---------|----------|-------|
| Worker | Agent | Subagent 전용 (Task tool로 위임된 에이전트) |
| (implicit) | Main Session / You | 사용자와 직접 대화하는 주 세션 |
| All Workers MUST | You and delegated Agents MUST | 2인칭 직접 지시 |
| multi-worker environment | when delegating to Agents | 또는 제거 |
| target-workers | target-agents | FrontMatter 필드 |
| workers/ | agents/ | 디렉토리 리네임 |

---

## Scope Summary (Revised in Session 2)

### Affected Files

| File/Directory | Change Type | Notes |
|----------------|-------------|-------|
| `core/constitutions/base.md` | modify | Worker→Agent, "You" 도입, Default Principles 제거 |
| `core/constitutions/workers/` | rename | → `core/constitutions/agents/` |
| `core/constitutions/workers/reviewer.md` | modify | FrontMatter: target-workers → target-agents |
| `core/claude/skills/blueprint/polis/polis.sh` | modify | Worker → Agent |
| `core/claude/skills/blueprint/lexis/lexis.sh` | modify | Worker → Agent |
| `core/claude/skills/blueprint/blueprint.sh` | modify | Worker → Agent |
| `core/claude/skills/blueprint/SKILL.md` | modify | Worker → Agent |
| `core/forms/handoff.schema.md` | modify | Worker → Agent (if applicable) |

### Out of Scope
- Project-Level Rules 계층 도입 (별도 Plan)
- `blueprint/constitutions/base.md` 수정 (프로젝트 Dogfooding용, 별도 유지)

### Symlink Considerations
- `blueprint/constitutions/workers/` → `core/constitutions/workers/` (symlink)
- 리네임 시 symlink도 함께 업데이트 필요: `agents/` → `core/constitutions/agents/`

---

## Analysis Results: Constitution Content Review

### Appropriate Content (Keep)
| Section | Reason |
|---------|--------|
| Document Standards | Framework Core Rule |
| Directive Markers | Framework-wide utility |
| Governance | Amendment process |
| Boundaries | FORBIDDEN actions |

### Inappropriate Content (Remove/Modify)
| Section | Issue | Action |
|---------|-------|--------|
| `target-workers: ["all"]` | Agent 중심 용어 | → `target-agents` 또는 제거 |
| Handoff Protocol | "Every Worker" 표현 | → "Subagents" 명확화 |
| Default Principles | multi-worker 전제 | → **전체 제거** |

### Constitution vs Project Rules

| Content Type | Belongs To | Example |
|--------------|-----------|---------|
| Framework Core Rules | Constitution | Document Standards, Handoff Protocol |
| Framework Principles | Constitution | Start Simple, Context is Precious |
| Language-specific Rules | Project Rules (CLAUDE.md) | TypeScript `as` 금지 |
| Coding Conventions (detailed) | Project Rules (CLAUDE.md) | Exception Safety Strategy |

---

## Generated Artifacts

| Type | Path | Status |
|------|------|--------|
| Memory | blueprint/plans/002-constitution-revision/memory.md | active |
| Master Plan | blueprint/plans/002-constitution-revision/master-plan.md | pending |
