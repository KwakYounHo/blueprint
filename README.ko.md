# Blueprint

> **Plan once, develop across sessions.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.5.0-blue.svg)](CHANGELOG.md)
[![Status](https://img.shields.io/badge/status-alpha-orange.svg)]()
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet.svg)]()

[English](README.md)

---

## 핵심 신념

**Context is Precious.**

모든 설계 결정의 근본에는 Context 효율성이 있습니다.

- 플래닝 단계의 충분한 상호작용은 구현 단계의 수정 비용을 줄입니다
- Main Session의 Context는 보호되어야 하며, 복잡한 분석은 SubAgent에 위임합니다
- Session 간 Context 보존은 대규모 개발의 필수 조건입니다

---

## 기능

### 1. Slash Commands

직관적인 커맨드로 워크플로우를 제어합니다:

| 커맨드 | 용도 |
|--------|------|
| `/bplan` | 구조화된 구현 계획 생성 |
| `/banalyze` | Phase 복잡도 분석 (Plan Mode 결정) |
| `/save` | 세션 상태 저장 (핸드오프용) |
| `/load` | 이전 세션 상태 로드 |
| `/checkpoint` | 마일스톤 체크포인트 저장 |

### 2. 구조화된 Plan

복잡한 작업을 Phase/Task 계층으로 분해합니다:

```
Plan
├── Phase 1: 기초 작업
│   ├── Task 1.1: 환경 설정
│   └── Task 1.2: 기본 구조 생성
├── Phase 2: 핵심 구현
│   └── ...
└── Phase 3: 마무리
    └── ...
```

### 3. Session 관리

세션 경계를 초월하여 개발 컨텍스트를 보존합니다:

```
Session 1 → /save → [외부 저장소] → /load → Session 2

├── 배경, 목적, 접근 방식 보존
├── 세션 초기화와 무관하게 연속성 유지
└── 대규모 개발에 필수적
```

### 4. Blueprint Skill

프레임워크 기능에 대한 통합 CLI 접근:

| 서브모듈 | 용도 |
|----------|------|
| `aegis` | Gate 검증 및 Aspect |
| `forma` | 문서 템플릿 |
| `frontis` | FrontMatter 스키마 |
| `hermes` | Handoff 폼 |
| `lexis` | Constitution 뷰어 |
| `plan` | Plan 디렉토리 및 목록 |
| `polis` | Agent 레지스트리 |
| `project` | 프로젝트 관리 (alias, setup, sync) |

### 5. Quality Gates

Phase 경계에서 구조화된 기준으로 검증합니다:

```
Phase N → [Gate 검증] → Phase N+1
           ├── Aspect 1
           ├── Aspect 2
           └── ...
```

### 6. SubAgent 위임

복잡한 작업을 위임하여 Main Session Context를 보호합니다:

| Agent | 역할 |
|-------|------|
| `phase-analyzer` | 다차원 복잡도 분석 |
| `reviewer` | 품질 검증 |

---

## 설치

### 요구사항

- Claude Code CLI
- `jq` (선택, 자동 훅 설정에 필요)

### 글로벌 설치

```bash
git clone git@github.com:KwakYounHo/blueprint.git
cd blueprint
./install-global.sh
```

설치 위치:
- `~/.claude/agents/` - SubAgent 정의
- `~/.claude/skills/` - Blueprint 스킬
- `~/.claude/commands/` - Slash 커맨드
- `~/.claude/hooks/` - 세션 훅
- `~/.claude/blueprint/base/` - 기본 템플릿, 스키마, Constitution

### 프로젝트 초기화

설치 후 각 프로젝트에서:

```
1. Claude Code 세션 시작
2. 스킬 로드: /blueprint
3. 요청: "이 디렉토리를 Blueprint 프로젝트로 등록해줘.
        alias는 'my-project', notes는 '프로젝트 설명'으로."
```

### Bare Repo 지원

Bare repo + worktree 워크플로우:

```
1. 아무 worktree에서 Claude Code 세션 시작
2. 스킬 로드: /blueprint
3. 요청: "Blueprint 프로젝트로 등록해줘. alias는 'my-project', type은 bare로."
4. 실행: blueprint project setup (모든 worktree에 설정 배포)
```

---

## 빠른 시작

### 1. Plan 생성

```
/bplan
```

사용자와 대화하며 구조화된 계획(Phase/Task)을 생성합니다.

### 2. 세션 연속성

| 시점 | 커맨드 |
|------|--------|
| 세션 종료 전 | `/save` |
| 새 세션 시작 | `/load` |
| Phase 완료 시 | `/checkpoint` |

### 3. 일반적인 워크플로우

```
Session 1: /bplan → 개발 → /save
                       ↓
Session 2: /load → 개발 계속 → /save
                       ↓
       (Phase 완료 시) → /checkpoint
                       ↓
Session N: /load → 최종 Phase 완료 → /checkpoint → 완료
```

---

## 설치 후 구조

`install-global.sh` 실행 후:

```
~/.claude/
├── agents/                  # SubAgent 정의
├── commands/                # Slash 커맨드 (/bplan, /save, /load, /checkpoint)
├── hooks/                   # 세션 훅
├── skills/                  # Blueprint 스킬 (통합 CLI)
│   └── blueprint/
├── settings.json            # SessionStart 훅 설정
└── blueprint/
    ├── base/                # 프레임워크 핵심 (스키마, 템플릿, 게이트)
    │   ├── constitutions/
    │   ├── forms/
    │   ├── front-matters/
    │   ├── gates/
    │   └── templates/
    └── projects/            # 프로젝트별 데이터 (프로젝트 초기화 시 생성)
```

---

## 문서

- [VISION.md](VISION.md) - 해결하려는 문제와 접근 방식
- [MISSION.md](MISSION.md) - 무엇을 어떻게 만드는가

---

## 라이선스

[MIT License](LICENSE)
