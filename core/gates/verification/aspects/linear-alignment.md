---
type: aspect
status: active
version: 1.0.0
created: 2026-03-13
updated: 2026-03-13
tags: [aspect, verification, linear, optional]
dependencies: [../gate.md]

name: linear-alignment
gate: verification
description: "Optional: validates Linear issue alignment with Plan scope"
---

# Aspect: Linear Alignment

## Description

Optional aspect that validates the source Linear issue aligns with the Plan scope and implementation. Skipped when BRIEF.md `source-discussion` is `null` or when `--no-linear` flag is set.

## Skip Conditions

This aspect is **skipped** (status: `skip`) when:
- BRIEF.md FrontMatter `source-discussion` is `null` or empty
- `/verify` invoked with `--no-linear` flag
- Linear MCP tool (`mcp__linear__get_issue`) is unavailable

When skipped, report `status: skip` with reason.

## Criteria

### Required (Must Pass)

#### Issue-Plan Alignment
- [ ] Linear issue title/description aligns with PLAN.md scope
- [ ] Linear issue is not closed or cancelled (unless implementation is complete)
- [ ] Linear issue project/team matches expected context

### Recommended (Should Pass)

#### Implementation Coverage
- [ ] Implementation addresses the problem described in the Linear issue
- [ ] No major aspects of the Linear issue are unaddressed
- [ ] Linear issue labels/priority are consistent with implementation scope

## Validation Method

1. **Read BRIEF.md FrontMatter** — Extract `source-discussion` value
2. **Check skip conditions** — If null or `--no-linear`, return `skip`
3. **Fetch Linear issue** — `mcp__linear__get_issue` with issue ID
4. **Read PLAN.md** — Extract scope and success criteria
5. **Cross-reference**
   - Compare Linear issue description with Plan scope
   - Verify implementation addresses the described problem
6. **Report** — Alignment status with evidence

## Error Scenarios

### Scope Mismatch

```
Issue: Linear issue scope differs from Plan scope
  - Linear: "Add user authentication to API endpoints"
  - Plan: "Refactor authentication middleware"
  - Evidence: Linear describes new feature; Plan describes refactoring

Severity: warning

Suggestion:
  1. Verify with stakeholders which scope is correct
  2. Update Linear issue or Plan to align
```

### Issue Not Found

```
Issue: Linear issue not accessible
  - Issue ID: from BRIEF.md source-discussion
  - Error: Issue not found or access denied

Severity: warning

Suggestion:
  1. Verify issue ID in BRIEF.md is correct
  2. Check Linear access permissions
  3. Use --no-linear flag to skip this aspect
```

## Output Format

Follow `hermes response:review:verification` form — `checks.linear-alignment` block.
