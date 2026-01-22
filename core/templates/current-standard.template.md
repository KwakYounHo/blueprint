---
type: current
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [session, handoff, current]
dependencies: [../PLAN.md, ../ROADMAP.md]

plan-id: "PLAN-{NNN}"
session-id: 1
current-phase: 1
current-task: "T-1.1"
---

# Session Handoff

**Date:** {{date}}
**Branch:** {branch-name}

---

## Plan Context

**Plan:** PLAN-{NNN} - {Plan Name}
**Plan Path:** `../PLAN.md`
**Current Phase:** Phase {N} - {Phase Name}
**Current Task:** T-{N}.{M} - {Task Name}
**Task Objective:** {One sentence from PLAN.md}

---

## Current Goal

{What we're working on this session - 2-3 sentences}

## Completed This Session

- {Specific accomplishment with file:line}
- {Commit: hash - message}

## Key Decisions Made

1. **{Decision}**: {Reasoning}
2. **{Decision}**: {Reasoning}

## Current State

**Git Status:** {clean/modified files summary}
**Tests:** {passing/failing - specifics}
**Blockers:** {none or detailed description}

## Next Agent Should

1. **{Action}**: {Specific task with file:line}
   - Context: {why this matters}
   - Expected time: {estimate}
   - Success criteria: {how to verify}

2. **{Action}**: {Specific task}

3. **{Action}**: {Specific task}

## Key Files

- `path/to/file.ts` (Lines X-Y): {Purpose and current state}
- `path/to/another.ts`: {Purpose}

## References

- Plan: `../PLAN.md`
- ROADMAP: `../ROADMAP.md`
- ADR: {if applicable}
- Related Issues: {links}
