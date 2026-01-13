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

Ready? (yes/no)
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

Proceed? (yes/no/explain {topic})
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

**Long-term Goal:** {from master-plan}
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

Proceed? (yes/no/explain {topic})
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
  files:
    - "{PLAN_PATH}/session-context/CURRENT.md"
    - "{PLAN_PATH}/ROADMAP.md"
  gate: session
  aspects:
    - git-state
    - file-integrity
    - plan-progress
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
