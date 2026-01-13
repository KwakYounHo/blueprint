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

---

## Manual Decision Guidelines

Use your judgment for checkpoints beyond automatic suggestions:

| Situation | Recommendation |
|-----------|----------------|
| End of sprint/milestone | Checkpoint |
| Major feature complete | Checkpoint |
| Before starting new phase | Checkpoint |
| Before vacation/break | Checkpoint |
| Team handoff | Checkpoint |
| Significant architecture change | Checkpoint |
| After resolving major blocker | Consider checkpoint |

**Ask yourself:**
- "If I come back in 2 weeks, will I understand where we left off?"
- "Could a new team member pick this up from the checkpoint?"

---

## Recovery from Checkpoint

How to reference archived phases:

### Finding Past Decisions

```
User: What did we decide about X in Phase 2?

Agent approach:
1. Check archive directory: session-context/archive/
2. Find relevant checkpoint: archive/{DATE}/CHECKPOINT-SUMMARY.md
3. Read "Critical Decisions" section
4. Provide answer with archive reference
```

**Example Response:**
```
In Phase 2 (archived 2024-01-15), we decided:

**D-003: Authentication Method**
- Choice: JWT over session tokens
- Rationale: Stateless API requirement

Reference: session-context/archive/2024-01-15/CHECKPOINT-SUMMARY.md
```

### Restoring Context

```
User: I need full context on Phase 2 for debugging

Agent approach:
1. Read archive/{DATE}/CHECKPOINT-SUMMARY.md
2. Read archive/{DATE}/CURRENT.md (snapshot)
3. Optionally read archive/{DATE}/HISTORY.md
4. Summarize key points for user
```

### Archive Directory Structure

```
session-context/archive/
├── 2024-01-15/                    # Phase 1 completion
│   ├── CHECKPOINT-SUMMARY.md      # Phase summary
│   ├── CURRENT.md                 # Snapshot at checkpoint
│   ├── TODO.md                    # Task state snapshot
│   └── HISTORY.md                 # Session history snapshot
├── 2024-02-01/                    # Phase 2 completion
│   └── ...
└── 2024-02-15/                    # Phase 3 completion
    └── ...
```

---

## WEEKLY-REVIEW.md (Optional)

For projects spanning multiple weeks, generate weekly review summaries.

### When to Generate

- User requests: "Create weekly review"
- Project has been active for 7+ days since last review
- At checkpoint if > 5 sessions in the week

### Template

Use `blueprint forma copy weekly-review {PLAN_PATH}/session-context/`

```markdown
# Weekly Review - Week of {Date}

## This Week's Focus

{Main areas of work}

## Completed

- {Accomplishment 1}
- {Accomplishment 2}
- {Accomplishment 3}

## Challenges

- {Challenge}: {How we addressed it}

## Decisions Made

- **{Decision}**: {Rationale}

## Next Week's Goals

- {Goal 1}
- {Goal 2}
- {Goal 3}

## Metrics

- Sessions this week: {N}
- Commits: {N}
- Files modified: {N}
- Tests added: {N}

## Notes

{Anything worth remembering for future reference}
```

### Generating Weekly Review

```
Step 1: Read HISTORY.md entries for the past week
Step 2: Aggregate metrics (session count, commits)
Step 3: Extract key decisions from session entries
Step 4: Identify challenges from blockers mentioned
Step 5: Write WEEKLY-REVIEW-{DATE}.md
```

---

## CHECKPOINT-SUMMARY Detailed Template

Enhanced template with additional sections:

```markdown
# Checkpoint Summary - {Date}

## Phase Completed

**Phase {N}:** {Phase Name}
**Duration:** {start date} to {end date}
**Sessions:** {X} sessions

## Key Achievements

- {Major accomplishment 1}
- {Major accomplishment 2}
- {Major accomplishment 3}

## Sessions in This Phase

| Session | Date | Goal | Outcome |
|---------|------|------|---------|
| {X} | {date} | {goal} | {outcome} |
| {X+1} | {date} | {goal} | {outcome} |

Total: {N} sessions
Duration: {X} days

## Critical Decisions

| ID | Decision | Rationale | Outcome |
|----|----------|-----------|---------|
| D-{NNN} | {decision} | {why} | {result} |

## Metrics

### Code Changes
- Lines added: {N}
- Lines removed: {N}
- Files created: {N}
- Files modified: {N}

### Quality
- Tests added: {N}
- Test coverage: {X}% → {Y}%
- Bugs fixed: {N}
- Technical debt addressed: {items}

### Performance (if applicable)
- Build time: {before} → {after}
- Bundle size: {before} → {after}

## Lessons Learned

### What Went Well
- {Insight 1}
- {Insight 2}

### What Could Be Improved
- {Area 1}: {suggestion}
- {Area 2}: {suggestion}

### Patterns Discovered
- {Pattern}: {where to apply}

## Technical Notes

{Any technical details worth preserving for future reference}

## Next Phase Preview

**Phase {N+1}:** {Phase Name}

**Objectives:**
- {Objective 1}
- {Objective 2}

**Key Files:**
- {file}: {purpose}

**Estimated Sessions:** {N}
```

---

## Reviewer Integration

For `/checkpoint`, use Reviewer to validate phase completion:

### Pre-Checkpoint Validation

```
Before archiving, spawn Reviewer:

Task: aegis session --aspects plan-progress

Verify:
- [ ] All phase deliverables complete
- [ ] TODO.md shows phase tasks done
- [ ] No blockers preventing phase closure
```

### Validation Results

**If pass:**
```
Phase {N} validation: PASSED

All deliverables complete.
Ready to checkpoint.
```

**If fail:**
```
Phase {N} validation: INCOMPLETE

Issues:
- TODO.md: 2 tasks still pending
- Blocker: Authentication bug unresolved

Options:
1. Complete remaining tasks first
2. Move tasks to next phase and checkpoint anyway
3. Cancel checkpoint

Which option? (1/2/3)
```
