---
type: adr
status: accepted
version: 0.0.1
created: 2026-02-06
updated: 2026-02-06
tags: [orchestrator, slash-command, agent, multi-agent, pattern]
dependencies: []

deciders: [user, claude]
supersedes: []
superseded-by: []
---

# ADR-006: Orchestrator Pattern for Multi-Agent Coordination

## Context

PLAN-006 delivered the Phase Analyzer Agent — a focused subagent that evaluates a single Phase's Tasks using a 5-dimension scoring framework and recommends a Plan Mode Strategy. The agent follows a clear contract: receive one Phase, return one analysis (`request:phase-analysis` → `response:phase-analysis`).

### Current State

```
User ──→ /load ──→ Phase Analyzer (Phase N) ──→ Recommendation
                   └─ Single-Phase, sequential invocation
```

The Phase Analyzer is invoked once per Phase at Phase start via `/load`. It analyzes only the current Phase and returns a Plan Mode recommendation. This design keeps the agent focused but creates two operational bottlenecks.

### Problem

1. **Sequential Phase Analysis**: When a Plan is finalized and the user wants to understand the full landscape before starting implementation, they must wait until each Phase begins to get its analysis. This creates a "fog of war" where future Phase complexity is unknown.

2. **No Cross-Phase Independence Detection**: The existing `inter_task_dependency: low|medium|high` assessment is qualitative and scoped to a single Phase. There is no mechanism to identify Tasks from different Phases that could execute independently (e.g., T-1.4 and T-3.3 sharing no file, data, or structural dependencies).

### Requirements

| # | Requirement |
|---|-------------|
| 1 | Analyze ALL Phases of a Plan before implementation starts |
| 2 | Execute Phase analyses in parallel (not sequentially) |
| 3 | Identify independently executable Tasks across Phase boundaries |
| 4 | Preserve Phase Analyzer's focused, single-Phase responsibility |
| 5 | Allow experimental adoption without disrupting existing workflows |

---

## Considered Options

| Option | Description |
|--------|-------------|
| A. Slash Command as Orchestrator | New command handles parallel invocation, aggregation, and storage; Phase Analyzer unchanged |
| B. Expand Phase Analyzer Agent | Modify agent to accept multi-Phase input and handle coordination internally |

### Option A: Slash Command as Orchestrator

A new Slash Command (`/banalyze`) acts as an orchestrator: it reads the Plan, spawns one Phase Analyzer per Phase in parallel using the Task tool, collects all responses, performs cross-Phase analysis, and writes results to the Plan document.

**Pros:**
- Phase Analyzer remains focused on single-Phase analysis (no scope expansion)
- Follows established command patterns (`/bplan`, `/load` are orchestrators for their workflows)
- Experimental feature can be added/removed by creating/deleting one file
- Separation of concerns: agent does analysis, command does coordination
- Cross-Phase analysis (comparing results across Phases) is naturally an orchestrator concern

**Cons:**
- Adds a new command file to maintain
- Orchestration logic lives in a Markdown command template (not programmatic)
- Main Session must interpret and execute the orchestration steps

### Option B: Expand Phase Analyzer Agent

Modify the Phase Analyzer agent to accept either a single Phase or an entire Plan, handle parallel Task analysis internally, and return aggregated results.

**Pros:**
- Single agent handles everything (no additional command)
- Agent has direct access to all Phase data simultaneously

**Cons:**
- Violates Constitution Principle V (Scope Discipline): agent scope expands from single-Phase to multi-Phase
- Breaks the existing `request:phase-analysis` → `response:phase-analysis` contract
- Makes the agent harder to test and reason about
- Cannot be experimentally isolated — changes affect all Phase Analyzer invocations
- Conflates analysis (agent concern) with orchestration (workflow concern)

---

## Decision

We will use **Option A: Slash Command as Orchestrator**.

When multi-agent coordination is needed, create a Slash Command that orchestrates existing agents rather than expanding an agent's scope.

### Rationale

1. **Isolation by Design** (Constitution III): Each agent loads only what it needs. The Phase Analyzer needs one Phase; the orchestrator needs all Phase results. These are different scopes requiring different contexts.

2. **Established Pattern**: `/bplan` orchestrates Plan creation workflow, `/load` orchestrates session restoration. `/banalyze` follows the same pattern — commands orchestrate, agents analyze.

3. **Experimental Safety**: `/banalyze` is an experimental feature. As a standalone command file, it can be added, modified, or removed without touching the proven Phase Analyzer agent.

4. **Separation of Concerns**: Analysis (scoring, grading, recommending) is the agent's domain. Coordination (parallel spawning, result aggregation, cross-Phase comparison, user interaction, storage) is the orchestrator's domain.

### Details

#### Architecture

```
User ──→ /banalyze ──→ Read PLAN.md
                       ├─→ Task(Phase Analyzer, Phase 1) ──┐
                       ├─→ Task(Phase Analyzer, Phase 2) ──┤ parallel
                       └─→ Task(Phase Analyzer, Phase N) ──┘
                       ←── Collect all responses
                       ──→ Cross-Phase independence analysis
                       ──→ Present results to User
                       ←── User decides Plan Mode per Phase
                       ──→ Write to PLAN.md "Analysis Results"
```

#### Responsibility Separation

| Concern | Owner | Rationale |
|---------|-------|-----------|
| Task scoring (5 dimensions) | Phase Analyzer Agent | Domain expertise, single-Phase scope |
| Independence evaluation (per Phase) | Phase Analyzer Agent | Extension of existing Step 4 |
| Parallel invocation | `/banalyze` Command | Workflow orchestration |
| Cross-Phase independence | `/banalyze` Command | Requires comparing results across Phases |
| User interaction (Plan Mode selection) | `/banalyze` Command | UX concern, not analysis |
| Result storage (PLAN.md) | `/banalyze` Command | Document management |

#### When to Apply This Pattern

Use the Orchestrator Pattern when:
- Multiple agent invocations are needed for a single user action
- Results from multiple agents must be aggregated or compared
- The coordination logic is workflow-level, not domain-level
- Experimental isolation is desired

Do NOT use this pattern when:
- A single agent invocation suffices
- The coordination is internal to the agent's domain expertise
- Adding a command would be over-engineering for a one-off need

---

## Consequences

### Positive

- Phase Analyzer agent remains focused and testable (single-Phase contract preserved)
- Pattern is reusable for future multi-agent coordination needs
- Experimental features can be introduced and retired at the command layer without affecting agents
- Clear separation between "what to analyze" (agent) and "how to coordinate" (command)

### Negative

- Orchestration logic in Markdown templates depends on Main Session's correct interpretation
- Adding a new orchestrator command for each coordination need may lead to command proliferation
- Cross-Phase analysis logic is duplicated in the command template rather than being programmatic

### Neutral

- The pattern does not change how individual agents are designed or invoked
- Existing `/load` invocation of Phase Analyzer (single-Phase, at Phase start) continues to work unchanged

---

## Confirmation

- [ ] `/banalyze` command exists as a standalone file (`core/claude/commands/banalyze.md`)
- [ ] Phase Analyzer agent instruction (`core/claude/agents/phase-analyzer.md`) retains single-Phase scope
- [ ] Phase Analyzer constitution (`core/constitutions/agents/phase-analyzer.md`) is unchanged
- [ ] `/banalyze` spawns Phase Analyzers via Task tool in parallel (single message)
- [ ] Cross-Phase independence analysis occurs in the command, not in the agent

---

## References

- [ADR-002: Constitution and Instruction Separation](./002-constitution-instruction-separation.md) — Agent scope boundaries
- PLAN-006: Phase Analyzer Agent — Established single-Phase analysis pattern
- PLAN-007: Phase Analyzer Slash Command — First implementation of this pattern
- Blueprint Constitution III: Isolation by Design — Agents should never pollute each other's context
