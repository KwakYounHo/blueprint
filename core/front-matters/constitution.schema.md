---
type: schema
status: active
version: 1.0.0
created: 2025-11-28
updated: 2025-11-28
tags: [schema, constitution, front-matter]
dependencies: [front-matters/base.schema.md]
---

# Schema: Constitution FrontMatter

> Extends base schema with Constitution-specific fields.

## Inherits

All fields from `base.schema.md`:

- `type`, `status`, `version`, `created`, `updated`, `tags`, `dependencies`

## Additional Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `scope` | enum | Constitution applicability scope |
| `target-agents` | string[] | Agents that must follow this constitution |

## Field Definitions

### scope

- **Type**: enum
- **Required**: Yes
- **Values**: `global` | `agent-specific`
- **Description**: Defines whether this constitution applies globally or to specific agents.

| Value | Description |
|-------|-------------|
| `global` | Applies to all (base.md) |
| `agent-specific` | Applies only to agents listed in `target-agents` |

### target-agents

- **Type**: string[]
- **Required**: Yes
- **Valid Values**: `reviewer`, `all`
- **Description**: List of agents that must follow this constitution.

**Rules**:
- `"all"` cannot be combined with other values
- Multiple agents allowed: `["reviewer", "planner"]`

| Example | Meaning |
|---------|---------|
| `["all"]` | All agents must follow |
| `["reviewer"]` | Only Reviewer agent |

## Constraints

| Rule | Description |
|------|-------------|
| Scope-Target | `scope: global` requires `target-agents: ["all"]` |
| Scope-Target | `scope: agent-specific` forbids `target-agents: ["all"]` |
| Type | `type` field must be `constitution` |
| Status | Must be one of: `draft`, `active`, `deprecated`, `archived` |

## Field Guidelines

### tags (recommended)

- Global constitution: `[principles, global, constitution]`
- Agent-specific: `[agent, {agent-name}, constitution]`

### dependencies (recommended)

- Agent-specific constitutions SHOULD include path to base.md
- Example: `["../base.md"]`

## Template

For complete example, use:

```bash
forma show constitution
```
