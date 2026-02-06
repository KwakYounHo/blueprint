---
description: Orchestrate Phase Analyzer with parallel execution for all Phases
---

# Phase Analysis Orchestrator

Analyze all Phases of a Plan in parallel, identify independent Tasks,
and record Plan Mode decisions.

## Blueprint Skill Reference

Load `/blueprint` skill for plan discovery and handoff operations. Execute commands in Bash using full path:

| Operation | Submodule + Subcommand |
|-----------|----------------------|
| Resolve plan | `plan resolve` |
| View request format | `hermes request:phase-analysis` |
| View response format | `hermes response:phase-analysis` |

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

After plan selection, set:
- `{PLAN_PATH}` = resolved plan path (e.g., from `~/.claude/skills/blueprint/blueprint.sh plan resolve 001`)

Use this path for all references below.

---

## Workflow

### Step 1: Load Blueprint Skill (MANDATORY)

Load `/blueprint` skill.

### Step 2: Resolve Plan Path

From argument or active plan:
- With argument: `blueprint plan resolve <identifier>`
- Without argument: `blueprint plan list --status in-progress` → user selects

### Step 3: Read Plan and Extract Phases

1. Read `{PLAN_PATH}/PLAN.md`
2. Extract all Phase sections (`### Phase {N}:`)
3. Count total Phases
4. Verify Plan status is `in-progress` or `draft`

### Step 4: Spawn Parallel Phase Analyzers

For each Phase (1 to N), invoke Phase Analyzer in parallel:

```
Use Task tool with subagent_type: "phase-analyzer"
prompt: |
  Analyze Phase {N} of Plan.

  Plan: {PLAN_PATH}/PLAN.md
  Phase: {N}

  Perform 5-dimension evaluation for each Task.
  Evaluate Task independence using mandatory criteria (File Disjointness,
  Data Flow Independence, Structural Independence).
  Apply optional criteria (Resource, Order) if external dependencies involved.
  Return Plan Mode Strategy recommendation with independence analysis.
```

All Phase Analyzer calls MUST be made in a single message (parallel execution).

### Step 5: Collect and Aggregate Results

After all Phase Analyzers return:

1. Collect all Handoff responses
2. Per Phase: extract task_analysis, phase_summary, recommendation,
   task_dependencies, independent_groups, execution_layers
3. Cross-Phase independence analysis:
   - Compare Files fields across ALL Tasks in ALL Phases
   - Identify Tasks from different Phases that share no files,
     no data flow, and no structural dependencies
   - Group these as "Cross-Phase Independent Tasks"

### Step 6: Present Results to User

Output the following:

**A. Per-Phase Summary**

For each Phase:
| Phase | Objective | Tasks | Grade Distribution | Recommended Mode |
|-------|-----------|-------|-------------------|-----------------|

**B. Per-Phase Execution Layers**

For each Phase:
| Layer | Tasks | Note |
|-------|-------|------|

**C. Cross-Phase Independent Tasks**

| Task | Phase | Files | Independence Reason |
|------|-------|-------|--------------------|

**D. Scoring Method Summary** (brief)
- 5 dimensions, 1-4 points each, total 5-20
- Grades: Simple(5-8), Moderate(9-12), Complex(13-16), Critical(17+)

### Step 7: User Decides Plan Mode per Phase

Use AskUserQuestion for each Phase:
- Present recommended strategy (mark as recommended)
- Include alternatives with trade-offs

### Step 8: Write Analysis Results to PLAN.md

Write the user's decisions to PLAN.md "## Analysis Results" section:
- Fill "Phase Summaries" table
- Fill "Selected Strategies" table
- Fill "Execution Layers" table
- Fill "Independent Tasks (Cross-Phase)" table

### Step 9: Confirmation

Output completion summary:
- Number of Phases analyzed
- Selected strategies per Phase
- Number of cross-Phase independent Tasks identified
- Remind user: `/load` will reference these results

---

## DO

- Load Blueprint Skill before any operation
- Spawn ALL Phase Analyzers in parallel (single message)
- Present per-Phase results with scores and rationale
- Include cross-Phase independent Task analysis
- Wait for user decision per Phase before writing
- Write results to PLAN.md Analysis Results section

## DO NOT

- Modify PLAN.md Phases, Tasks, or Deliverables
- Skip any Phase in analysis
- Force Plan Mode decisions
- Invoke Phase Analyzers sequentially
- Write Analysis Results before user confirmation
- Analyze Plans with status `completed`
