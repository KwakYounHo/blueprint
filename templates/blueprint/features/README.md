# Features

> Containers for related Artifacts. One Feature = One Branch = One Directory.

---

## Purpose

Features are the **organizational unit for all Artifacts**:

1. **Group related work**: All Artifacts for one feature in one place
2. **Branch synchronization**: Feature directory name = Git branch name
3. **Isolation**: Features don't interfere with each other
4. **Traceability**: Easy to track what was done for each feature

---

## Background

### Why Feature-Based Organization?

Without grouping:
```
artifacts/
├── spec-001.md
├── spec-002.md
├── task-001.md
├── task-002.md
├── task-003.md
├── review-001.md
└── (chaos as project grows)
```

With Feature grouping:
```
features/
├── 001-user-auth/
│   ├── spec.md
│   ├── tasks/
│   └── reviews/
└── 002-payment-flow/
    ├── spec.md
    ├── tasks/
    └── reviews/
```

### Branch Synchronization

From Git best practices:
> "Feature branches isolate work on a specific feature from the main codebase"

By synchronizing directory name with branch name:
- Clear mapping between code and documentation
- Easy to find related artifacts
- Clean merges when feature is complete

---

## Directory Structure

```
features/
├── README.md                    # This file
│
└── {feature-id}/                # One directory per Feature
    ├── feature.md               # Feature metadata
    ├── spec.md                  # Specification (Artifact)
    ├── plan.md                  # Implementation plan (Artifact)
    ├── tasks/                   # Task documents
    │   ├── task-001.md
    │   ├── task-002.md
    │   └── ...
    └── reviews/                 # Review results
        ├── spec-gate-review.md
        └── impl-gate-review.md
```

---

## Feature ID Format

```
{number}-{short-description}
```

| Part | Format | Example |
|------|--------|---------|
| `number` | 3-digit, zero-padded | `001`, `042`, `123` |
| `short-description` | lowercase, hyphen-separated | `user-auth`, `payment-flow` |

**Examples**:
- `001-statement-split-merge`
- `002-user-authentication`
- `003-api-rate-limiting`

---

## Branch Naming

Feature directory maps to Git branch:

| Feature Directory | Git Branch |
|-------------------|------------|
| `features/001-user-auth/` | `feature/001-user-auth` |
| `features/002-payment/` | `feature/002-payment` |

**Workflow**:
```bash
# Create feature branch
git checkout -b feature/001-user-auth

# Feature artifacts are created in
# blueprint/features/001-user-auth/

# When complete, merge brings both code and artifacts
git checkout main
git merge feature/001-user-auth
```

---

## Feature Metadata (`feature.md`)

### Front Matter

```yaml
---
type: feature
status: in-progress
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [feature-tag-1, feature-tag-2]
related: []

# Feature-specific
feature-id: "001-feature-name"
branch: "feature/001-feature-name"
phase: specification | implementation
---
```

### Content Structure

```markdown
# Feature: {Feature Name}

## Overview
[Brief description of what this feature does]

## Motivation
[Why this feature is needed]

## Scope
[What is included / excluded]

## Artifacts
| Artifact | Status | Path |
|----------|--------|------|
| Specification | complete | ./spec.md |
| Plan | complete | ./plan.md |
| Task 001 | in-progress | ./tasks/task-001.md |
| Task 002 | pending | ./tasks/task-002.md |

## Timeline
- Created: YYYY-MM-DD
- Spec Completed: YYYY-MM-DD
- Implementation Started: YYYY-MM-DD
- Completed: (pending)
```

---

## Artifact Types in Feature

| Artifact | File | Created By | When |
|----------|------|------------|------|
| **Feature Metadata** | `feature.md` | Orchestrator | Feature start |
| **Specification** | `spec.md` | Specifier | Specification Phase |
| **Plan** | `plan.md` | Specifier | Specification Phase |
| **Task** | `tasks/task-*.md` | Specifier | Specification Phase |
| **Review** | `reviews/*.md` | Reviewer | Gate validation |

---

## Artifact Status Values

| Status | Meaning |
|--------|---------|
| `pending` | Not yet started |
| `in-progress` | Currently being worked on |
| `completed` | Successfully finished |
| `failed` | Failed, needs attention |

---

## Feature Lifecycle

```
1. Feature Created
   └── feature.md created
   └── Branch created: feature/{id}

2. Specification Phase
   └── Specifier creates spec.md
   └── Specifier creates plan.md
   └── Specifier creates tasks/task-*.md

3. Specification Gate
   └── Reviewers create reviews/spec-gate-review.md

4. Implementation Phase
   └── Implementers work on tasks
   └── Task status: pending → in-progress → completed

5. Implementation Gate
   └── Reviewers create reviews/impl-gate-review.md

6. Completion
   └── Feature status: completed
   └── Branch merged to main
```

---

## Best Practices

### One Feature, One Focus

Each Feature should have:
- Single, clear purpose
- Defined scope
- Achievable size (not too large)

### Keep Feature Directory Clean

```
Good:
features/001-user-auth/
├── feature.md
├── spec.md
├── plan.md
├── tasks/
└── reviews/

Bad:
features/001-user-auth/
├── feature.md
├── spec.md
├── spec-v2.md          # Don't version in filename
├── old-plan.md         # Don't keep old versions
├── notes.md            # Use spec.md for notes
└── random-stuff/       # No random directories
```

### Use Tags for Cross-Feature Queries

```yaml
# In feature.md
tags: [authentication, security, user-management]
```

Query: "Find all features related to security"
→ Search Front Matter for `tags: [...security...]`

---

## Related

- `../workflows/` for Phase/Stage definitions
- `../gates/` for validation criteria
- `../../claude-agents/` for Worker behavior definitions
