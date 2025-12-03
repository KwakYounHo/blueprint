---
type: aspect
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [aspect, specification, workflow-structure]
dependencies: [../gate.md]

name: workflow-structure
gate: specification
description: "Validates Phase/Stage/Task documents are properly created"
---

# Aspect: Workflow Structure

## Description

Validates that Workflow documents (Phase/Stage/Task) are created with correct structure and status.
Schema definitions are located in `blueprint/front-matters/`.

## Criteria

### Required (Must Pass)

#### Hierarchical Completeness
- [ ] Phase document (spec.md) exists
- [ ] At least one Stage document exists
- [ ] Each Stage has at least one Task
- [ ] Progress document (progress.md) exists

#### File Naming Convention
- [ ] Stage files: `stage-{SS}-{name}.md` format
- [ ] Task files: `task-{SS}-{TT}-{name}.md` format
- [ ] SS/TT are sequential and zero-padded (01, 02, ...)

#### Dependencies Chain
- [ ] Stage → Phase (spec.md) reference
- [ ] Task → corresponding Stage reference
- [ ] Progress → all Tasks reference

#### Document Status Lifecycle
- [ ] Phase is `archived` when Stage documents exist
- [ ] Stage documents do not exist when Phase is not `archived`
- [ ] Parent document is not `draft` when child documents exist
- [ ] Child documents do not exist when parent is `draft`
- [ ] When Phase is `deprecated`, all Stages are `deprecated`
- [ ] When Stage is `deprecated`, all its Tasks are `deprecated`

#### 100% Rule Compliance
- [ ] Each Phase.Boundaries item maps to at least one Stage
- [ ] Each Stage.Requirements item maps to at least one Task

### Recommended (Should Pass)
- [ ] Task filename Stage number (SS) matches actual Stage
