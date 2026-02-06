---
type: aspect
status: active
version: 1.0.0
created: 2026-02-06
updated: 2026-02-06
tags: [aspect, session, analysis, completeness, validation]
dependencies: [../gate.md]

name: analysis-completeness
gate: session
description: "Validates that Plan Analysis Results are populated for the current Phase"
---

# Aspect: Analysis Completeness

## Description

Validates that the Plan's Analysis Results section contains Plan Mode decisions for the current Phase.
This is an advisory-only aspect — it never causes a gate failure, only warnings.

## Criteria

### Required (Must Pass)

None — this aspect is advisory only.

### Recommended (Should Pass)

#### Selected Strategies Entry
- [ ] PLAN.md "Analysis Results > Selected Strategies" table has an entry for the current Phase
- [ ] Entry has non-empty `Selected` column
- [ ] Entry has non-empty `Rationale` column

#### Phase Summaries Entry
- [ ] PLAN.md "Analysis Results > Phase Summaries" table has data for the current Phase

## Validation Method

1. **Read PLAN.md**, locate `## Analysis Results` section
2. If section not found → warning: "No Analysis Results section found"
3. Parse `### Selected Strategies` table
4. Find row matching current Phase number (from CURRENT.md `current-phase`)
5. Check `Selected` and `Rationale` columns are non-empty
6. Parse `### Phase Summaries` table, find matching row

## Error Scenarios

### No Analysis Results Section

```
Issue: No "Analysis Results" section in PLAN.md

Severity: warning

Suggestion:
  Plan may predate /banalyze. Consider running /banalyze.
```

### Empty Analysis Results

```
Issue: Analysis Results section exists but empty

Severity: warning

Suggestion:
  Run /banalyze to populate Analysis Results before implementation.
```

### Missing Phase Entry

```
Issue: Current Phase has no entry in Selected Strategies
  - Current Phase: {N}
  - Selected Strategies table: no row for Phase {N}

Severity: warning

Suggestion:
  Phase {N} has no Plan Mode decision. Run /banalyze to analyze.
```

### All Checks Pass

```
Status: pass

No suggestion needed.
```

## Output Format

```yaml
analysis-completeness:
  status: pass | warning
  current_phase: {N}
  selected_strategy_present: true | false
  phase_summary_present: true | false
  issues:
    - type: no_section | empty_section | missing_phase_entry
      message: Description
      suggestion: How to resolve
```

## Usage Context

### In `/load`

Validates before resuming work:
- Checks if Plan Mode decisions exist for the current Phase
- Suggests running `/banalyze` if Analysis Results are empty
- Advisory only — does not block session load
