# Templates

> Starting points for project initialization. These files are copied to target projects and customized.

---

## Purpose

This directory contains **template files** that serve as:

1. **Structure Definition**: Define the expected file/directory structure
2. **Schema Reference**: Include schema as comments within templates
3. **Starting Point**: Provide initial content that can be customized

---

## Directory Structure

```
templates/
├── README.md                    # This file
│
├── claude-agents/               # → Copied to .claude/agents/
│   └── (Worker definition templates)
│
└── blueprint/                   # → Copied to blueprint/
    ├── constitutions/           # Principle definitions
    ├── gates/                   # Gate and Aspect definitions
    ├── workflows/               # Phase and Stage definitions
    └── features/                # Feature and Artifact templates
```

---

## Template vs Instance

| Concept | Location | Role |
|---------|----------|------|
| **Template** | `agent-docs/templates/` | Reusable starting point |
| **Instance** | `target-project/` | Customized for specific project |

### Initialization Flow

```
templates/claude-agents/     ──copy──►  .claude/agents/
templates/blueprint/         ──copy──►  blueprint/
```

---

## Template File Naming

| Pattern | Meaning |
|---------|---------|
| `*.template.md` | Template file (schema + placeholder content) |
| `README.md` | Directory documentation (not copied to project) |
| `feature.md`, `gate.md` | Metadata files in their respective directories |

---

## Schema in Templates

Templates include schema as YAML front matter comments:

```markdown
---
# === SCHEMA ===
# type: artifact (required)
# status: draft | active | ... (required)
# created: YYYY-MM-DD (required)
# updated: YYYY-MM-DD (required)
# tags: string[] (optional)
# related: string[] (optional)
# === END SCHEMA ===

type: artifact
status: draft
created: {{DATE}}
updated: {{DATE}}
tags: []
related: []
---

# Title

Content placeholder...
```

---

## Subdirectories

| Directory | Purpose | See |
|-----------|---------|-----|
| `claude-agents/` | Claude Code Worker definitions | `claude-agents/README.md` |
| `blueprint/` | Framework core templates | `blueprint/README.md` |

---

## Related

- `../README.md` for overall framework documentation
- `../initializers/` for scripts that copy these templates
- `../commands/` for slash commands that use these templates
