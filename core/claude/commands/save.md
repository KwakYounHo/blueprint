---
description: Save session state for Master Plan handoff (adaptive)
---

# Adaptive Session Save

Save session state with Master Plan context for handoff to next session.

## Blueprint Skill Reference

Load `/blueprint` skill for template and handoff operations. Execute commands in Bash using full path:

| Operation | Submodule + Subcommand |
|-----------|----------------------|
| Copy templates (RECOMMENDED) | `forma copy` |
| View template structure | `forma show` |
| Read frontmatter | `frontis show` |
| View confirmation format | `hermes after-save` |

---

## Plan Path Resolution

**First**, resolve the current project's plans directory:

```bash
PLANS_DIR=$(~/.claude/skills/blueprint/blueprint.sh project current --plans)
```

Use `{PLANS_DIR}` for all plan path references below.

---

## Plan Recognition

### Priority Order

1. **From CURRENT.md** (Primary)
   - Look for existing `session-context/CURRENT.md` in any plan directory
   - Read `plan-id` from frontmatter
   - IF found → Use this Plan

2. **From Git Branch** (Secondary)
   - Get current branch: `git branch --show-current`
   - Pattern match: `<convention>/<nnn>-<brief-summary>`
   - Extract `{nnn}` → Look for `{PLANS_DIR}/{nnn}-*/`

3. **From Argument** (Override)
   - `/save 001` → Force save to PLAN-001
   - `/save auth` → Match `{PLANS_DIR}/*-*auth*/`

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

| Condition | Mode | Template |
|-----------|------|----------|
| No HISTORY.md OR <10 lines | **Quick** (50-100 lines) | `current-quick` |
| HISTORY.md 10-500 lines | **Standard** (200 lines max) | `current-standard` |
| HISTORY.md >500 lines OR archive/ exists | **Compressed** (150 lines) | `current-compressed` |

---

## Execution Steps

### Step 1: Resolve Plan

```
Determine target plan (see Plan Recognition above)
Set: PLAN_PATH = {PLANS_DIR}/{nnn}-{topic}/
Set: SESSION_PATH = {PLAN_PATH}/session-context/
```

### Step 2: Detect Mode

```
Check {SESSION_PATH}/HISTORY.md
Determine Quick/Standard/Compressed mode
Select appropriate template
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

**Update CURRENT.md:**
- Include Master Plan Context section
- Update `session-id` in frontmatter (increment)
- Update `current-phase` in frontmatter
- Fill in session-specific sections

**Standard/Compressed modes additionally:**
- Update TODO.md with progress
- Append session entry to HISTORY.md (use `history-entry` template format)

**Update ROADMAP.md:**
- Move "← Current" marker to current phase
- Update phase status if changed

### Step 5: Check Implementation Notes

Ask user:
- "Any deviations from the plan this session?"
- "Issues encountered worth documenting?"
- "Learnings to record?"

If yes, update `{PLAN_PATH}/implementation-notes.md`:
- Add to Deviations table if plan changed
- Add ISSUE-NNN if problems occurred
- Add LEARN-NNN if insights gained

### Step 6: Self-check

- [ ] Plan context correctly recorded?
- [ ] Current Phase accurately reflected?
- [ ] Next agent can start with these files only?
- [ ] Under line limits? (Quick: 100, Standard: 200, Compressed: 150)
- [ ] Git status matches documentation?
- [ ] Implementation notes updated if needed?

### Step 7: Confirm

Use confirmation format: `blueprint hermes after-save`

---

## Mode-Specific Templates

| Mode | Template | Use Case |
|------|----------|----------|
| Quick | `forma copy current-quick` | 1-2 sessions, simple tasks |
| Standard | `forma copy current-standard` | 3-10 sessions, multi-phase |
| Compressed | `forma copy current-compressed` | 10+ sessions, epic projects |

**View template:** `blueprint forma show current-{mode}`

---

## Supporting Templates

| Template | Purpose | Usage |
|----------|---------|-------|
| `todo-structure` | Task tracking structure | `forma show todo-structure` |
| `history-entry` | Session append format | `forma show history-entry` |

**Append Rules for HISTORY.md:**
- Add separator `---` before each entry
- Increment session-count in frontmatter
- Keep entries in reverse chronological order (newest first)
- If HISTORY.md > 500 lines, suggest `/checkpoint`

---

## User Override

| User Says | Action |
|-----------|--------|
| "Save as quick handoff" | Force Quick mode |
| "Save quick" | Force Quick mode |
| `/save --quick` | Force Quick mode |
| "Save checkpoint" | Suggest `/checkpoint` instead |
| "Save as standard" | Force Standard mode |

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

## Compressed Mode Details

When HISTORY.md > 500 lines OR archive/ exists:

### Compress CURRENT.md

**Target:** 150 lines maximum

**Actions:**
- Keep only current phase context
- Move completed phase details to HISTORY.md
- Link to archived sessions
- Remove verbose descriptions

### Suggest Checkpoint

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

---

## Automatic /checkpoint Suggestion

Suggest `/checkpoint` when ANY condition is true:

| Condition | Threshold |
|-----------|-----------|
| HISTORY.md size | > 500 lines |
| Sessions since last checkpoint | > 10 |
| Archive directory | Exists AND current phase completed |
| Phase transition | User mentions phase complete |

---

## Additional Error Scenarios

### CURRENT.md External Modification

```
⚠️ CURRENT.md has been modified outside this session.

Options:
1. Backup and overwrite (save backup as CURRENT.md.bak)
2. Append to existing (merge this session's work)
3. Review changes first (show diff)

Which option? (1/2/3)
```

### Concurrent Session Warning

```
⚠️ Another session may be active.

CURRENT.md was modified {X} minutes ago.

Options:
1. Continue anyway (may overwrite other session's work)
2. Wait and check again
3. Create backup and continue

Which option? (1/2/3)
```

---

## Tips

- **Be specific:** Include file:line references
- **Explain decisions:** Future sessions need to know *why*
- **Keep it actionable:** Next steps should be clear actions
- **Verify git status:** Docs should match reality
- **Compress ruthlessly:** If over line limit, move details to HISTORY.md
