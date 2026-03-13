---
type: aspect
status: active
version: 1.0.0
created: 2026-03-13
updated: 2026-03-13
tags: [aspect, verification, scope, brief]
dependencies: [../gate.md]

name: scope
gate: verification
description: "Validates changed files are within declared scope and no out-of-scope work exists"
---

# Aspect: Scope

## Description

Validates that all files changed in the implementation are within the scope declared in BRIEF.md's `Affected Files` table, and that no items listed in `Out of Scope` were implemented.

## Criteria

### Required (Must Pass)

#### File Scope
- [ ] Every changed file (from code diff) appears in BRIEF.md `Affected Files` table or is a reasonable derivative (e.g., subdirectory of a listed path)
- [ ] No file changes exist that are completely outside declared scope

#### Out of Scope Boundary
- [ ] No items listed in BRIEF.md `Out of Scope` section are implemented
- [ ] No new features or modules beyond the declared scope are introduced

### Recommended

_(none)_

## Validation Method

1. **Read BRIEF.md** — Extract `Affected Files` table and `Out of Scope` list
2. **Read code diff** — `git diff --name-only <base>...HEAD` to get changed file list
3. **Cross-reference**
   - Each changed file must match an `Affected Files` entry
   - No changed file should implement an `Out of Scope` item
4. **Report** — List any out-of-scope files or scope violations

## Error Scenarios

### File Outside Scope

```
Issue: File changed outside declared scope
  - File: install-global.sh
  - Scope: Not in BRIEF.md Affected Files
  - Out of Scope: "Changes to install-global.sh" explicitly excluded

Severity: error

Suggestion:
  1. Revert changes to out-of-scope file
  2. Or update BRIEF.md scope (requires user approval since [FIXED])
```

### Scope Creep

```
Issue: New feature outside declared scope
  - File: core/claude/commands/simplify.md
  - Evidence: New command created that is not in Affected Files
  - Out of Scope: "/simplify integration" explicitly excluded

Severity: error

Suggestion:
  1. Remove out-of-scope addition
  2. Track as a separate plan if needed
```

### Undeclared File

```
Issue: Changed file not in Affected Files (but not explicitly out of scope)
  - File: core/gates/verification/README.md
  - Note: Not in Affected Files, but reasonable supporting file

Severity: warning

Suggestion:
  1. Verify file is necessary for the implementation
  2. Note as minor scope addition in implementation-notes.md
```

## Output Format

```yaml
aspect: scope
status: pass | fail | warning
files_in_scope: 12
files_out_of_scope: 0
issues:
  - file: "install-global.sh"
    status: fail
    message: "File changed outside declared scope"
    scope_reference: "Out of Scope: Changes to install-global.sh"
    suggestion: "Revert changes to this file"
```
