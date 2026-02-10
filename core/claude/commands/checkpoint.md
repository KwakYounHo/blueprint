---
description: Save major milestone checkpoint for Plan phase completion
---

# Checkpoint: Milestone Save

Comprehensive checkpoint for completing a Plan phase.

## When to Use

- ✅ Completing a major phase
- ✅ Starting a new phase
- ✅ Before significant architectural changes
- ✅ Team handoff or knowledge transfer
- ✅ Weekly/monthly review for long projects

**Don't use for:** Regular session saves (use `/save` instead)

## Blueprint Skill Reference

Load `/blueprint` skill for template and handoff operations. Execute commands in Bash using full path:

| Operation | Submodule + Subcommand |
|-----------|----------------------|
| Copy templates | `forma copy` |
| View confirmation format | `hermes after-checkpoint` |
| Reviewer delegation | `hermes request:review:phase-completion` |

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

> **Note**: Each plan is a **directory** containing PLAN.md, ROADMAP.md, session-context/, etc.

After plan recognition, set:
- `{PLAN_PATH}` = output from `~/.claude/skills/blueprint/blueprint.sh plan resolve <identifier>`
- `{SESSION_PATH}` = `{PLAN_PATH}/session-context/`

Use these paths for all references below.

---

## Plan Recognition

Same as `/save`:
1. From existing CURRENT.md (Primary)
2. From Git Branch (Secondary)
3. From argument: `/checkpoint 001` (Override)

---

## Checkpoint Process

### Step 1: Session Sync

> `/checkpoint` is self-contained — it does NOT require `/save` to be run first.
> This step ensures documents reflect the current session's work before validation.

Perform the following updates (same as `/save` Steps 2-4):

**Step 1.1: Gather Information**

- `git status`, `git log -3 --oneline`
- Current Phase and completed Tasks from session context
- Key decisions made this session

**Steps 1.2-1.5: Update Documents (Parallel)**

> Steps 1.2 through 1.5 each write to different files and are mutually independent.
> Execute them in parallel (single message with multiple tool calls) after
> gathering information from Step 1.1.

**Step 1.2**: Update CURRENT.md
- Update `session-id` (increment), `current-phase`, `current-task`
- Fill in session-specific sections (Completed, Decisions, State)

**Step 1.3**: Update ROADMAP.md Task checkboxes
- Check `[x]` for all completed Tasks in current Phase
- Verify against git commits and session work

**Step 1.4**: Append to HISTORY.md (if Standard/Compressed mode)
- Add session entry using `history-entry` template format

**Step 1.5**: Update TODO.md (if exists and not template)
- Mark completed tasks, update current-task

> **Idempotent**: If `/save` was already run this session, these updates
> produce the same result. Safe to run regardless.

### Step 2: Verify Phase Completion (Reviewer Delegation)

Delegate to Reviewer SubAgent to validate phase is ready for checkpoint.

**Handoff:**
```
Use Task tool with subagent_type: reviewer

Construct prompt using: `blueprint hermes request:review:phase-completion`
- Replace {PLAN_PATH} with resolved plan path (e.g., {PLANS_DIR}/001-auth)
```

> **IMPORTANT**: Do NOT use `run_in_background`. All subsequent steps depend on the
> Reviewer result. Call the Task tool synchronously and wait for the response before
> proceeding. Do NOT use TaskOutput to poll for results.

**Verification includes:**
- ALL Tasks in Phase are complete (checked in ROADMAP.md)
- Task status in TODO.md matches ROADMAP.md
- No incomplete Task items for this Phase

**Process response:** `blueprint hermes response:review:phase-completion`
- `pass` → Proceed to Step 3
- `warning` → Present warnings, ask user: "Phase {N} has warnings. Checkpoint anyway? (yes/no)"
- `fail` → Present issues (including incomplete Tasks), go to Error Handling: Phase Not Complete

### Step 3: Archive Current Session Context

Create dated archive directory:
```
{PLAN_PATH}/session-context/archive/{YYYY-MM-DD}/
```

Copy current state:
- CURRENT.md
- TODO.md
- HISTORY.md

### Steps 4-8: Update Documents (Parallel)

> Steps 4 through 8 each write to different files and are mutually independent.
> Execute them in parallel (single message with multiple tool calls) after
> determining content for each from the source documents.

#### Step 4: Create CHECKPOINT-SUMMARY.md

```
blueprint forma copy checkpoint-summary {PLAN_PATH}/session-context/archive/{YYYY-MM-DD}/
```

Then fill in:
- Phase completed
- Tasks completed: {N}/{total} (count from ROADMAP.md)
- Key achievements
- Sessions in this phase
- Critical decisions
- Metrics
- Lessons learned
- Next phase preview

#### Step 5: Compress HISTORY.md

Move detailed session entries to archive:
- Keep only summary entries in HISTORY.md
- Goal: Under 300 lines
- Add reference: `See archive/{DATE}/CHECKPOINT-SUMMARY.md`

#### Step 6: Reset CURRENT.md for Next Phase

Reset CURRENT.md with:
- New phase information
- Reference to archived phase
- Fresh session state

Update frontmatter:
- `current-phase`: Increment to next
- `session-id`: Reset or continue sequence

#### Step 7: Update ROADMAP.md

Mark completed phase:
```markdown
- [x] Phase {N}: {Name} ✅ (Completed: {date})
- [ ] Phase {N+1}: {Name} ← Current
```

#### Step 8: Update TODO.md

Shift to next phase:
- Mark previous phase tasks as archived
- Add next phase milestones
- Reset "In Progress" section

### Step 9: Implementation Notes Review (Comprehensive)

**Step 9.1**: Session Content Analysis

Review conversation for potential implementation-notes content (same as /save):
- **Deviations**: Approach changes from PLAN.md
- **Issues**: Blockers, bugs, unexpected problems
- **Learnings**: Insights, discoveries

**Step 9.2**: Implementation Notes Lifecycle

1. Read `{PLAN_PATH}/implementation-notes.md`
2. Identify all ISSUE entries for the completing Phase:
   - `[ACTIVE]` entries: Present to user for resolution decision
   - `[RESOLVED]` entries: Mark for archival
3. Archive `[RESOLVED]` entries:
   - Move to `{SESSION_PATH}/archive/{YYYY-MM-DD}/implementation-notes-resolved.md`
   - Remove from main `implementation-notes.md`
   - Keep `[ACTIVE]` entries in place (carried forward to next Phase)
4. Update counts: "Archived {N} resolved issues. {M} active issues carried forward."

**Step 9.3**: Present Comprehensive Summary

Use `AskUserQuestion`:

| Field | Content |
|-------|---------|
| Header | "Impl Notes" |
| Question | "📝 Phase {N} Implementation Notes Review\n\nCurrent status:\n- Deviations: {X} entries\n- Issues: {Y} ({Z} unresolved)\n- Learnings: {W} entries\n\nThis session detected:\n{LLM analysis}\n\nRecord and finalize?" |
| Option A | "Record + finalize" |
| Option B | "Add/edit notes first" |
| Option C | "Skip, proceed to checkpoint" |

**Step 9.4**: Unresolved Issues Warning

If unresolved issues exist:
```
⚠️ {N} unresolved issues in implementation-notes.md

ISSUE-{NNN}: {title} (open)

Options:
1. Mark as resolved with notes
2. Carry forward to next phase
3. Continue anyway
```

### Step 10: Check Plan Status

```
IF all phases completed in ROADMAP.md:
    Update PLAN.md frontmatter:
    - status: in-progress → completed
```

### Step 11: ADR Detection

Scan the current session for ADR-worthy signals:

**Signals to detect:**
- Architectural decisions made (technology choices, pattern selections, structural changes)
- Trade-off discussions that resulted in a decision
- Deviations from Plan representing deliberate design choices (check Deviations table)
- New conventions or standards established

**Additional signals for checkpoint:**
- Phase-level architectural patterns established
- Cross-Phase design decisions visible in retrospect
- Significant deviations that changed the approach (from Deviations table)

**If signals detected:**

Use `AskUserQuestion`:

| Field | Content |
|-------|---------|
| Header | "ADR" |
| Question | "This session contains potential ADR-worthy decisions:\n\n{list of detected signals}\n\nWould you like to create an ADR?" |
| Option A | "Create ADR now" |
| Option B | "Note for later" |
| Option C | "Skip" |

- Option A → Use `blueprint forma copy adr` and fill from session context
- Option B → Add to CURRENT.md "Next Agent Should" section: "Consider ADR for: {topic}"
- Option C → Continue to confirmation

**If no signals detected:** Skip silently, proceed to confirmation.

### Step 12: Confirm

Use confirmation format: `blueprint hermes after-checkpoint`

---

## Error Handling

### No Active Session

```
⚠️ No active session found for PLAN-{NNN}.

Cannot checkpoint without active session context.

Options:
1. Run /save first to create session context
2. Select different plan

Which option? (1/2)
```

### Phase Not Complete

```
⚠️ Phase {N} may not be complete.

Incomplete items in TODO.md:
- [ ] {task 1}
- [ ] {task 2}

Options:
1. Checkpoint anyway (mark tasks as moved to next phase)
2. Complete tasks first, then checkpoint

Which option? (1/2)
```

---

## Tips

### DO:
- ✅ Use for major milestones only
- ✅ Write comprehensive CHECKPOINT-SUMMARY.md
- ✅ Link archived content clearly
- ✅ Reset CURRENT.md for fresh start

### DON'T:
- ❌ Use for daily saves (use `/save`)
- ❌ Archive incomplete work
- ❌ Delete HISTORY.md (compress, don't remove)

---

## Frequency Guidelines

| Project Duration | Checkpoint Frequency |
|------------------|---------------------|
| < 1 month | 0-1 checkpoints |
| 1-3 months | 2-4 checkpoints |
| 3+ months | Weekly or bi-weekly |

**Rule of thumb:** Checkpoint every 10-15 sessions or at major milestones.

---

## Recovery from Checkpoint

### Finding Past Decisions

```
User: What did we decide about X in Phase 2?

Agent approach:
1. Check archive: session-context/archive/
2. Read: archive/{DATE}/CHECKPOINT-SUMMARY.md
3. Find "Critical Decisions" section
```

### Archive Directory Structure

```
session-context/archive/
├── {YYYY-MM-DD}/                # Phase completion date
│   ├── CHECKPOINT-SUMMARY.md
│   ├── CURRENT.md (snapshot)
│   ├── TODO.md (snapshot)
│   └── HISTORY.md (snapshot)
```

---

## WEEKLY-REVIEW.md (Optional)

For projects spanning multiple weeks.

### When to Generate

- User requests: "Create weekly review"
- Project active 7+ days since last review
- At checkpoint if > 5 sessions in the week

### Generation

```
blueprint forma copy weekly-review {PLAN_PATH}/session-context/
```

Rename to: `WEEKLY-REVIEW-{YYYY-MM-DD}.md`

---

## Plan Completion

When all phases are done:

```
🎉 Plan PLAN-{NNN} completed!

Duration: {start} to {end}
Total Phases: {N}
Total Sessions: {M}

Consider:
- Creating ADR for key decisions
- Updating project documentation
- Archiving the plan directory
```
