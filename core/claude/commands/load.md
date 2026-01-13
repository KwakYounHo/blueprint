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
