---
type: adr
status: accepted
version: 1.0.0
created: 2026-01-27
updated: 2026-01-27
tags: [sync, versioning, templates, schemas]
dependencies: []

deciders: [Framework Team]
supersedes: []
superseded-by: []
---

# ADR-005: Sync Versioning Strategy

## Context

### Current State

Blueprint uses a 3-layer architecture for templates and schemas:

```
Framework Core (core/*)
    ↓ install-global.sh
User Base (~/.claude/blueprint/base/*)
    ↓ blueprint project init (one-time copy)
Project-specific (~/.claude/blueprint/projects/{alias}/*)
```

Previously, project initialization was a one-time copy with no mechanism to propagate framework updates to existing projects.

### Problem

When the framework adds new templates/schemas or fixes bugs in existing ones:
- Existing projects don't receive updates automatically
- Manual copying is error-prone and tedious
- Risk of overwriting project-specific customizations

### Requirements

1. Framework developers must be able to distribute updates to existing projects
2. Project maintainers must be able to protect their customizations
3. The mechanism must be transparent and predictable

---

## Decision

We will use **version + updated date comparison** for sync operations.

### Rationale

Semantic versioning provides clear intent:
- Version bump = intentional change
- Updated date = minor fix or patch

Combining both fields provides granular control over sync behavior.

### Details

#### Comparison Logic

```
base.version > project.version → [UPDATE] (requires --force)
base.version < project.version → [CUSTOMIZED] (skipped)
base.version == project.version:
    base.updated > project.updated → [PATCH] (requires --force)
    base.updated < project.updated → [CUSTOMIZED] (skipped)
    base.updated == project.updated → [OK] (identical)
```

#### Framework Developer Responsibilities

When modifying `core/` files:

| Change Type | Action Required |
|-------------|-----------------|
| New file | Set `version: 0.0.1`, `updated: {today}` |
| Bug fix (no behavior change) | Update `updated` field only |
| Feature addition | Bump MINOR version (`0.0.1` → `0.1.0`) |
| Breaking change | Bump MAJOR version (`0.1.0` → `1.0.0`) |

**IMPORTANT**: Forgetting to update version/date means existing projects won't see the change as an update.

#### Project Maintainer Protections

To protect customized files from sync:

1. Increase `version` field (e.g., `0.0.1` → `1.0.0`)
2. Or increase `updated` date

Files with higher values than base are marked `[CUSTOMIZED]` and skipped.

---

## Consequences

### Positive

- Clear contract between framework and projects
- Automatic protection for customized files
- Transparent preview with `--dry-run`
- No accidental overwrites without `--force`

### Negative

- Framework developers must remember to update version/date
- Automated CI checks may be needed to enforce versioning
- Projects that don't customize can still get "stuck" on old versions if they never run sync

### Neutral

- Sync is opt-in (projects must run `blueprint project sync`)
- `plans/` directory is excluded from sync (project-specific data)

---

## Confirmation

Verify the strategy is working:

1. Modify a core template and bump version
2. Run `install-global.sh`
3. In a project, run `blueprint project sync --dry-run`
4. Confirm the file shows `[UPDATE]` status
5. Customize a project file by increasing its version
6. Run sync again and confirm it shows `[CUSTOMIZED]`

---

## References

- [Semantic Versioning 2.0.0](https://semver.org/)
- `core/claude/skills/blueprint/project/project.sh` - sync implementation
- `core/claude/skills/blueprint/SKILL.md` - user documentation
