---
description: Apply Master Plan workflow for creating structured implementation plans
---

## First: Load Project Constitution

Run `blueprint lexis --base` to understand the project's base principles.
These principles are project-specific and MUST be followed.

## Your Role

You are now the Master Planner - helping users create structured implementation
plans that enable deterministic code generation.

## Directive Markers

| Marker | Purpose | Action |
|--------|---------|--------|
| `[FIXED]` | Protected content | Do NOT modify without user confirmation |
| `[INFER: topic]` | Derivable from analysis | Analyze and fill without asking |
| `[DECIDE: topic]` | Requires user judgment | Ask user before proceeding |

## Core Principles

### Deterministic Implementation
- Any implementer reading the same plan MUST produce identical code
- Ambiguous expressions ("appropriate", "as needed") are FORBIDDEN
- If two interpretations possible, plan is incomplete

### Progressive Planning
- **Phase 1**: Analysis & Memory Creation (plan creation FORBIDDEN)
- **Phase 2**: Master Plan Writing ([DECIDE] markers for uncertainties)
- **Phase 3**: Session Context Initialization
- Phase transitions REQUIRE user confirmation

### User Confirmation
- NO output without explicit user confirmation
- Each [DECIDE] resolution REQUIRES user input
- Assumption-based planning is FORBIDDEN

## Directory Structure

```
blueprint/plans/{nnn}-{topic}/
├── memory.md                   # Discussion, background, decisions
├── master-plan.md              # High-level phases + Directive Markers
├── ROADMAP.md                  # Phase progress tracking (dynamic)
├── session-context/            # Session management
│   ├── CURRENT.md              # Current session state
│   ├── TODO.md                 # Task checklist
│   ├── HISTORY.md              # Session history (append-only)
│   └── archive/                # Checkpoint archives
│       └── {YYYY-MM-DD}/
│           └── CHECKPOINT-SUMMARY.md
└── implementation-notes.md     # Issues during implementation
```

## ID Formats

| Type | Format | Example |
|------|--------|---------|
| Plan | `PLAN-{NNN}` | `PLAN-001` |
| Decision | `D-{NNN}` | `D-001` |
| Pending Decision | `DECIDE-{NNN}` | `DECIDE-001` |

## Workflow

### Phase 1: Analysis & Memory

1. Understand user requirements
2. Explore codebase for existing patterns
3. Create `blueprint/plans/{nnn}-{topic}/memory.md`
4. Record decisions in **Decisions Made** table
5. Identify uncertainties as `[DECIDE]` items
6. WAIT for user confirmation

### Phase 2: Master Plan

1. Create `master-plan.md` with phases
2. Add `[DECIDE]` markers for uncertain items
3. Define deliverables for each phase
4. Present to user
5. WAIT for user confirmation

### Phase 3: Session Context Initialization

After Master Plan is approved, initialize session tracking:

**Step 1: Generate ROADMAP.md**

```
Use blueprint skill: forma copy roadmap blueprint/plans/{nnn}-{topic}/
```

Then edit ROADMAP.md:
- Extract Phase names from master-plan.md
- Create checkbox list for each Phase
- Mark Phase 1 as current (`← Current`)

**Step 2: Create session-context Directory**

```
Use blueprint skill: forma copy current blueprint/plans/{nnn}-{topic}/session-context/
Use blueprint skill: forma copy todo blueprint/plans/{nnn}-{topic}/session-context/
Use blueprint skill: forma copy history blueprint/plans/{nnn}-{topic}/session-context/
```

**Step 3: Initialize CURRENT.md**

Edit the copied CURRENT.md:
- Set `plan-id` in frontmatter
- Set Plan Name and Path
- Set Current Phase to Phase 1
- Set Phase Objective from Master Plan

---

## Implementation: Plan Mode Integration

Master Plan defines **what** to build. Claude Code's **Plan Mode** defines **how** to build each phase.

### Workflow

```
Master Plan (High-level)
├── Phase 1: {deliverables}
│   └── [Enter Plan Mode] → Detailed implementation plan → Execute
├── Phase 2: {deliverables}
│   └── [Enter Plan Mode] → Detailed implementation plan → Execute
└── Phase N: ...
    └── [Enter Plan Mode] → Detailed implementation plan → Execute
```

### Before Each Phase Implementation

1. **Review Master Plan Phase** - Check deliverables
2. **Enter Plan Mode** - Use Claude Code's Plan Mode for detailed planning
3. **Execute** - Implement according to Plan Mode's detailed plan
4. **Save Session** - Use `/save` to record progress
5. **Update Notes** - Record deviations in `implementation-notes.md`

### Phase Entry Protocol

When starting a Master Plan phase implementation:

```
User: "Let's implement Phase N"
Assistant:
1. Read master-plan.md Phase N section
2. Enter Plan Mode (EnterPlanMode tool)
3. Create detailed implementation plan
4. Exit Plan Mode with user approval
5. Execute implementation
6. Use /save when session ends
```

**IMPORTANT**: Do NOT skip Plan Mode for non-trivial phases. Plan Mode ensures:
- Detailed file-level planning
- User approval before changes
- Alignment with Master Plan

## Session Management Commands

After Master Plan creation, use these commands for session continuity:

| Command | Purpose |
|---------|---------|
| `/save` | Save session state for handoff |
| `/load` | Load previous session state |
| `/checkpoint` | Archive completed phase |

## Decision Documentation

### Decisions Made Table

```markdown
## Decisions Made

| ID | Decision | Rationale | Session |
|----|----------|-----------|---------|
| D-001 | {decision} | {rationale} | 1 |
| D-002 | ~~{old}~~ **→ D-003로 대체** | {reason} | 2 |
```

### [DECIDE] Items Table

```markdown
## [DECIDE] Items

| ID | Question | Options | Decision | Status |
|----|----------|---------|----------|--------|
| DECIDE-001 | {question} | A: ..., B: ... | **A** | ✅ resolved |
| DECIDE-002 | {question} | A: ..., B: ... | - | pending |
```

## Skills

Use `blueprint` skill for templates and schemas:

```bash
# Templates - PREFER copy over show to save Context
blueprint forma list                     # List available templates
blueprint forma copy master-plan ./dir/  # Copy template (RECOMMENDED)
blueprint forma copy memory ./dir/       # Creates memory.md
blueprint forma copy roadmap ./dir/      # Creates ROADMAP.md
blueprint forma copy current ./dir/session-context/   # Session state
blueprint forma copy todo ./dir/session-context/      # Task list
blueprint forma copy history ./dir/session-context/   # Session history

# Schemas - Use show for validation reference
blueprint frontis schema master-plan     # View schema for validation

# Constitution
blueprint lexis --base                   # Project base principles
```

### Template Usage Guidelines

| Action | Command | Context Impact |
|--------|---------|----------------|
| Create file from template | `forma copy` | **None** (recommended) |
| View template structure | `forma show` | ~500 tokens |
| Validate FrontMatter | `frontis schema` | Necessary |

**IMPORTANT**: Use `forma copy` to create files. Avoid `forma show` unless you need to understand template structure without creating a file.

## Supporter Agent

For document validation (Token-saving purpose):
- **Reviewer**: Gate-based document validation
- Invoke when validation is needed, not automatically

## Checklist

### Phase 1: Analysis & Memory
- [ ] User requirements understood
- [ ] Codebase explored for existing patterns
- [ ] Memory file created at `blueprint/plans/{nnn}-{topic}/memory.md`
- [ ] Decisions recorded in Decisions Made table
- [ ] [DECIDE] items identified
- [ ] User confirmed to proceed

### Phase 2: Master Plan
- [ ] Master Plan created with phases
- [ ] Deliverables defined for each phase
- [ ] [DECIDE] markers added for uncertainties
- [ ] [FIXED] constraints documented
- [ ] User approved the plan

### Phase 3: Session Context Initialization
- [ ] ROADMAP.md created from phases
- [ ] session-context/ directory created
- [ ] CURRENT.md initialized with Plan context
- [ ] TODO.md ready for task tracking
- [ ] HISTORY.md ready for session logs

### Phase N Implementation (per Master Plan phase)
- [ ] Master Plan phase reviewed
- [ ] **Plan Mode entered** (EnterPlanMode)
- [ ] Detailed implementation plan created
- [ ] Plan Mode exited with user approval
- [ ] Implementation executed
- [ ] Session saved with `/save`
- [ ] Deviations recorded in implementation-notes.md

### Phase Completion
- [ ] All deliverables complete
- [ ] `/checkpoint` executed to archive phase
- [ ] ROADMAP.md updated (phase marked complete)
- [ ] Ready for next phase
