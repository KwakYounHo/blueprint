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

## Skills

Use `blueprint` skill for template operations:
- `blueprint forma copy` - Copy templates

---

## Plan Recognition

Same as `/save`:
1. From existing CURRENT.md (Primary)
2. From Git Branch (Secondary)
3. From argument: `/checkpoint 001` (Override)

---

## Checkpoint Process

### Step 1: Verify Phase Completion

```
Before checkpoint, confirm:
- [ ] All phase deliverables complete?
- [ ] Tests passing?
- [ ] Documentation updated?

If not complete:
  "Phase {N} appears incomplete. Checkpoint anyway? (yes/no)"
```

### Step 2: Archive Current Session Context

Create dated archive directory:
```
{PLAN_PATH}/session-context/archive/{YYYY-MM-DD}/
```

Copy current state:
```bash
# Files to archive
- CURRENT.md
- TODO.md
- HISTORY.md
```

### Step 3: Create CHECKPOINT-SUMMARY.md

Use `blueprint` skill:
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
- `session-id`: Reset to 1 for new phase (or continue sequence)

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

### Step 8: Check Master Plan Status

```
IF all phases completed in ROADMAP.md:
    Update master-plan.md frontmatter:
    - status: in-progress → completed

    Present completion message:
    "🎉 Master Plan PLAN-{NNN} completed!"
```

---

## Confirmation Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🏁 CHECKPOINT COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Phase Archived:** Phase {N} - {Name}
**Duration:** {start} to {end}
**Sessions:** {X} sessions archived

**Created:**
✅ archive/{DATE}/CHECKPOINT-SUMMARY.md
✅ archive/{DATE}/CURRENT.md (snapshot)
✅ archive/{DATE}/TODO.md (snapshot)
✅ archive/{DATE}/HISTORY.md (snapshot)

**Updated:**
✅ CURRENT.md (reset for Phase {N+1})
✅ TODO.md (next phase milestones)
✅ HISTORY.md (compressed to {X} lines)
✅ ROADMAP.md (Phase {N} marked complete)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ready to start Phase {N+1}: {Phase Name}

Next step: {First task of new phase}

Use `/load {nnn}` to begin next session.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Plan Completion

When all phases are done:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎉 MASTER PLAN COMPLETED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Plan:** PLAN-{NNN} - {Plan Name}
**Duration:** {start} to {end}
**Total Phases:** {N}
**Total Sessions:** {M}

**All Phases:**
✅ Phase 1: {Name}
✅ Phase 2: {Name}
✅ Phase 3: {Name}

**Master Plan Status:** completed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Consider:
- Creating ADR for key decisions
- Updating project documentation
- Archiving the plan directory

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

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
- ✅ Celebrate completed phase!

### DON'T:
- ❌ Use for daily saves (use `/save`)
- ❌ Archive incomplete work
- ❌ Delete HISTORY.md (compress, don't remove)
- ❌ Rush the checkpoint (it's a milestone!)

---

## Frequency Guidelines

| Project Duration | Checkpoint Frequency |
|------------------|---------------------|
| < 1 month | 0-1 checkpoints |
| 1-3 months | 2-4 checkpoints |
| 3+ months | Weekly or bi-weekly |

**Rule of thumb:** Checkpoint every 10-15 sessions or at major milestones.
