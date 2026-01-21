---
description: Load session state from Master Plan (adaptive)
---

# Adaptive Session Load

Load previous session's state with Master Plan context and verification.

## Blueprint Skill Reference

Load `/blueprint` skill for plan discovery and handoff operations. Execute commands in Bash using full path:

| Operation | Submodule + Subcommand |
|-----------|----------------------|
| Find plans by status | `frontis search` |
| Read plan metadata | `frontis show` |
| View briefing format | `hermes after-load:{mode}` |
| Reviewer delegation | `hermes request:review:session-state` |

---

## Plan Path Resolution

**Get plans directory:**
```bash
~/.claude/skills/blueprint/blueprint.sh plan dir
```

**Resolve specific plan:**
```bash
~/.claude/skills/blueprint/blueprint.sh plan resolve 001   # → /path/to/plans/001-topic/
~/.claude/skills/blueprint/blueprint.sh plan resolve auth  # → /path/to/plans/NNN-auth-feature/
```

**List active plans:**
```bash
~/.claude/skills/blueprint/blueprint.sh plan list --status in-progress
```

> **Note**: Each plan is a **directory** containing master-plan.md, ROADMAP.md, session-context/, etc.

After plan selection (Phase 1), set:
- `{PLAN_PATH}` = resolved plan path (e.g., from `~/.claude/skills/blueprint/blueprint.sh plan resolve 001`)
- `{SESSION_PATH}` = `{PLAN_PATH}/session-context/`

Use these paths for all references below.

---

## Plan Selection

### With Argument

```
/load {identifier}
```

| Format | Example | Matches |
|--------|---------|---------|
| Number only | `001` | `{PLANS_DIR}/001-*/` |
| Text only | `auth` | `{PLANS_DIR}/*-*auth*/` |
| Full format | `001-auth` | `{PLANS_DIR}/001-auth/` |

### Without Argument

```
/load
```

1. Find active plans: `~/.claude/skills/blueprint/blueprint.sh plan list --status in-progress`
2. Present list to user
3. User selects → Use `~/.claude/skills/blueprint/blueprint.sh plan resolve <selection>` to get path

---

## Execution Flow

### Phase 1: Plan Resolution

```
IF argument provided:
    Resolve plan: ~/.claude/skills/blueprint/blueprint.sh plan resolve <identifier>
ELSE:
    List active plans: ~/.claude/skills/blueprint/blueprint.sh plan list --status in-progress
    Present list to user
    Wait for selection
    Resolve selected: ~/.claude/skills/blueprint/blueprint.sh plan resolve <selection>
```

### Phase 2: Document Review (No Tools Yet)

Read and understand before verification:

1. **Read Plan Context:**
   - `{PLAN_PATH}/master-plan.md` - Phase definitions
   - `{PLAN_PATH}/ROADMAP.md` - Progress status
   - `{PLAN_PATH}/implementation-notes.md` - Deviations and issues

2. **Read Session Context:**
   - `{SESSION_PATH}/CURRENT.md` - Last session state
   - `{SESSION_PATH}/TODO.md` - Task list (if exists)

3. **Internal Summary:**
   - Plan: {name}
   - Current Phase: {N} - {name}
   - Current Task: {T-N.M} - {task name}
   - Task Objective: {deliverable from master-plan.md}
   - Previous work: {summary}
   - My task: {next steps from CURRENT.md}
   - Expected mode: {Quick/Standard/Compressed}

### Phase 3: State Verification (Reviewer Delegation)

Delegate to Reviewer SubAgent to preserve your context.

**Handoff:**
```
Use Task tool with subagent_type: reviewer

Construct prompt using: `blueprint hermes request:review:session-state`
- Replace {PLAN_PATH} with resolved plan path (e.g., {PLANS_DIR}/001-auth)
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
- `yes` → **IMPORTANT**: Follow Plan Mode Strategy in `master-plan.md` (if plan in-progress)
- `no` / `wait` → Pause for user review
- `explain {topic}` → Provide detail on topic
- `show {file}` → Display file content

> **IMPORTANT**: On `yes`, you MUST follow the **Plan Mode Strategy** section in `{PLAN_PATH}/master-plan.md`.
> This invokes Phase Analyzer Agent for scope analysis and Plan Mode recommendation.
> Do NOT skip this step - it ensures appropriate planning depth for each Phase.

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
