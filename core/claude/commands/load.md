---
description: Load session state from Master Plan (adaptive)
---

# Adaptive Session Load

Load previous session's state with Master Plan context and verification.

## Skills

Use `blueprint` skill for plan discovery and handoff operations:
- `blueprint frontis search` - Find plans by status
- `blueprint frontis show` - Read plan metadata
- `blueprint hermes after-load:{mode}` - View briefing format
- `blueprint hermes request:review:session-state` - Reviewer delegation format

---

## Plan Selection

### With Argument

```
/load {identifier}
```

| Format | Example | Matches |
|--------|---------|---------|
| Number only | `001` | `blueprint/plans/001-*/` |
| Text only | `auth` | `blueprint/plans/*-*auth*/` |
| Full format | `001-auth` | `blueprint/plans/001-auth/` |

### Without Argument

```
/load
```

1. Find active plans: `blueprint frontis search status in-progress blueprint/plans/`
2. Present list to user
3. User selects → Load session-context/

---

## Execution Flow

### Phase 1: Plan Resolution

```
IF argument provided:
    Resolve plan from identifier
ELSE:
    Use blueprint skill: frontis search status in-progress blueprint/plans/
    Present list to user
    Wait for selection
```

### Phase 2: Document Review (No Tools Yet)

Read and understand before verification:

1. **Read Plan Context:**
   - `{PLAN_PATH}/master-plan.md` - Phase definitions
   - `{PLAN_PATH}/ROADMAP.md` - Progress status

2. **Read Session Context:**
   - `{SESSION_PATH}/CURRENT.md` - Last session state
   - `{SESSION_PATH}/TODO.md` - Task list (if exists)

3. **Internal Summary:**
   - Plan: {name}
   - Current Phase: {N} - {name}
   - Previous work: {summary}
   - My task: {next steps from CURRENT.md}
   - Expected mode: {Quick/Standard/Compressed}

### Phase 3: State Verification (Reviewer Delegation)

Delegate to Reviewer SubAgent to preserve your context.

**Handoff:**
```
Use Task tool with subagent_type: reviewer

Construct prompt using: `blueprint hermes request:review:session-state`
- Replace {PLAN_PATH} with resolved plan path (e.g., blueprint/plans/001-auth)
```

**Process response:** `blueprint hermes response:review:session-state`
- `pass` → Proceed to Phase 4
- `warning` → Present warnings, proceed with user confirmation
- `fail` → Present issues, go to Error Recovery

### Phase 4: Handoff Briefing

Present briefing based on detected mode:

| Mode | Command |
|------|---------|
| Quick | `hermes after-load:quick` |
| Standard | `hermes after-load:standard` |
| Compressed | `hermes after-load:compressed` |

### Phase 5: User Confirmation

Wait for input:
- `yes` → Proceed with work
- `no` / `wait` → Pause for user review
- `explain {topic}` → Provide detail on topic
- `show {file}` → Display file content

---

## Mode Detection

```
IF no HISTORY.md OR HISTORY.md < 10 lines:
    mode = Quick
ELSE IF HISTORY.md 10-500 lines:
    mode = Standard
ELSE IF HISTORY.md > 500 lines OR archive/ exists:
    mode = Compressed
```

---

## Error Recovery

### Plan Not Found

```
⚠️ No plan matching '{identifier}' found.

Available plans:
- 001-auth (in-progress)
- 003-session (in-progress)

Try: /load 001 or /load auth
```

### No Active Plans

```
📋 No active Master Plans found.

Options:
1. Create new plan: /master
2. Load completed plan: /load {plan-id}

Which option?
```

### No Session Context

```
⚠️ No session context found for PLAN-{NNN}.

This appears to be a fresh plan (no previous sessions).

Options:
1. Start first session (will create session-context on /save)
2. Check if wrong plan selected

Which option? (1/2)
```

### Git Branch Mismatch

```
⚠️ Branch mismatch detected.

Expected: {convention}/{nnn}-{topic}
Current: {actual-branch}

Options:
1. Switch to expected branch
2. Continue on current branch
3. Create new branch matching plan

Which option? (1/2/3)
```

### Git Status Mismatch

```
⚠️ Uncommitted changes detected.

Options:
1. Review changes first (git diff)
2. Commit changes now
3. Continue anyway (will update docs on /save)

Which option? (1/2/3)
```

### Stale Context

```
⚠️ CURRENT.md may be stale.

Last updated: {date} ({N} days ago)
Git shows {M} commits since then.

Options:
1. Continue with existing context
2. Review git history first
3. Rebuild context from recent commits

Which option? (1/2/3)
```

### Line Limit Exceeded

```
⚠️ CURRENT.md is {X} lines (recommended: {Y} lines)

Large context files consume context window.

Limits:
- Quick: 100 lines
- Standard: 200 lines
- Compressed: 150 lines

Options:
1. Continue anyway (read full file)
2. Compress to HISTORY.md first
3. Ask user to summarize key points

Which option? (1/2/3)
```

---

## Verification Checklist

Before presenting briefing, verify:

- [ ] CURRENT.md exists and is readable
- [ ] Git status checked
- [ ] Key files verified (2-3 minimum)
- [ ] Briefing message is concise

---

## Integration with /save

| File | Required | Purpose |
|------|----------|---------|
| CURRENT.md | Yes | Core session state |
| TODO.md | No | Task tracking (Standard/Compressed) |
| HISTORY.md | No | Session log (Standard/Compressed) |
| ROADMAP.md | Yes | Phase progress |

### Graceful Adaptation

| Situation | Adaptation |
|-----------|------------|
| Missing TODO.md | Check CURRENT.md "Next Steps" |
| No HISTORY.md | Assume Quick task mode |
| Missing ROADMAP.md | Read phases from master-plan.md |

---

## Tips

### DO:
- ✅ Read everything before using tools
- ✅ Verify git status matches docs
- ✅ Present options when inconsistencies found
- ✅ Be concise in briefing

### DON'T:
- ❌ Auto-fix inconsistencies without asking
- ❌ Skip verification steps
- ❌ Start work before user confirmation
