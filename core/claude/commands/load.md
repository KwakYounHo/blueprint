---
description: Load session state from Plan (adaptive)
---

# Adaptive Session Load

Load previous session's state with Plan context and verification.

## Blueprint Skill Reference

Load `/blueprint` skill for plan discovery and handoff operations. Execute commands in Bash using full path:

| Operation | Submodule + Subcommand |
|-----------|----------------------|
| Find plans by status | `frontis search` |
| Read plan metadata | `frontis show` |
| View briefing format | `hermes after-load:{mode}` |
| Reviewer delegation (session) | `hermes request:review:session-state` |
| Reviewer delegation (schema) | `hermes request:review:document-schema:session` |

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

> **Note**: Each plan is a **directory** containing PLAN.md, ROADMAP.md, session-context/, etc.

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

### Phase 1.5: Start Background Verification

Immediately after Plan Resolution, spawn **two** Reviewers as background tasks in parallel:

**Reviewer 1: Session State** (existing)
```
Use Task tool with subagent_type: reviewer
run_in_background: true

Construct prompt using: `blueprint hermes request:review:session-state`
- Replace {PLAN_PATH} with resolved plan path
```

**Reviewer 2: Document Schema** (ADR-007)
```
Use Task tool with subagent_type: reviewer
run_in_background: true

Construct prompt using: `blueprint hermes request:review:document-schema:session`
- Replace {PLAN_PATH} with resolved plan path
```

Spawn both Reviewers in a single message (parallel). Do NOT wait for either to complete. Proceed immediately to Phase 2.

### Phase 2: Document Review

Read and understand plan context (in parallel where possible):

1. **Read Plan Context:**
   - `{PLAN_PATH}/PLAN.md` - Phase definitions
   - `{PLAN_PATH}/ROADMAP.md` - Progress status
   - `{PLAN_PATH}/implementation-notes.md` - **[ACTIVE] entries only** (see Selective Loading below)

2. **Read Session Context:**
   - `{SESSION_PATH}/CURRENT.md` - Last session state
   - `{SESSION_PATH}/TODO.md` - Task list (if exists)

3. **Internal Summary:**
   - Plan: {name}
   - Current Phase: {N} - {name}
   - Current Task: {T-N.M} - {task name}
   - Task Objective: {deliverable from PLAN.md}
   - Previous work: {summary}
   - My task: {next steps from CURRENT.md}
   - Expected mode: {Quick/Standard/Compressed}

#### Selective Loading: implementation-notes.md

When reading `implementation-notes.md`:
- Read only ISSUE entries with `[ACTIVE]` in the heading
- Skip entries with `[RESOLVED]` in the heading (count them for summary)
- Always read: Deviations table, Learnings, Environment Notes (these are small)
- Report: "{N} active issues, {M} resolved (archived)"

### Phase 2.5: Environment Verification

Verify working environment readiness.
Environment **creation** is handled by `/banalyze` Step 10. This phase only **verifies**.

```
project_type = check Blueprint registry type via `blueprint project show`

IF project_type == "bare":
    IF in wrapper directory (not inside a worktree):
        Show Bare Repo Worktree Warning
        Wait for user selection
        IF user selects "Cancel":
            Abort /load
ELSE:
    HIGH_LEVEL_BRANCHES = [main, master, develop, release]
    current_branch = git branch --show-current

    IF current_branch IN HIGH_LEVEL_BRANCHES:
        Show High-Level Branch Warning
        Wait for user selection
        IF user selects "Cancel":
            Abort /load
```

### Phase 3: Yield for Reviewers

After completing Phase 2 and 2.5, **end your current turn immediately**.

**CRITICAL**:
- Do NOT use `TaskOutput` or `Read` to poll any Reviewer's output
- Do NOT synthesize or guess the Reviewer results
- Do NOT present any status summary or document review results yet

Both Reviewers' completion signals will arrive automatically after your turn ends.
End your turn with a brief message that conveys:
- The Reviewer results will arrive shortly and processing will resume automatically
- The user just needs to wait a moment

Do NOT include any document review results, status summaries, or internal notes.
All briefing content will be presented together in Phase 4.

### Phase 4: Receive Reviewers + Handoff Briefing

When both Reviewer completion signals have arrived:

1. **Process Session Reviewer response:** `blueprint hermes response:review:session-state`
   - `pass` → Continue
   - `warning` → Include warnings in briefing
   - `fail` → Present issues, go to Error Recovery

2. **Process Document Schema Reviewer response:** `blueprint hermes response:review:document-schema`
   - `pass` → Continue
   - `warning` → Include FrontMatter warnings in briefing
   - `fail` → Present FrontMatter violations, ask user to fix before proceeding

3. **Present briefing** based on detected mode:

| Mode | Command |
|------|---------|
| Quick | `hermes after-load:quick` |
| Standard | `hermes after-load:standard` |
| Compressed | `hermes after-load:compressed` |

**[INFER] Resolution**: The Handoff form ends with an `[INFER]` marker.
Fill this dynamically by synthesizing:
- CURRENT.md "Next Agent Should" section
- PLAN.md "Analysis Results > Selected Strategies" (if populated)
- implementation-notes.md active blockers (if any)

Generate a contextual next-action suggestion instead of a generic "Proceed?" prompt.

### Phase 5: User Confirmation

Wait for user response to the [INFER] suggestion.

On confirmation:
1. Read PLAN.md "Analysis Results > Selected Strategies" for current Phase
2. If populated → Follow the Selected Plan Mode via "Task Execution Flow" in PLAN.md
3. If empty → Inform user: "Analysis Results is empty. Run `/banalyze` to analyze
   all Phases and select Plan Mode strategies before starting implementation."

On decline or request for more info:
- Provide requested detail
- Wait for further instruction

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
📋 No active Plans found.

Options:
1. Create new plan: /bplan
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

Which option? (1/2)
```

### High-Level Branch Warning

```
⚠️ High-level branch detected.

Current branch: {branch-name}
High-level branches (main, master, develop, release) are protected.

Plan-based work should typically be on a feature branch.
Branch creation is handled by /banalyze Step 10.

Options:
1. Continue on current branch (acknowledge risk)
2. Cancel — run /banalyze first to create feature branch

Which option? (1/2)
```

### Bare Repo Worktree Warning

```
⚠️ Bare repo: not in a worktree.

You are in the wrapper directory, not a dedicated worktree.
Plan-based work should be in a worktree with its own branch.
Worktree creation is handled by /banalyze Step 10.

Options:
1. Continue anyway (acknowledge risk)
2. Cancel — run /banalyze first to create worktree

Which option? (1/2)
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
- [ ] Both Reviewer completion signals received before briefing (do NOT poll)
- [ ] analysis-completeness result noted
- [ ] Document schema validation result noted

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
| Missing ROADMAP.md | Read phases from PLAN.md |

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
