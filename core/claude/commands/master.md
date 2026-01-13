---
description: Apply Master Plan workflow for creating structured implementation plans
---

## First: Load Project Constitution

Run `blueprint.sh lexis --base` to understand the project's base principles.
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
- **Phase 3**: Spec Writing (all [DECIDE] resolved)
- Phase transitions REQUIRE user confirmation

### User Confirmation
- NO output without explicit user confirmation
- Each [DECIDE] resolution REQUIRES user input
- Assumption-based planning is FORBIDDEN

### Hierarchical Specification (Lib/Feature)
- **Lib**: Reusable units (3+ uses OR standalone value)
- **Feature**: Composition of Libs, business flow

## Directory Structure

```
blueprint/plans/{nnn}-{topic}/
├── memory.md           # Discussion, background, decisions
├── master-plan.md      # High-level phases + Directive Markers
├── lib/{ns}/{mod}.md   # Lib specifications
├── feature/{name}.md   # Feature specifications
└── implementation-notes.md  # Issues during implementation
```

## ID Formats

| Type | Format | Example |
|------|--------|---------|
| Plan | `PLAN-{NNN}` | `PLAN-001` |
| Lib | `LIB-{namespace}/{module}` | `LIB-auth/jwt-validator` |
| Feature | `FEAT-{name}` | `FEAT-user-authentication` |
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
3. Define Lib/Feature classification (Rule of Three)
4. Present to user
5. WAIT for user confirmation

### Phase 3: Spec Writing

1. For each Lib → create `lib/{ns}/{mod}.md`
2. For each Feature → create `feature/{name}.md`
3. Resolve `[DECIDE]` through conversation
4. Update Memory with decisions

---

## Implementation: Plan Mode Integration

Master Plan defines **what** to build. Claude Code's **Plan Mode** defines **how** to build each phase.

### Workflow

```
Master Plan (High-level)
├── Phase 1: {deliverables, lib/feature refs}
│   └── [Enter Plan Mode] → Detailed implementation plan → Execute
├── Phase 2: {deliverables, lib/feature refs}
│   └── [Enter Plan Mode] → Detailed implementation plan → Execute
└── Phase N: ...
    └── [Enter Plan Mode] → Detailed implementation plan → Execute
```

### Before Each Phase Implementation

1. **Review Master Plan Phase** - Check deliverables and lib/feature references
2. **Enter Plan Mode** - Use Claude Code's Plan Mode for detailed planning
3. **Reference Specs** - Plan Mode should reference `lib/` and `feature/` specs
4. **Execute** - Implement according to Plan Mode's detailed plan
5. **Update Notes** - Record deviations in `implementation-notes.md`

### Phase Entry Protocol

When starting a Master Plan phase implementation:

```
User: "Let's implement Phase N"
Assistant:
1. Read master-plan.md Phase N section
2. Identify referenced lib/feature specs
3. Enter Plan Mode (EnterPlanMode tool)
4. Create detailed implementation plan referencing specs
5. Exit Plan Mode with user approval
6. Execute implementation
```

**IMPORTANT**: Do NOT skip Plan Mode for non-trivial phases. Plan Mode ensures:
- Detailed file-level planning
- User approval before changes
- Alignment with Master Plan specs

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

Use `blueprint.sh` for templates and schemas:

```bash
# Templates - PREFER copy over show to save Context
blueprint.sh forma list                    # List available templates
blueprint.sh forma copy master-plan ./dir/ # Copy template (RECOMMENDED)
blueprint.sh forma copy memory ./dir/      # Creates memory.md
blueprint.sh forma copy lib-spec ./dir/lib/auth/  # Creates lib spec

# Schemas - Use show for validation reference
blueprint.sh frontis schema master-plan    # View schema for validation

# Constitution
blueprint.sh lexis --base                  # Project base principles
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
- [ ] Lib/Feature classification done (Rule of Three)
- [ ] [DECIDE] markers added for uncertainties
- [ ] [FIXED] constraints documented
- [ ] User approved the plan

### Phase 3: Spec Writing
- [ ] All Lib specs created in `lib/` directory
- [ ] All Feature specs created in `feature/` directory
- [ ] All [DECIDE] resolved through conversation
- [ ] Memory updated with final decisions
- [ ] User approved final specs

### Phase N Implementation (per Master Plan phase)
- [ ] Master Plan phase reviewed
- [ ] Spec references identified
- [ ] **Plan Mode entered** (EnterPlanMode)
- [ ] Detailed implementation plan created
- [ ] Plan Mode exited with user approval
- [ ] Implementation executed
- [ ] Deviations recorded in implementation-notes.md
