---
description: Load session state from Master Plan (adaptive)
---

# Adaptive Session Load

Load previous session's state with Master Plan context and verification.

## Skills

Use `blueprint` skill for plan discovery and frontmatter operations:
- `blueprint frontis search` - Find plans by status
- `blueprint frontis show` - Read plan metadata

## Plan Selection

### With Argument

```
/load {identifier}
```

**Identifier formats:**

| Format | Example | Matches |
|--------|---------|---------|
| Number only | `001` | `blueprint/plans/001-*/` |
| Text only | `auth` | `blueprint/plans/*-*auth*/` |
| Full format | `001-auth` | `blueprint/plans/001-auth/` |

**Resolution:**
1. Parse identifier format
2. Glob matching:
   - Numeric: `blueprint/plans/{id}-*/master-plan.md`
   - Text: `blueprint/plans/*-*{id}*/master-plan.md`
   - Full: `blueprint/plans/{id}/master-plan.md`
3. If multiple matches → Present list, ask user to clarify
4. Load selected plan's `session-context/CURRENT.md`

### Without Argument

```
/load
```

**Interactive selection:**

1. Find active plans using `blueprint` skill:
   ```
   Use blueprint skill: frontis search status in-progress blueprint/plans/
   ```

2. Parse results and present:
   ```
   📋 Active Master Plans:

   1. PLAN-001: User Authentication
      Path: blueprint/plans/001-auth/
      Phase: 2 of 4 (Core Implementation)

   2. PLAN-003: Session Integration
      Path: blueprint/plans/003-session-integration/
      Phase: 1 of 3 (Foundation)

   Which plan to load? (Enter number or plan ID)
   ```

3. User selects → Load that plan's session-context/

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

### Phase 3: State Verification (Use Tools)

4. **Check git status:**
   ```bash
   git status
   git log -3 --oneline
   git diff --stat
   ```

5. **Compare docs vs reality:**
   - Verify branch matches expected
   - Check for uncommitted changes
   - Validate key files mentioned in CURRENT.md exist

6. **Verify Git Branch Convention:**
   - Expected: `<convention>/<nnn>-<brief-summary>`
   - IF mismatch → Warn user

### Phase 4: Handoff Briefing

7. **Present briefing:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📥 HANDOFF RECEIVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Master Plan:** PLAN-{NNN} - {Plan Name}
**Phase:** {N} of {Total} - {Phase Name}
**Plan Path:** blueprint/plans/{nnn}-{topic}/

**Previous Session:** {Date} (Session {N})

**Completed:**
- {Summary of previous work}
- {Key accomplishments}

**Current Goal:** {From CURRENT.md}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Status Check:**
✅ Git branch matches: {branch}
✅ Key files verified ({N} files)
✅ No uncommitted changes
[⚠️ {Warning if any - non-blocking}]

**Next Step:**
{First action from CURRENT.md "Next Agent Should"}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Should I proceed? (yes/no/explain {topic})
```

### Phase 5: User Confirmation

8. **Wait for input:**
   - `yes` → Proceed with work
   - `no` / `wait` → Pause for user review
   - `explain {topic}` → Provide detail on topic
   - `show {file}` → Display file content

---

## Error Recovery

### Plan Not Found

```
⚠️ No plan matching '{identifier}' found.

Available plans:
- 001-auth (in-progress)
- 003-session (in-progress)
- 002-dashboard (completed)

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
2. Continue on current branch (update docs later)
3. Create new branch matching plan

Which option? (1/2/3)
```

### Git Status Mismatch

```
⚠️ Uncommitted changes detected.

Document says: "All changes committed"
Git shows: 3 modified files

Options:
1. Review changes first (git diff)
2. Commit changes now
3. Continue anyway (will update docs on /save)

Which option? (1/2/3)
```

### Stale Session Context

```
⚠️ Session context may be stale.

CURRENT.md last updated: {date} ({N} days ago)
Recent commits since then: {N}

Options:
1. Continue with existing context
2. Review git history first
3. Rebuild context from recent commits

Which option? (1/2/3)
```

---

## Git Branch Convention

Expected branch pattern: `<convention>/<nnn>-<brief-summary>`

Examples:
- `feature/001-auth`
- `plan/003-session-integration`
- `fix/002-dashboard-bug`

Used for:
- Verification during /load
- Plan inference during /save

---

## Tips

### DO:
- ✅ Read everything before using tools
- ✅ Verify git status matches docs
- ✅ Present options when inconsistencies found
- ✅ Be concise in briefing (user wants to start work)
- ✅ Highlight blockers prominently

### DON'T:
- ❌ Auto-fix inconsistencies without asking
- ❌ Skip verification steps
- ❌ Assume docs are correct if git says otherwise
- ❌ Present multi-page briefings (keep it tight)
- ❌ Start work before user confirmation

---

## Reviewer Worker Delegation (Context Saving)

For complex projects, delegate State Verification to Reviewer Worker to preserve Main Session context.

### When to Delegate

| Condition | Action |
|-----------|--------|
| HISTORY.md > 200 lines | Consider delegation |
| Multiple phases completed | Consider delegation |
| Complex verification needed | Delegate |
| Quick task (< 3 sessions) | Direct verification |

### Delegation Flow

```
Phase 3: State Verification
    ↓
[Spawn Reviewer Worker]
    └── Task: aegis session --aspects git-state,file-integrity,plan-progress
    ↓
[Reviewer Returns Handoff]
    ├── status: completed
    ├── summary: Validation results
    └── issues: List of problems found
    ↓
[Process Results in Main Session]
    └── Present to user in Handoff Briefing
```

### Reviewer Invocation

```
Use Task tool with subagent_type: reviewer

Prompt:
"Validate session continuity for PLAN-{NNN}.

Context files:
- {PLAN_PATH}/session-context/CURRENT.md
- {PLAN_PATH}/ROADMAP.md

Run: aegis session --aspects git-state,file-integrity,plan-progress

Return Handoff with validation results."
```

### Processing Reviewer Results

**If all pass:**
```
Status Check:
✅ Git state verified (Reviewer)
✅ File integrity verified (Reviewer)
✅ Plan progress consistent (Reviewer)
```

**If issues found:**
```
Status Check:
⚠️ Issues detected by Reviewer:

[git-state] Branch mismatch
  - Expected: feature/001-auth
  - Actual: main
  - Suggestion: Switch to expected branch

[file-integrity] File not found
  - Path: src/auth/login.ts
  - Suggestion: Check if file was moved

Options:
1. Address issues before proceeding
2. Continue anyway (acknowledge issues)
```

---

## Adaptive Behavior by Mode

Adjust briefing style based on project scale.

### Mode Detection

```
IF no HISTORY.md OR HISTORY.md < 10 lines:
    mode = Quick
ELSE IF HISTORY.md 10-500 lines:
    mode = Standard
ELSE IF HISTORY.md > 500 lines OR archive/ exists:
    mode = Compressed
```

### Quick Mode Briefing

For simple tasks (1-2 sessions expected):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  HANDOFF RECEIVED (Quick)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Previous: {One sentence summary}
Goal: {One sentence goal}
Status: {clean/issues}

Next Steps:
1. {Action 1}
2. {Action 2}
3. {Action 3}

Ready? (yes/no)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Standard Mode Briefing

For multi-session tasks (3-10 sessions):

Use the full briefing template from Phase 4 above, including:
- Phase overview
- Decision rationale
- Blockers
- Detailed next steps

### Compressed Mode Briefing

For epic projects (10+ sessions):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  HANDOFF RECEIVED (Epic Project)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Master Plan:** PLAN-{NNN} - {Plan Name}
**Phase:** {N} of {Total} - {Phase Name}
**Sessions:** {Total sessions so far}

**Long-term Goal:** {From master-plan.md}

**Previous Phase Summary:**
- Phase {N-1}: {Completed, archived}
- Archive: `session-context/archive/{DATE}/`

**Current Phase Progress:**
- Started: {date}
- Sessions: {N}
- Status: {percentage or milestone}

**Previous Session:** {Date}
- {Key accomplishment}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Status Check:** {pass/issues}

**Next Step:** {First action}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Should I proceed? (yes/no/explain {topic})
```

---

## Verification Checklist

Before presenting briefing, verify:

- [ ] CURRENT.md exists and is readable
- [ ] Git status checked
- [ ] Docs vs git comparison done
- [ ] Key files verified (2-3 files minimum)
- [ ] No critical errors or blockers
- [ ] Next steps are clear and actionable
- [ ] Briefing message is concise (< 30 lines for Quick, < 50 for others)

---

## Integration with /save

This load protocol expects files created by `/save`:

| File | Required | Purpose |
|------|----------|---------|
| CURRENT.md | Yes | Core session state |
| TODO.md | No | Task tracking (Standard/Compressed) |
| HISTORY.md | No | Session log (Standard/Compressed) |
| ROADMAP.md | Yes | Phase progress |

### Graceful Adaptation

If structure doesn't match expected:

| Situation | Adaptation |
|-----------|------------|
| Missing TODO.md | Check CURRENT.md "Next Steps" for tasks |
| No HISTORY.md | Assume Quick task mode |
| Missing ROADMAP.md | Read phases from master-plan.md |
| Unconventional format | Parse what's available, clarify with user |

---

## Additional Error Scenarios

### CURRENT.md Line Limit Exceeded

```
⚠️ CURRENT.md is {X} lines (recommended: {Y} lines)

Large context files may slow down loading and consume context window.

Recommended limits:
- Quick mode: 100 lines
- Standard mode: 200 lines
- Compressed mode: 150 lines

Options:
1. Continue anyway (will read full file)
2. Compress to HISTORY.md first
3. Ask user to summarize key points

Which option? (1/2/3)
```

### Archive Reference Needed

```
Note: Previous phases archived.

For context on Phase {N-1} decisions:
- See: session-context/archive/{DATE}/CHECKPOINT-SUMMARY.md

Should I read the archive for additional context? (yes/no)
```
