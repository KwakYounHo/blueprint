---
description: Save session state for Master Plan handoff (adaptive)
---

# Adaptive Session Save

Save session state with Master Plan context for handoff to next session.

## Skills

Use `blueprint` skill for template and frontmatter operations:
- `blueprint forma copy` - Copy templates
- `blueprint frontis show` - Read frontmatter

## Plan Recognition

### Priority Order

1. **From CURRENT.md** (Primary)
   - Look for existing `session-context/CURRENT.md` in any plan directory
   - Read `plan-id` from frontmatter
   - IF found → Use this Plan

2. **From Git Branch** (Secondary)
   - Get current branch: `git branch --show-current`
   - Pattern match: `<convention>/<nnn>-<brief-summary>`
   - Extract `{nnn}` → Look for `blueprint/plans/{nnn}-*/`

3. **From Argument** (Override)
   - `/save 001` → Force save to PLAN-001
   - `/save auth` → Match `blueprint/plans/*-*auth*/`

### Resolution Logic

```
IF /save has argument:
    Resolve plan from argument
ELSE IF session-context/CURRENT.md exists in plan directory:
    Use plan-id from frontmatter
ELSE:
    Get current git branch
    IF matches pattern <convention>/<nnn>-*:
        Infer plan from {nnn}
        Confirm with user: "Saving to PLAN-{nnn}. Correct?"
    ELSE:
        Ask user to select plan or specify: /save <plan-id>
```

---

## Auto-detect Project Scale

Check `session-context/` in resolved plan:

| Condition | Mode |
|-----------|------|
| No HISTORY.md OR <10 lines | **Quick** (50-100 lines) |
| HISTORY.md 10-500 lines | **Standard** (200 lines max) |
| HISTORY.md >500 lines OR archive/ exists | **Compressed** (150 lines) |

---

## Execution Steps

### Step 1: Resolve Plan

```
Determine target plan (see Plan Recognition above)
Set: PLAN_PATH = blueprint/plans/{nnn}-{topic}/
Set: SESSION_PATH = {PLAN_PATH}/session-context/
```

### Step 2: Detect Mode

```
Check {SESSION_PATH}/HISTORY.md
Determine Quick/Standard/Compressed mode
```

### Step 3: Gather Information

**Standard gathering:**
- `git status`
- `git log -3 --oneline`
- Modified files
- Current TODO list (if exists)

**Master Plan gathering:**
- Read `{PLAN_PATH}/master-plan.md` for Phase info
- Read `{PLAN_PATH}/ROADMAP.md` for progress status
- Determine current Phase from CURRENT.md or ask user

**Ask user if unclear:**
- "Which phase are you working on?"
- "Key decisions this session?"
- "Any blockers to document?"

### Step 4: Write Files

**If first save (no CURRENT.md exists):**
```
Use blueprint skill: forma copy current {SESSION_PATH}
Use blueprint skill: forma copy todo {SESSION_PATH}
Use blueprint skill: forma copy history {SESSION_PATH}
```

**All modes - Update CURRENT.md:**
- Include Master Plan Context section
- Update `session-id` in frontmatter (increment)
- Update `current-phase` in frontmatter
- Fill in session-specific sections

**Standard/Compressed modes additionally:**
- Update TODO.md with progress
- Append session entry to HISTORY.md

**Update ROADMAP.md:**
- Move "← Current" marker to current phase
- Update phase status if changed

### Step 5: Self-check

- [ ] Plan context correctly recorded?
- [ ] Current Phase accurately reflected?
- [ ] Next agent can start with these files only?
- [ ] Under line limits? (Quick: 100, Standard: 200, Compressed: 150)
- [ ] Git status matches documentation?

### Step 6: Confirm

```
✅ Session state saved as [Quick/Standard/Compressed] mode.

📋 Master Plan: PLAN-{NNN} - {Name}
📍 Current Phase: Phase {N} - {Phase Name}
🔢 Session: {session-id}

Saved:
- {PLAN_PATH}/session-context/CURRENT.md ({X} lines)
[- {PLAN_PATH}/session-context/TODO.md]
[- {PLAN_PATH}/session-context/HISTORY.md (appended)]
- {PLAN_PATH}/ROADMAP.md (updated current marker)

Ready for next session. Use `/load {nnn}` to continue.
```

---

## CURRENT.md Template

```markdown
# Session Handoff

**Date:** {date}
**Branch:** {branch}

---

## Master Plan Context

**Plan:** PLAN-{NNN} - {Plan Name}
**Plan Path:** `../master-plan.md`
**Current Phase:** Phase {N} - {Phase Name}
**Phase Objective:** {from master-plan.md}

---

## Current Goal

{What we're working on - 2-3 sentences}

## Completed This Session

- {Accomplishment with file:line}
- Commit: {hash} - {message}

## Key Decisions Made

1. **{Decision}**: {Reasoning}

## Current State

**Git Status:** {clean/modified}
**Tests:** {passing/failing}
**Blockers:** {none or description}

## Next Agent Should

1. **{Action}**: {Specific task}
   - Context: {why}
   - Success criteria: {verification}

## Key Files

- `path/to/file`: {Purpose}

## References

- Master Plan: `../master-plan.md`
- ROADMAP: `../ROADMAP.md`
```

---

## Error Handling

### No Plan Found

```
⚠️ Cannot determine target plan.

Current branch: {branch} (no plan pattern detected)
No existing session context found.

Options:
1. Specify plan: /save 001 or /save auth
2. Create new plan first: /master

Which option?
```

### First Save for Plan

```
📋 First save for PLAN-{NNN} - {Plan Name}

Initializing session context...

Use blueprint skill: forma copy current {plan}/session-context/
Use blueprint skill: forma copy todo {plan}/session-context/
Use blueprint skill: forma copy history {plan}/session-context/

Session context initialized. Proceeding with save...
```

---

## Tips

- **Be specific:** Include file:line references
- **Explain decisions:** Future sessions need to know *why*
- **Keep it actionable:** Next steps should be clear actions
- **Verify git status:** Docs should match reality
- **Compress ruthlessly:** If over line limit, move details to HISTORY.md
