---
id: "003"
title: Template Annotation System
created: 2025-11-28
status: superseded
scope: implementation
tags: [annotation, template, placeholder, llm, initialization]
related: ["002"]
supersedes: null
superseded-by: "004"
---

# ADR-003: Template Annotation System

## Context

When designing Constitution templates, we needed a system that would guide LLMs during project initialization. The challenge was:

1. **Differentiate LLM actions**: Some content should be inferred from codebase analysis, some requires user decisions, and some is conditionally included.

2. **Ensure consistency**: Templates copied to different projects should produce structurally consistent results.

3. **Balance automation and control**: LLMs should fill what they can analyze, but defer to users for subjective decisions.

We analyzed common patterns in existing specification-driven development frameworks:

- **Single marker approach**: One annotation type for all user interactions (e.g., "needs clarification")
- **Conditional inclusion**: Configuration-based modes for selective content loading
- **Priority tagging**: Content tags to indicate importance or mutability levels

Each approach had merits, but none fully addressed our needs for Constitution templates with clear Constitution/Instruction separation (see ADR-002).

## Decision

We will implement a **four-level annotation system** specifically designed for Blueprint templates.

### Primary Annotations

| Annotation | Purpose | LLM Action |
|------------|---------|------------|
| `[FIXED]` | Framework core rules that ensure proper operation | **Do NOT modify without explicit user confirmation** |
| `[INFER: topic]` | Content derivable from codebase analysis | Analyze and fill without asking user |
| `[DECIDE: topic]` | Content requiring user judgment | Trigger AskUserQuestion |
| `[ADAPT: condition]` | Content conditionally included | Evaluate condition, include/exclude |

### [FIXED] Special Rules

The `[FIXED]` annotation marks framework core content with special protection:

**For LLM**:
- MUST NOT modify `[FIXED]` sections without explicit user confirmation
- Even if user requests changes, MUST ask for confirmation before modifying
- Treat as "protected content" during initialization

**For Users**:
- Modification is allowed but framework behavior is not guaranteed
- Changes to `[FIXED]` sections may break framework functionality
- Should be documented in README or USAGE files

**Syntax**:
```markdown
<!--
[FIXED] - Framework Core Rule
This section defines...
LLM: Do NOT modify without explicit user confirmation.
-->
```

### Secondary Annotations (for Worker-specific Constitutions)

| Annotation | Purpose | Usage |
|------------|---------|-------|
| `[INHERIT: source]` | Reference parent Constitution | `[INHERIT: base.md#core-principles]` |
| `[EXTEND: topic]` | Add to inherited principles | Worker-specific additions |
| `[OVERRIDE: topic]` | Exception to parent principle | Requires rationale |

### Annotation Syntax

```markdown
## Core Principles

### I. [INFER: primary-language]
<!--
Analysis targets: package.json, tsconfig.json, go.mod, requirements.txt
Output: Primary language, framework, version constraints
-->

{{inferred-principle}}

**Rationale**: {{inferred-rationale}}

### II. [DECIDE: error-handling-philosophy]
<!--
Question: What is this project's error handling philosophy?
Options:
- Fail-fast with exceptions
- Graceful degradation with logging
- Other approach
-->

{{user-decided-principle}}

### III. [ADAPT: has-database]
<!--
Condition: ORM or database driver detected
-->
IF detected:
- Database access MUST use Repository pattern
- Transactions MUST be managed at service layer
END
```

### Validation Checklist

Templates include a self-validation section for LLM to verify completion:

```markdown
<!-- VALIDATION CHECKLIST -->
Before finalizing:
- [ ] All [FIXED] sections preserved without modification
- [ ] All [INFER] sections filled from codebase analysis
- [ ] All [DECIDE] sections confirmed with user
- [ ] All [ADAPT] conditions evaluated
- [ ] No conflicts with base.md principles
- [ ] All principles have Rationale
```

## Rationale

1. **Four-Level Clarity**: Unlike single-marker approaches, our system explicitly differentiates:
   - What must remain unchanged (`FIXED`)
   - What LLM can determine autonomously (`INFER`)
   - What requires human judgment (`DECIDE`)
   - What depends on project characteristics (`ADAPT`)

2. **Framework Core Protection**: `[FIXED]` ensures that framework-critical rules cannot be accidentally modified by LLM during initialization, while still allowing intentional user modifications with explicit confirmation.

3. **Constitution-Specific Design**: The annotation system is designed for declarative Constitution content, not imperative Instruction content (as per ADR-002).

4. **Guided Analysis**: `[INFER]` annotations include analysis hints (what files to check, what patterns to look for), making LLM behavior more predictable.

5. **Conditional Inclusion**: `[ADAPT]` prevents irrelevant sections (e.g., database principles in a frontend-only project) from cluttering the final Constitution.

6. **Inheritance Support**: Worker-specific Constitutions can cleanly reference and extend base Constitution without duplication.

## Consequences

### Positive

- Framework core rules protected from accidental modification
- Clear separation of LLM autonomy levels
- Predictable initialization behavior across projects
- Constitution templates remain clean after processing (annotations removed)
- Supports hierarchical Constitution structure (base + workers)
- Self-validation ensures completeness

### Negative

- Learning curve for template authors
- More complex than simple `{{placeholder}}` replacement
- Requires LLM to understand annotation semantics

### Trade-offs

- **Complexity vs Precision**: More annotation types increase complexity but provide precise control over initialization behavior.

## Alternatives Considered

### Single Marker Approach

Use only one annotation type (e.g., `[CLARIFY: ...]`) for all user interactions.

**Rejected because**:
- Doesn't distinguish what LLM should infer vs what user must decide
- All content defaults to "ask user," reducing automation benefit

### Simple Placeholder System

Use only `{{variable}}` placeholders with external configuration.

**Rejected because**:
- No guidance for LLM on how to fill placeholders
- No conditional logic for project-specific content
- Requires separate configuration file

### XML-Style Tags

Use `<infer>`, `<decide>`, `<adapt>` XML tags.

**Rejected because**:
- Verbose and harder to read in Markdown
- May conflict with HTML rendering
- Square brackets are more Markdown-native

### YAML FrontMatter Configuration

Put all placeholder logic in FrontMatter.

**Rejected because**:
- Separates annotation from content (harder to maintain)
- FrontMatter would become very complex
- Loses inline context for each annotation
