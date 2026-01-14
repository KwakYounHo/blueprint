---
type: todo
status: active
version: 1.0.0
created: 2025-01-14
updated: 2025-01-14
tags: [todo, tasks, tracking]
dependencies: [../master-plan.md, CURRENT.md]

plan-id: "PLAN-004"
current-phase: 1
---

# TODO: Cross-Machine Project Identity

**Current Phase:** Phase 1 - JSON Registry & Core Resolution

---

## In Progress (Current Session)

- [ ] Phase 1 구현 시작

## This Phase Tasks

- [ ] JSON Registry 형식 구현
  - [ ] .blueprint 파일 구조 정의
  - [ ] 빈 registry 초기화 로직
- [ ] Core Resolution 로직
  - [ ] resolve_project_alias() 함수 추가
  - [ ] get_blueprint_data_dir() 수정
  - [ ] jq dependency check 추가
- [ ] 테스트
  - [ ] alias 등록 후 resolution 확인
  - [ ] jq 미설치 시 fallback 확인

## Backlog (Future Phases)

### Phase 2: Project Submodule
- [ ] project.sh 생성 (init, list, show, remove, link, unlink)
- [ ] SKILL.md 작성
- [ ] blueprint.sh에 project 등록

### Phase 3: Legacy Migration & Cleanup
- [ ] init-project.sh deprecated 처리
- [ ] install-global.sh 메시지 업데이트
- [ ] (optional) migrate 명령어

---

## Completed

- [x] Master Plan 작성 (Session 1)
- [x] Session Context 초기화 (Session 1)

---

*Last updated: 2025-01-14*
