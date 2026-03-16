---
description: Verify implementation against Plan intent and production readiness
---

# Implementation Verification

Verify completed implementation from two perspectives:
1. **Phase 1 — Intent Verification** — Does the code reflect BRIEF/PLAN/Linear intent?
2. **Phase 2 — Production Readiness** — Is the code safe to promote to production?

Phase 1 must pass before Phase 2 begins.

## Blueprint Skill Reference

Load `/blueprint` skill for plan discovery and handoff operations. Execute commands in Bash using full path:

| Operation | Submodule + Subcommand |
|-----------|----------------------|
| Resolve plan path | `plan resolve` |
| List active plans | `plan list --status in-progress` |
| Read plan metadata | `frontis show` |
| View verification gate | `aegis verification` |
| View aspect criteria | `aegis verification <aspect>` |
| Reviewer request format | `hermes request:review:verification` |
| Reviewer response format | `hermes response:review:verification` |
| Agent request format | `hermes request:verify:production` |
| Agent response format | `hermes response:verify:production` |
| Final report format | `hermes after-verify` |

---

## Plan Path Resolution

**Resolve specific plan:**
```bash
~/.claude/skills/blueprint/blueprint.sh plan resolve 001   # → /path/to/plans/001-topic/
~/.claude/skills/blueprint/blueprint.sh plan resolve auth  # → /path/to/plans/NNN-auth-feature/
```

After resolution, set:
- `{PLAN_PATH}` = resolved plan path

---

## Argument Parsing

```
/verify              # No argument — auto-detect
/verify 043          # Plan identifier
/verify --no-linear  # Skip Linear verification
/verify 043 --no-linear  # Both
```

Parse `--no-linear` flag from arguments. Remaining non-flag argument is the plan identifier.

---

## Execution Flow

### Step 1: Plan Resolution

```
IF plan identifier provided:
    PLAN_PATH = blueprint plan resolve <identifier>
ELSE:
    Search for session-context/CURRENT.md across plan directories
    IF found → read plan-id from frontmatter → resolve
    ELSE:
        branch = git branch --show-current
        IF branch matches feat/{nnn}-* or similar → extract number → resolve
        ELSE → Error (see Error Recovery: No Plan Found)
```

### Step 2: Context Gathering

Gather three sets of information. Read documents in parallel where possible.

**2a. Blueprint Documents**

Read these files from `{PLAN_PATH}`:

| File | What to Extract |
|------|----------------|
| `BRIEF.md` | `Decisions Made` table (D-xxx), `Scope Summary`, `Out of Scope`, `source-discussion` frontmatter field |
| `PLAN.md` | `Success Criteria` table, `[FIXED] Constraints` table (C-xxx), `File Context` table, Phase/Task deliverables |
| `implementation-notes.md` | `Deviations from Plan` table, `[ACTIVE]` issues |

**2b. Code Diff**

Determine the diff scope automatically:

```
IF git diff --cached is non-empty:
    diff_source = "staged"
    diff_command = git diff --cached -- ':!pnpm-lock.yaml'

ELSE IF current branch is NOT in [main, master, develop, release]:
    diff_source = "feature branch"
    base = main (or master, whichever exists)
    diff_command = git diff {base}...HEAD -- ':!pnpm-lock.yaml'

ELSE IF latest commit message starts with "[Merge]":
    diff_source = "merge commit"
    diff_command = git diff HEAD~1..HEAD -- ':!pnpm-lock.yaml'

ELSE:
    Error: No changes detected (see Error Recovery)
```

Also get changed file list: `git diff --name-only` (with same scope).

**2c. Linear Items Detection**

```
source_discussion = BRIEF.md frontmatter 'source-discussion' value

IF source_discussion is null OR empty OR "--no-linear" flag set:
    linear_items = null
    (Linear verification will be skipped in Phase 1)
ELSE:
    Fetch issue: mcp__linear__get_issue(id: source_discussion)
    Store: issue title, description, project, milestone (if any)
```

### Step 3: Phase 1 — Intent Verification (Reviewer Delegation)

Delegate Phase 1 to Reviewer Agent **synchronously**.

1. **Construct Reviewer prompt** using `hermes request:review:verification`:
   - Replace `{PLAN_PATH}` with resolved plan path
   - Set `diff` to the diff source description from Step 2b
   - Set `flags.no-linear` based on `--no-linear` flag or null `source-discussion`

2. **Provide context** in the prompt:
   - Include the code diff from Step 2b (inline or as reference)
   - Include Linear items from Step 2c (if available)
   - Instruct Reviewer to load each aspect's criteria via `aegis verification <aspect>`

3. **Spawn Reviewer** using Task tool:
   ```
   subagent_type: reviewer
   run_in_background: false  (synchronous — wait for response)
   mode: bypassPermissions
   ```

4. **Wait** for Reviewer to complete. Do NOT proceed to Phase 2 until response received.

### Step 4: Phase 1 Report

Process Reviewer response using `hermes response:review:verification` format:

1. **Parse response** — Extract overall status and per-aspect results

2. **Present results:**

```
━━━━ Phase 1: Intent Verification ━━━━

| Aspect | Status | Detail |
|--------|--------|--------|
| Decisions ({N} checked) | {status} | {detail} |
| Constraints ({N} checked) | {status} | {detail} |
| Success Criteria ({N} checked) | {status} | {detail} |
| Scope | {status} | {detail} |
| Deviations | {status} | {detail} |
| Linear | {status or "skipped"} | {detail} |

Verdict: {PASS/WARNING/FAIL}
```

3. **Handle verdict:**

**On FAIL:**
- List each FAIL item with specific detail (which Decision/Constraint/SC failed and why)
- Output: "Phase 1 FAIL — 위 항목을 해결한 후 다시 /verify를 실행해주세요"
- **Stop execution. Do NOT proceed to Phase 2.**

**On WARNING:**
- List each WARNING item with specific detail and suggested fix
- Ask user: "WARNING 항목을 수정하고 Phase 2로 진행할까요?"
- On approval: apply fixes (e.g., add missing deviation records)
- On decline: stop execution

**On PASS:**
- Brief summary only
- Proceed to Phase 2 immediately

### Step 5: Phase 2 — Production Readiness (Agent Delegation)

Launch 3 review agents **in parallel** (single message, synchronous).

For each agent, construct the prompt using `hermes request:verify:production`:

| Agent | subagent_type | Focus |
|-------|---------------|-------|
| Code Reuse | `code-reuse-reviewer` | Duplicated logic, underutilized existing utilities |
| Code Quality | `code-quality-reviewer` | Redundant state, parameter sprawl, copy-paste, leaky abstractions, stringly-typed, standards violations |
| Code Efficiency | `code-efficiency-reviewer` | Unnecessary work, hot-path bloat, runtime inclusion risk, side effects, memory issues |

For each agent:

1. **Construct prompt** from `hermes request:verify:production`:
   - Set `agent` to the agent name
   - Set `diff` to the code diff from Step 2b

2. **Spawn agent** using Task tool:
   ```
   subagent_type: {agent-name}
   run_in_background: false  (synchronous)
   mode: bypassPermissions
   ```

3. **All 3 agents in a single message** — parallel execution.

### Step 6: Phase 2 Report + User-Confirmed Fixes

Wait for all 3 agents to complete. Process responses using `hermes response:verify:production` format.

1. **Aggregate findings** from all 3 agents into a single table:

```
━━━━ Phase 2: Production Readiness ━━━━

| # | Agent | Finding | Severity | Recommended Action |
|---|-------|---------|----------|--------------------|
| 1 | {agent} | {finding} | {High/Medium/Low} | {action or "Skip"} |
| ... | ... | ... | ... | ... |

Fix: {N} items  |  Skip: {N} items
```

2. **Classify** each finding as:
   - **Fix**: Actionable improvement that should be applied
   - **Skip**: False positive or intentional design choice (note reason)

3. **Ask user**: "위 수정 사항을 적용할까요?"

**On approval:**
   1. Apply fixes
   2. Run tests (if test files were changed or affected)
   3. Run typecheck
   4. Report results

**On decline:**
   - Report only, no changes applied

### Step 7: Final Report

Present final report using `hermes after-verify` format.

---

## Error Recovery

### No Plan Found

```
No plan matching '{identifier}' found.

Available plans:
{list from blueprint plan list}

Usage: /verify {plan-id}
```

### No Changes Detected

```
검증할 변경사항을 특정할 수 없습니다.

다음 중 하나가 필요합니다:
1. Staged changes (git add 후)
2. Feature branch (main 대비 diff)
3. [Merge] commit (직전 커밋)
```

### Linear Issue Not Found

```
Linear issue '{source_discussion}' 조회 실패.

Options:
1. --no-linear 플래그로 Linear 검증 스킵
2. BRIEF.md의 source-discussion 값 확인
```

---

## Tips

### DO:
- ✅ Read all Blueprint documents before constructing Reviewer prompt
- ✅ Include full code diff in Reviewer and agent prompts
- ✅ Cross-reference Reviewer results against each aspect systematically
- ✅ Present clear, structured reports at each phase boundary
- ✅ Ask user before applying any fixes

### DON'T:
- ❌ Skip Phase 1 and go directly to Phase 2
- ❌ Auto-fix FAIL items without user involvement
- ❌ Proceed to Phase 2 if Phase 1 is FAIL
- ❌ Include lock files or generated artifacts in diff analysis
- ❌ Run Phase 1 Reviewer in background (must be synchronous)

ARGUMENTS: $ARGUMENTS
