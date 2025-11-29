---
name: frontmatter-search
description: Search blueprint documents by YAML FrontMatter metadata fields (type, status, version, tags, dependencies). Use when you need to find documents matching specific metadata criteria like "find all tasks", "documents with status active", or "files of type constitution".
allowed-tools: Read, Grep, Glob
---

# FrontMatter Document Search

Blueprint documents contain metadata in YAML FrontMatter.
Use **metadata-based search** instead of filename or content search.

---

## Schema Reference

See `blueprint/front-matters/` for schema definitions:

| File | Description |
|------|-------------|
| `base.schema.md` | Common fields for all documents |
| `phase.schema.md` | Phase (spec.md) documents |
| `stage.schema.md` | Stage documents |
| `task.schema.md` | Task documents |
| `progress.schema.md` | Progress documents |
| `constitution.schema.md` | Constitution documents |
| `gate.schema.md` | Gate documents |
| `aspect.schema.md` | Aspect documents |

---

## Common FrontMatter Fields

Based on `base.schema.md`:

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `type` | enum | Document type | `task`, `stage`, `phase`, `constitution`, `gate`, `aspect` |
| `status` | enum | Current state | `draft`, `active`, `deprecated`, `archived` |
| `version` | semver | Document version | `1.0.0` |
| `created` | date | Creation date | `2025-11-30` |
| `updated` | date | Last modified | `2025-11-30` |
| `tags` | string[] | Search keywords | `[critical, api, auth]` |
| `dependencies` | string[] | Dependent documents | `[base.schema.md]` |

---

## Search Patterns

### Single Field Search

```
# Search by type (e.g., all task documents)
Grep: pattern="^type: task" path="blueprint/" glob="*.md"

# Search by status (e.g., active documents)
Grep: pattern="^status: active" path="blueprint/" glob="*.md"

# Search by version
Grep: pattern="^version: 1\.0\.0" path="blueprint/" glob="*.md"

# Search by tags containing specific value
Grep: pattern="^tags:.*critical" path="blueprint/" glob="*.md"

# Search by dependencies containing specific file
Grep: pattern="^dependencies:.*base\.schema\.md" path="blueprint/" glob="*.md"
```

### Important Notes

- `^` prefix: Match line start (distinguish from body content)
- FrontMatter is located in the `---` block at the top of the file
- `.` is a regex special character, escape with `\.`

---

## Compound Search (Sequential Filtering)

For multiple conditions, use sequential filtering:

**Example: "documents where type is task AND status is active"**

1. Extract file list with first condition:
   ```
   Grep: pattern="^type: task" path="blueprint/" output_mode="files_with_matches"
   ```

2. Filter results with second condition:
   ```
   For each file:
   Read → Check FrontMatter → Verify status: active
   ```

---

## Result Format

Report search results in this format:

```
Found N documents matching [criteria]

1. path/to/document1.md
   - type: task
   - status: active
   - version: 1.0.0

2. path/to/document2.md
   - type: task
   - status: draft
   - version: 0.1.0

...
```

---

## Example Queries

| User Request | Search Pattern |
|--------------|----------------|
| "Find all task documents" | `^type: task` |
| "Documents with active status" | `^status: active` |
| "List constitution documents" | `^type: constitution` |
| "Documents with critical tag" | `^tags:.*critical` |
| "Stage documents in draft status" | `^type: stage` → `^status: draft` |
