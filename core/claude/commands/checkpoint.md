---
description: Save major milestone checkpoint for Master Plan phase completion
---

# Checkpoint: Milestone Save

Comprehensive checkpoint for completing a Master Plan phase.

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
| Reviewer delegation | `hermes request:review:session-state` |

---

## Plan Path Resolution

**First**, resolve the current project's plans directory:

```bash
PLANS_DIR=$(~/.claude/skills/blueprint/blueprint.sh project current --plans)
```

**Then**, after plan recognition, set:
- `{PLAN_PATH}` = `{PLANS_DIR}/{nnn}-{topic}/`
- `{SESSION_PATH}` = `{PLAN_PATH}/session-context/`

Use these variables for all path references below.

---

## Plan Recognition

Same as `/save`:
1. From existing CURRENT.md (Primary)
2. From Git Branch (Secondary)
3. From argument: `/checkpoint 001` (Override)

---

## Checkpoint Process

### Step 1: Verify Phase Completion (Reviewer Delegation)

Delegate to Reviewer SubAgent to validate phase is ready for checkpoint.

**Handoff:**
```
Use Task tool with subagent_type: reviewer

Construct prompt using: `blueprint hermes request:review:phase-completion`
- Replace {PLAN_PATH} with resolved plan path (e.g., {PLANS_DIR}/001-auth)
```

**Process response:** `blueprint hermes response:review:phase-completion`
- `pass` → Proceed to Step 2
- `warning` → Present warnings, ask user: "Phase {N} has warnings. Checkpoint anyway? (yes/no)"
- `fail` → Present issues, go to Error Handling: Phase Not Complete

### Step 2: Archive Current Session Context

Create dated archive directory:
```
{PLAN_PATH}/session-context/archive/{YYYY-MM-DD}/
```

Copy current state:
- CURRENT.md
- TODO.md
- HISTORY.md

### Step 3: Create CHECKPOINT-SUMMARY.md

```
blueprint forma copy checkpoint-summary {PLAN_PATH}/session-context/archive/{YYYY-MM-DD}/
```

Then fill in:
- Phase completed
- Key achievements
- Sessions in this phase
- Critical decisions
- Metrics
- Lessons learned
- Next phase preview

### Step 4: Compress HISTORY.md

Move detailed session entries to archive:
- Keep only summary entries in HISTORY.md
- Goal: Under 300 lines
- Add reference: `See archive/{DATE}/CHECKPOINT-SUMMARY.md`

### Step 5: Reset CURRENT.md for Next Phase

Reset CURRENT.md with:
- New phase information
- Reference to archived phase
- Fresh session state

Update frontmatter:
- `current-phase`: Increment to next
- `session-id`: Reset or continue sequence

### Step 6: Update ROADMAP.md

Mark completed phase:
```markdown
- [x] Phase {N}: {Name} ✅ (Completed: {date})
- [ ] Phase {N+1}: {Name} ← Current
```

### Step 7: Update TODO.md

Shift to next phase:
- Mark previous phase tasks as archived
- Add next phase milestones
- Reset "In Progress" section

### Step 8: Review Implementation Notes

Check `{PLAN_PATH}/implementation-notes.md` for Phase completion:

- Any unresolved issues from this phase?
- Deviations properly documented?
- Learnings captured for future reference?
- Timeline updated with phase completion date?

If missing, ask user to provide details before finalizing checkpoint.

### Step 9: Check Master Plan Status

```
IF all phases completed in ROADMAP.md:
    Update master-plan.md frontmatter:
    - status: in-progress → completed
```

### Step 10: Confirm

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
🎉 Master Plan PLAN-{NNN} completed!

Duration: {start} to {end}
Total Phases: {N}
Total Sessions: {M}

Consider:
- Creating ADR for key decisions
- Updating project documentation
- Archiving the plan directory
```
