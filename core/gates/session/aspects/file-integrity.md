---
type: aspect
status: active
version: 1.0.0
created: 2026-01-13
updated: 2026-01-13
tags: [aspect, session, files, validation]
dependencies: [../gate.md]

name: file-integrity
gate: session
description: "Validates Key Files exist and match their descriptions"
---

# Aspect: File Integrity

## Description

Validates that files listed in CURRENT.md's "Key Files" section exist and match their documented descriptions.
Detects missing, moved, or significantly changed files that may affect session continuity.

## Criteria

### Required (Must Pass)

#### File Existence
- [ ] All files listed in "Key Files" section exist at specified paths
- [ ] No critical files have been deleted or moved

#### Path Validity
- [ ] All paths are valid and accessible
- [ ] No broken symlinks in key file paths

### Recommended (Should Pass)

#### Content Alignment
- [ ] File purpose matches documented description
- [ ] File structure is recognizable (not corrupted)
- [ ] Key sections/functions mentioned in description are present

#### Reasonable Size
- [ ] Files are not empty when content is expected
- [ ] Files are not unexpectedly large (potential issue indicator)

## Validation Method

1. **Extract Key Files from CURRENT.md**
   ```markdown
   ## Key Files
   - `src/auth/login.ts`: Authentication login handler
   - `src/api/routes.ts`: API route definitions
   - `config/settings.json`: Application configuration
   ```

2. **Check each file**
   ```
   For each file:
     - Verify file exists
     - Check file is readable
     - (Optional) Verify content matches description
   ```

3. **Report findings**
   - List verified files
   - Flag missing or problematic files

## Error Scenarios

### File Not Found

```
Issue: Key file not found
  - Path: src/auth/login.ts
  - Description: Authentication login handler

Severity: error

Suggestion:
  1. Check if file was moved: git log --follow src/auth/login.ts
  2. Search for similar file: find . -name "login.ts"
  3. Or remove from Key Files if no longer relevant
```

### File Moved

```
Issue: File appears to have moved
  - Documented: src/auth/login.ts (not found)
  - Possible match: src/features/auth/login.ts

Severity: warning

Suggestion:
  1. Verify if this is the same file
  2. Update CURRENT.md with new path
```

### Empty File

```
Issue: Key file is empty
  - Path: config/settings.json
  - Expected: Application configuration
  - Actual: 0 bytes

Severity: warning

Suggestion:
  1. Check git history: git log -p config/settings.json
  2. Restore from previous commit if needed
```

## Output Format

```yaml
aspect: file-integrity
status: pass | fail | warning
files_checked: 5
files_valid: 4
files_missing: 1
issues:
  - type: not_found | moved | empty | corrupted
    path: path/to/file
    description: Documented description
    message: What's wrong
    suggestion: How to resolve
verified:
  - path: src/auth/login.ts
    status: valid
  - path: src/api/routes.ts
    status: valid
```

## Scope Limitation

This aspect validates files explicitly listed in CURRENT.md only.
It does not perform full project file scanning (that would be too expensive).

**Checked:**
- Files in "Key Files" section
- Files mentioned in "Next Steps" with specific paths

**Not Checked:**
- All project files
- Dependencies in node_modules, etc.
- Build artifacts
