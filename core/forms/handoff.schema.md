---
type: schema
status: active
version: 3.0.0
created: "{{date}}"
updated: "{{date}}"
tags: [schema, handoff, objective, communication]
dependencies: []
---

# Handoff Forms

Defines Handoff forms for commands and review requests.

Use **Hermes** skill to view specific forms:
- `hermes after-save` - Command completion output
- `hermes after-load:quick` - Quick mode briefing
- `hermes request:review:session-state` - Review request format
- `hermes request:phase-analysis` - Phase analysis request format
- `hermes response:phase-analysis` - Phase analysis response format
- `hermes request:review:document-schema:session` - Document schema review for /load
- `hermes request:review:document-schema:checkpoint` - Document schema review for /checkpoint
- `hermes --list` - List all forms

---

## Session Commands

OBJECTIVE[after-save]
---s
```
✅ Session saved as {mode} mode.

📋 Plan: PLAN-{NNN} - {Name}
📍 Phase: {N} - {Phase Name}
🔢 Session: {session-id}

Saved:
- {SESSION_PATH}/CURRENT.md ({X} lines)
[- {SESSION_PATH}/TODO.md]
[- {SESSION_PATH}/HISTORY.md (appended)]
- {PLAN_PATH}/ROADMAP.md (updated)

Ready for next session: `/load {nnn}`
```
---e

OBJECTIVE[after-load:quick]
---s
```
Previous: {one sentence summary}
Goal: {one sentence goal}
Status: {pass/issues}

Next:
1. {action 1}
2. {action 2}
3. {action 3}

[INFER: contextual next action from session context]
```
---e

OBJECTIVE[after-load:standard]
---s
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📥 HANDOFF RECEIVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Plan:** PLAN-{NNN} - {Plan Name}
**Phase:** {N} of {Total} - {Phase Name}
**Previous:** {Date} (Session {N})

**Completed:** {summary}
**Goal:** {current goal}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Status Check:**
✅ Git branch: {branch}
✅ Files verified: {N} files
[⚠️ {warning if any}]

**Next:** {first action}

[INFER: contextual next action from session context and Analysis Results]
```
---e

OBJECTIVE[after-load:compressed]
---s
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📥 HANDOFF RECEIVED (Epic)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Plan:** PLAN-{NNN} - {Plan Name}
**Phase:** {N} of {Total} - {Phase Name}
**Sessions:** {total count}

**Long-term Goal:** {from PLAN.md}
**Previous Phase:** {archived summary}
**Archive:** `session-context/archive/{DATE}/`

**Current Phase Progress:**
- Started: {date}
- Sessions: {N}
- Status: {progress}

**Previous Session:** {Date}
- {key accomplishment}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Status:** {pass/issues}
**Next:** {first action}

[INFER: contextual next action from session context and Analysis Results]
```
---e

OBJECTIVE[after-checkpoint]
---s
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🏁 CHECKPOINT COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Phase Archived:** Phase {N} - {Name}
**Duration:** {start} to {end}
**Sessions:** {X} sessions archived

**Created:**
✅ archive/{DATE}/CHECKPOINT-SUMMARY.md
✅ archive/{DATE}/CURRENT.md (snapshot)
✅ archive/{DATE}/TODO.md (snapshot)
✅ archive/{DATE}/HISTORY.md (snapshot)

**Updated:**
✅ CURRENT.md (reset for Phase {N+1})
✅ TODO.md (next phase milestones)
✅ HISTORY.md (compressed to {X} lines)
✅ ROADMAP.md (Phase {N} marked complete)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ready to start Phase {N+1}: {Phase Name}

Next step: {First task of new phase}

Use `/load {nnn}` to begin next session.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
---e

---

## Review Objectives

OBJECTIVE[request:review:session-state]
---s
```yaml
task:
  action: review
  context: session-state
  response-form: "response:review:session-state"
  files:
    - "{PLAN_PATH}/session-context/CURRENT.md"
    - "{PLAN_PATH}/ROADMAP.md"
    - "{PLAN_PATH}/PLAN.md"
  gate: session
  aspects:
    - git-state
    - file-integrity
    - plan-progress
    - analysis-completeness
```
---e

OBJECTIVE[response:review:session-state]
---s
```yaml
handoff:
  status: pass | fail | warning
  gate: session
  summary: "{human-readable summary}"
  checks:
    git-state:
      status: pass | fail
      issues: [...]
    file-integrity:
      status: pass | fail
      issues: [...]
    plan-progress:
      status: pass | fail
      issues: [...]
    analysis-completeness:
      status: pass | warning
      issues: [...]
  suggestions:
    - "{how to resolve issue}"
```
---e

OBJECTIVE[request:review:phase-completion]
---s
```yaml
task:
  action: review
  context: phase-completion
  response-form: "response:review:phase-completion"
  files:
    - "{PLAN_PATH}/session-context/CURRENT.md"
    - "{PLAN_PATH}/session-context/TODO.md"
    - "{PLAN_PATH}/ROADMAP.md"
  gate: session
  aspects:
    - phase-completion
```
---e

OBJECTIVE[response:review:phase-completion]
---s
```yaml
handoff:
  status: pass | fail | warning
  gate: session
  context: phase-completion
  phase_checked: {N}
  summary: "{human-readable summary}"
  checks:
    phase-completion:
      status: pass | fail | warning
      tasks:
        total: {N}
        completed: {N}
        incomplete: {N}
      git_clean: true | false
      blockers_resolved: true | false
      issues: [...]
  suggestions:
    - "{how to resolve issue}"
```
---e

OBJECTIVE[request:review:document-schema:session]
---s
```yaml
task:
  action: review
  context: document-schema-session
  response-form: "response:review:document-schema"
  files:
    - "{PLAN_PATH}/session-context/CURRENT.md"
    - "{PLAN_PATH}/session-context/TODO.md"
    - "{PLAN_PATH}/ROADMAP.md"
    - "{PLAN_PATH}/session-context/HISTORY.md"
  gate: documentation
  aspects:
    - schema-validation
  note: "Validate files exist before checking. Skip gracefully if optional file (TODO.md, HISTORY.md) is missing."
```
---e

OBJECTIVE[request:review:document-schema:checkpoint]
---s
```yaml
task:
  action: review
  context: document-schema-checkpoint
  response-form: "response:review:document-schema"
  files:
    - "{PLAN_PATH}/session-context/CURRENT.md"
    - "{PLAN_PATH}/session-context/TODO.md"
    - "{PLAN_PATH}/ROADMAP.md"
    - "{PLAN_PATH}/session-context/HISTORY.md"
    - "{PLAN_PATH}/PLAN.md"
    - "{PLAN_PATH}/BRIEF.md"
    - "{PLAN_PATH}/session-context/archive/{YYYY-MM-DD}/CHECKPOINT-SUMMARY.md"
  gate: documentation
  aspects:
    - schema-validation
  note: "Validate files exist before checking. Skip gracefully if optional file is missing."
```
---e

OBJECTIVE[response:review:document-schema]
---s
```yaml
handoff:
  status: pass | fail | warning
  gate: documentation
  summary: "{human-readable summary}"
  files_checked: {N}
  files_skipped: {N}
  checks:
    schema-validation:
      status: pass | fail | warning
      results:
        - file: "{path}"
          type: "{document type}"
          schema: "{type}.schema.md"
          status: pass | fail
          issues:
            - field: "{field name}"
              expected: "{schema constraint}"
              actual: "{found value}"
              suggestion: "{how to fix}"
      issues: [...]
  suggestions:
    - "{how to resolve issue}"
```
---e

---

## Phase Analysis Objectives

OBJECTIVE[request:phase-analysis]
---s
```yaml
task:
  action: analyze
  context: phase-analysis
  response-form: "response:phase-analysis"
  plan: "{path to PLAN.md}"
  phase: {N}
```
---e

OBJECTIVE[response:phase-analysis]
---s
```yaml
handoff:
  status: completed | blocked
  context: phase-analysis
  phase: {N}

  task_analysis:
    - task_id: "T-{N}.{M}"
      deliverable: "{description}"
      scores:
        change_volume: {1-4}
        structural_complexity: {1-4}
        dependency: {1-4}
        precedent: {1-4}
        change_type: {1-4}
      total: {5-20}
      grade: Simple | Moderate | Complex | Critical
      evidence:
        - dimension: "{dimension name}"
          observation: "{what was found}"
          files: ["{file1}", "{file2}"]

  phase_summary:
    task_count: {N}
    grade_distribution:
      simple: {N}
      moderate: {N}
      complex: {N}
      critical: {N}
    highest_complexity: "T-{N}.{M}"

  task_dependencies:
    - from: "T-{N}.{M}"
      to: "T-{N}.{M}"
      type: file | data | structural | resource
      reason: "{why dependent}"

  independent_groups:
    - group: {N}
      tasks: ["T-{N}.{M}", ...]
      reason: "{why independent}"

  execution_layers:
    - layer: {N}
      tasks: ["T-{N}.{M}", ...]
      blocked_by: [{layer numbers}]

  recommendation:
    strategy: "No Plan Mode" | "Phase-level" | "Task-level"
    rationale: "{reasoning}"
    alternatives:
      - strategy: "{alternative}"
        trade_off: "{consideration}"
```
---e

OBJECTIVE[response:phase-analysis:blocked]
---s
```yaml
handoff:
  status: blocked
  context: phase-analysis
  reason: "{specific issue - e.g., Plan not found, Phase not found}"
  suggestion: "{how to resolve - e.g., check file path, verify Phase number}"
```
---e
