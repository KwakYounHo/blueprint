---
type: progress
status: pending
version: 1.0.0
created: "{{date}}"
updated: "{{date}}"
tags: [progress, tracking]
dependencies:
  - "{{task-01-01-name.md}}"
  - "{{task-01-02-name.md}}"
---

<!--
INITIALIZATION GUIDE (For Specifier Worker):

This template is referenced when creating progress.md (Progress document).
Progress document is created together with Task documents.

[Progress Document Characteristics]
- Only one per Workflow
- Updated by Orchestrator whenever a Task is completed
- Must list all Task files in dependencies field

[Status Values]
- pending: Workflow not yet started
- in-progress: Currently being executed
- completed: All Tasks successfully finished
- failed: Workflow did not complete successfully

Remove this guide comment after completion.
-->

# Progress: {{workflow-name}}

<!--
[FIXED] - Framework Core Rule
Progress document answers "How much": How much progress has been made?

[Responsibilities]
- Initialization: Specifier Worker (together with Task creation)
- Updates: Orchestrator (whenever a Task is completed)

[Update Rules]
- Check off completed Tasks ([ ] → [x])
- Update the "updated" date
- Change status to "completed" when all Tasks are done
-->

---

## Overview

<!--
On initialization: List all Tasks with Completed = 0
On update: Update Completed count and percentage as Tasks complete
-->

| Stage | Tasks | Completed | Progress |
|-------|-------|-----------|----------|
| {{Stage 1 name}} | {{N}} | 0 | 0% |
| {{Stage 2 name}} | {{N}} | 0 | 0% |
| **Total** | **{{Total Task count}}** | **0** | **0%** |

---

## Stage 1: {{stage-name}}

<!--
Manage each Task's status as a checklist
Completion format: - [x] `task-XX-YY`: Task name - Completed YYYY-MM-DD
-->

- [ ] `task-01-01`: {{Task name}} - Pending
- [ ] `task-01-02`: {{Task name}} - Pending

---

## Stage 2: {{stage-name}}

- [ ] `task-02-01`: {{Task name}} - Pending
- [ ] `task-02-02`: {{Task name}} - Pending

---

## Notes

<!--
Items to record during workflow execution
-->

### Blockers

<!--
Issues blocking progress (cannot proceed to next step until resolved)
Example: "Cannot implement authentication due to missing external API key"
-->

- (None)

### Issues

<!--
Problems discovered after Gate passed (continue work, fix later)
Example: Bugs found during E2E testing, environment-specific issues
Format: - [ISSUE-NNN] Description (Discovered: YYYY-MM-DD)
-->

- (None)

### Decisions

<!--
Decisions made during workflow execution
Example: "Decided to add Redis caching due to performance issues"
-->

- (None)

### Observations

<!--
Noteworthy observations
Example: "API response faster than expected", "Code complexity increasing"
-->

- (None)

---

## Change Log

<!--
Record of significant changes
Format: YYYY-MM-DD - Description of change
-->

| Date | Change |
|------|--------|
| {{date}} | Progress document initialized |

---

**Version**: {{version}} | **Created**: {{date}}
