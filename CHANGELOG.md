# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- **BREAKING**: Rename `/master` command to `/plan`
- **BREAKING**: Rename `master-plan.md` to `PLAN.md`
- **BREAKING**: Rename `memory.md` to `BRIEF.md`
- **BREAKING**: Rename `master-plan.template.md` to `plan.template.md`
- **BREAKING**: Rename `memory.template.md` to `brief.template.md`
- **BREAKING**: Rename `master-plan.schema.md` to `plan.schema.md`
- **BREAKING**: Rename `memory.schema.md` to `brief.schema.md`

## [0.1.0] - 2025-01-22

### Added

#### Core Framework

- **Slash Commands**: User-controlled workflow through `/master`, `/save`, `/load`, `/checkpoint`
- **Master Plan**: Structured planning with Phase/Task hierarchy
- **Session Management**: Context preservation across session boundaries
- **Quality Gates**: Phase boundary validation with aspects

#### Blueprint Skill

- Unified CLI access via `/blueprint` skill
- **aegis**: Gate validation and aspects
- **forma**: Document templates
- **frontis**: FrontMatter schemas
- **hermes**: Handoff forms
- **lexis**: Constitution viewer
- **plan**: Plan directory and listing
- **polis**: Agent registry
- **project**: Project alias management for cross-machine portability

#### SubAgents

- **phase-analyzer**: Multi-dimensional complexity analysis for Plan Mode strategy
- **reviewer**: Quality validation at phase boundaries

#### Templates and Schemas

- Master Plan template with Phase/Task structure
- Memory template for project context
- Session context templates (CURRENT, TODO, HISTORY, ROADMAP)
- Checkpoint summary template
- Implementation notes template
- FrontMatter schemas for all document types

#### Infrastructure

- Global installer (`install-global.sh`) for user-level deployment
- SessionStart hook for automatic constitution loading
- Project alias system for cross-machine project identity
- Monorepo support with git root detection

#### Documentation

- VISION.md: Problem statement and project vision
- MISSION.md: What we build and how
- Architecture Decision Records (ADR 001-004)

### Changed

- Migrated from Agent-Orchestration workflow to User Interaction workflow
- Constitution split into Framework (`blueprint.md`) and Base (`base.md`)
- Unified "Worker" terminology to "Agent"

### Removed

- Orchestrator, Specifier, Implementer, Lorekeeper agents (replaced by user-controlled workflow)
- Project-level blueprint directory (moved to user-level `~/.claude/blueprint/`)

[Unreleased]: https://github.com/KwakYounHo/blueprint/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/KwakYounHo/blueprint/releases/tag/v0.1.0
