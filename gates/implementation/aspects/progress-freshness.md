---
type: aspect
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [aspect, implementation, progress-freshness]
dependencies: [../gate.md]

name: progress-freshness
gate: implementation
description: "Validates Progress document freshness and status consistency"
---

# Aspect: Progress Freshness

## Description

Validates that Progress document reflects current state and maintains consistency with related documents.
Status values reference `blueprint/front-matters/progress.schema.md`.

## Criteria

### Required (Must Pass)

#### Freshness
- [ ] `updated` field is after the last Task completion date
- [ ] `dependencies` array includes all Task files
- [ ] All Tasks in `dependencies` actually exist

#### Document Status Lifecycle
- [ ] progress.status is not in-progress/completed when any Phase/Stage/Task is `deprecated`
- [ ] progress.status is not in-progress/completed when any Stage/Task is not `archived`
- [ ] progress.status is completed only when all Stage/Task documents are `archived`

#### Status Consistency
- [ ] progress.status is not in-progress when all Tasks are completed
- [ ] progress.status is not completed when incomplete Tasks exist
- [ ] progress.status is not completed when unresolved Issues exist
- [ ] Tasks with Blockers are not marked as completed

#### Content Consistency
- [ ] Task checkbox states in body match actual work status
- [ ] Overview table progress calculation is accurate

#### Unresolved Decisions
- [ ] No `[DECIDE - ...]` markers exist (or all resolved)

### Recommended (Should Pass)
- [ ] Change Log reflects latest changes
