---
type: aspect
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [aspect, session, git, validation]
dependencies: [../gate.md]

name: git-state
gate: session
description: "Validates Git status matches CURRENT.md documentation"
---

# Aspect: Git State

## Description

Validates that the actual Git repository state matches what is documented in CURRENT.md.
Detects discrepancies that may indicate incomplete handoffs or external changes.

## Criteria

### Required (Must Pass)

#### Branch Consistency
- [ ] Current Git branch matches `Branch` field in CURRENT.md
- [ ] If branch pattern `<convention>/<nnn>-*` expected, verify match

#### Commit State
- [ ] If CURRENT.md says "All changes committed", `git status` shows clean working tree
- [ ] If CURRENT.md lists "Modified files", verify those files are actually modified
- [ ] Recent commits match `Commits` section in CURRENT.md

#### Unexpected Changes
- [ ] No uncommitted changes exist that aren't documented
- [ ] No new untracked files in key directories

### Recommended (Should Pass)

- [ ] Last commit timestamp is recent (within expected session timeframe)
- [ ] No merge conflicts present

## Validation Method

1. **Read CURRENT.md** - Extract documented Git state
   ```
   Branch: {branch}
   Git Status: {clean/modified}
   Commits: {hash} - {message}
   ```

2. **Check actual Git state**
   ```bash
   git branch --show-current
   git status --porcelain
   git log -3 --oneline
   ```

3. **Compare and report**
   - Match branch names
   - Compare working tree state
   - Verify commit history alignment

## Error Scenarios

### Branch Mismatch

```
Issue: Branch mismatch detected
  - Expected: feature/001-auth
  - Actual: main

Severity: error

Suggestion:
  1. Switch to expected branch: git checkout feature/001-auth
  2. Or update CURRENT.md to reflect current branch
```

### Uncommitted Changes

```
Issue: Uncommitted changes not documented
  - CURRENT.md says: "Git Status: clean"
  - Actual: 3 modified files

Severity: warning

Suggestion:
  1. Review changes: git diff
  2. Commit changes: git add . && git commit
  3. Or update CURRENT.md to document changes
```

### Stale Documentation

```
Issue: Recent commits not in CURRENT.md
  - Last documented commit: abc123
  - Actual HEAD: def456 (2 commits ahead)

Severity: warning

Suggestion:
  1. Review new commits: git log abc123..HEAD
  2. Update CURRENT.md with new commits
```

## Output Format

```yaml
aspect: git-state
status: pass | fail | warning
checks:
  branch_match: true | false
  working_tree_clean: true | false
  commits_aligned: true | false
issues:
  - type: branch_mismatch | uncommitted_changes | stale_docs
    message: Description
    expected: What CURRENT.md says
    actual: What Git shows
    suggestion: How to resolve
```
