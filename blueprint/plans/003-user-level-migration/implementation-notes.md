---
type: implementation-notes
status: active
version: 1.0.0
created: 2026-01-14
updated: 2026-01-14
tags: [implementation, notes]
dependencies: [master-plan.md]

plan-id: "PLAN-003"
---

# Implementation Notes: User-Level Blueprint Migration

## Deviations from Plan

| Date | Phase | Original | Actual | Reason |
|------|-------|----------|--------|--------|
| - | - | - | - | - |

---

## Issues Encountered

(No issues recorded yet)

---

## Learnings

### LEARN-001: CLAUDE_PROJECT_DIR Behavior

**Context**: Phase 1 planning, investigating environment variables

**Insight**:
`$CLAUDE_PROJECT_DIR` is set to the CWD where `claude` command was invoked, NOT the git repository root. This is important because it means git worktrees naturally get unique paths.

**Application**:
- Use `$CLAUDE_PROJECT_DIR` as primary identifier
- Fallback to `pwd` when env var not available
- Full path → dirname conversion guarantees uniqueness

### LEARN-002: Shell Compatibility with Parameter Expansion

**Context**: Phase 1 implementation, path_to_dirname function

**Insight**:
Using piped external commands (`sed`, `tr`) in bash scripts can fail when sourced from zsh. Parameter expansion (`${var#pattern}`, `${var//old/new}`) is more portable.

**Application**:
```bash
# Instead of:
echo "$path" | sed 's|^/||' | tr '/' '-'

# Use:
path="${path#/}"        # Remove leading /
echo "${path//\//-}"    # Replace / with -
```

---

## Environment Notes

| Item | Value | Note |
|------|-------|------|
| Target location | `~/.claude/` | User-level Claude config directory |
| Blueprint data | `~/.claude/blueprint/{project-path}/` | Per-project data location |
| Path conversion | `/a/b/c` → `a-b-c` | Leading slash removed, slashes become dashes |

---

## Timeline

| Date | Event | Notes |
|------|-------|-------|
| 2026-01-14 | Planning started | Session 1 |
| 2026-01-14 | Master Plan approved | 5 phases defined |
| - | Phase 1 started | - |
| - | Phase 1 completed | - |
| - | Implementation completed | - |
