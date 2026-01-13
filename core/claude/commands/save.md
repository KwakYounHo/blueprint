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

---

## User Override

User can override auto-detected mode:

| User Says | Action |
|-----------|--------|
| "Save as quick handoff" | Force Quick mode |
| "Save quick" | Force Quick mode |
| `/save --quick` | Force Quick mode |
| "Save checkpoint" | Suggest `/checkpoint` instead |
| "Save as standard" | Force Standard mode |

**Example:**
```
User: Save as quick handoff
Agent: Saving in Quick mode (overriding auto-detected Standard mode)...
```

---

## Mode-Specific CURRENT.md Templates

### Quick Mode (50-100 lines)

For simple tasks (1-2 sessions):

```markdown
# Session Handoff

**Date:** {date}
**Branch:** {branch}

## Goal

{One sentence: what we're trying to achieve}

## Completed This Session

- {Specific accomplishment with file:line}
- Commit: {yes/no - hash if yes}

## Current State

**Git Status:** {clean/modified files summary}
**Tests:** {passing/failing}
**Blockers:** {none or specific issue}

## Next Steps

1. {Actionable item with file name}
2. {Actionable item with file name}
3. {Actionable item with file name}

## Key Files

- `path/to/file.ts`: {what it does}
```

### Standard Mode (200 lines max)

For multi-session tasks (3-10 sessions):

```markdown
# Session Handoff - Session {N}

**Date:** {date}
**Branch:** {branch}
**Status:** Phase {N} - Task {Y}

---

## Master Plan Context

**Plan:** PLAN-{NNN} - {Plan Name}
**Plan Path:** `../master-plan.md`
**Current Phase:** Phase {N} - {Phase Name}
**Phase Objective:** {from master-plan.md}

---

## This Session Completed

- {Detailed completion with file paths and line numbers}
- {Key changes made}
- Commits: {hash} - {message}

## Current Goal

{2-3 sentences: what we're building and why}

## Key Decisions Made

1. **{Decision}**: {Reasoning}
2. **{Decision}**: {Reasoning}

## Current State

**Git Status:**
- Modified: {files}
- Staged: {files}
- Untracked: {files}

**Tests:** {X passing, Y failing - specifics}
**Blockers:** {None or detailed description}

## Next Agent Should

1. **{Action}**: {Specific task with file:line}
   - Expected time: {estimate}
   - Success criteria: {how to verify}

2. **{Action}**: {Specific task}
   - Context: {why this matters}

## Key Files

- `path/to/file.ts` (Lines X-Y): {Purpose and state}
- `path/to/another.ts`: {Purpose}

## References

- Master Plan: `../master-plan.md`
- ROADMAP: `../ROADMAP.md`
- ADR: {if applicable}
- Related Issues: {links}
```

### Compressed Mode (150 lines)

For epic projects (10+ sessions):

```markdown
# Session Handoff - Session {N}

**Date:** {date}
**Branch:** {branch}
**Phase:** {N} of {Total}

---

## Context

**Plan:** PLAN-{NNN}
**Phase:** {Phase Name}
**Previous Archives:** See `archive/{DATE}/`

---

## This Session

**Completed:** {1-2 sentences}
**Commits:** {hash} - {message}

## Current State

**Git:** {clean/modified}
**Tests:** {pass/fail}
**Blockers:** {none/description}

## Next Steps

1. {Action}: {Task}
2. {Action}: {Task}

## Key Files

- `path/to/file`: {Purpose}

---

*Full history: HISTORY.md | Archives: archive/*
```

---

## TODO.md Structure Guide

Standard structure for session task tracking:

```markdown
# TODO - {Plan Name}

**Current Phase:** {N}

---

## In Progress (Current Session)

- [ ] {Task description with context}
  - File: {path/to/file}
  - Blocker: {none or description}

## Next Up (This Phase)

- [ ] {Milestone 1}
  - [ ] Subtask A
  - [ ] Subtask B
- [ ] {Milestone 2}

## Backlog (Future Phases)

### Phase {N+1}: {Name}
- [ ] {High-level goal}

### Phase {N+2}: {Name}
- [ ] {High-level goal}

---

## Completed (This Phase)

- [x] {Completed task} (Session {N})
- [x] {Completed task} (Session {N-1})
```

---

## HISTORY.md Append Format

When appending session entry to HISTORY.md:

```markdown
---

## Session {ID} - {YYYY-MM-DD}

**Phase:** Phase {N} - {Phase Name}
**Goal:** {What we tried to achieve}
**Outcome:** {What we actually did}

**Key Decisions:**
- {Decision 1}
- {Decision 2}

**Files Changed:**
- {file path 1}
- {file path 2}

**Commits:**
- {hash}: {message}

**Next:** {Pointer to what comes next}
```

**Append Rules:**
- Add separator `---` before each entry
- Increment session-count in frontmatter
- Keep entries in reverse chronological order (newest first)
- If HISTORY.md > 500 lines, suggest `/checkpoint`

---

## Compressed Mode Details

When HISTORY.md > 500 lines OR archive/ exists:

### Step 1: Compress CURRENT.md

**Target:** 150 lines maximum

**Actions:**
- Keep only current phase context
- Move completed phase details to HISTORY.md
- Link to archived sessions
- Remove verbose descriptions

### Step 2: Suggest Checkpoint

```
⚠️ Project has grown significantly.

HISTORY.md: {X} lines (limit: 500)
Sessions since last checkpoint: {N}

Consider using `/checkpoint` to:
- Archive current phase
- Compress HISTORY.md
- Reset for fresh start

Run /checkpoint now? (yes/no)
```

### Step 3: Apply Compression

If user declines checkpoint:
- Write compressed CURRENT.md (150 lines)
- Add reference links to HISTORY.md
- Continue with save

---

## Automatic /checkpoint Suggestion

Suggest `/checkpoint` when ANY condition is true:

| Condition | Threshold |
|-----------|-----------|
| HISTORY.md size | > 500 lines |
| Sessions since last checkpoint | > 10 |
| Archive directory | Exists AND current phase completed |
| Phase transition | User mentions phase complete |

**Suggestion Message:**
```
💡 Checkpoint Recommended

Conditions detected:
- HISTORY.md: {X} lines (> 500)
- Sessions: {N} since last checkpoint

A checkpoint will:
1. Archive current phase
2. Compress HISTORY.md
3. Reset CURRENT.md for next phase

Run /checkpoint instead? (yes/no)
```

---

## Additional Error Scenarios

### CURRENT.md External Modification

Detect when CURRENT.md was modified outside the session:

```
⚠️ CURRENT.md has been modified outside this session.

Last known state:
- Session ID: {N}
- Date: {date}

Current file shows:
- Session ID: {M} (different)
- Modified: {timestamp}

Options:
1. Backup and overwrite (save backup as CURRENT.md.bak)
2. Append to existing (merge this session's work)
3. Review changes first (show diff)

Which option? (1/2/3)
```

**Detection Method:**
- Compare session-id in frontmatter with expected
- Check file modification timestamp
- Look for unexpected content changes

### Concurrent Session Warning

```
⚠️ Another session may be active.

CURRENT.md was modified {X} minutes ago.
This could indicate:
- Another Claude Code session is working on this plan
- Manual edits were made

Options:
1. Continue anyway (may overwrite other session's work)
2. Wait and check again
3. Create backup and continue

Which option? (1/2/3)
```
