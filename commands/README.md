# Commands

> Claude Code slash commands for workflow operations.

---

## Purpose

Commands are **slash commands** that trigger workflow operations:

1. `/init` - Initialize framework in current project
2. `/specify` - Start specification for a new feature
3. `/implement` - Begin implementation phase
4. `/review` - Run gate validation

---

## Background

### What are Slash Commands?

Claude Code supports custom slash commands defined in `.claude/commands/`:

```
.claude/
└── commands/
    └── my-command.md
```

When user types `/my-command`, Claude executes the prompt defined in `my-command.md`.

### Why Commands?

Commands provide:
- **Consistent entry points** to workflow
- **Pre-defined prompts** that follow framework patterns
- **Reduced typing** for common operations
- **Discoverability** via `/` menu

---

## Directory Structure

```
commands/
├── README.md                    # This file
├── init.md                      # /init command
├── specify.md                   # /specify command
├── implement.md                 # /implement command
└── review.md                    # /review command
```

---

## Command Definitions

### /init

**Purpose**: Initialize framework structure in current project.

**Behavior**:
1. Create directory structure
2. Copy templates (optional)
3. Report what was created

**Usage**:
```
/init
/init --with-templates
```

### /specify

**Purpose**: Start specification phase for a new feature.

**Behavior**:
1. Prompt for feature description
2. Create feature directory with ID
3. Invoke Specifier Worker
4. Generate spec.md and plan.md
5. Trigger Specification Gate

**Usage**:
```
/specify
/specify Add user authentication with OAuth
```

### /implement

**Purpose**: Begin implementation of specified feature.

**Behavior**:
1. Check Specification Gate status
2. Load plan.md and tasks
3. Invoke Implementer Workers per task
4. Track task completion
5. Trigger Implementation Gate when done

**Usage**:
```
/implement
/implement 001-user-auth
```

### /review

**Purpose**: Run gate validation on current work.

**Behavior**:
1. Determine current phase
2. Load appropriate Gate definition
3. Invoke Reviewer Workers per Aspect
4. Aggregate results
5. Report pass/fail status

**Usage**:
```
/review
/review spec
/review impl
```

---

## Command File Format

Commands are Markdown files with prompt content:

```markdown
# /command-name

Brief description shown in command menu.

---

Detailed prompt that Claude will follow when this command is invoked.

## Steps
1. First, do this
2. Then, do that
3. Finally, do this

## Context to Load
- blueprint/constitutions/base.md
- blueprint/workflows/phases.md

## Output Format
...
```

---

## Planned Command: /init

```markdown
# /init

Initialize the Agent Orchestration Framework in the current project.

---

## Task
Set up the framework directory structure and optionally copy templates.

## Steps
1. Check if blueprint/ already exists
   - If yes, ask for confirmation before proceeding
2. Create directory structure:
   - .claude/agents/
   - blueprint/schemas/
   - blueprint/constitutions/workers/
   - blueprint/gates/specification/aspects/
   - blueprint/gates/implementation/aspects/
   - blueprint/gates/documentation/aspects/
   - blueprint/workflows/stages/
   - blueprint/features/
3. If --with-templates flag:
   - Copy Worker templates to .claude/agents/
   - Copy Constitution templates to blueprint/constitutions/
   - Copy Schema templates to blueprint/schemas/
4. Report created directories and files

## Output
List of created directories and next steps.
```

---

## Planned Command: /specify

```markdown
# /specify

Start the Specification Phase for a new feature.

---

## Task
Create specification documents for a new feature.

## Input
Feature description (provided after command or prompted)

## Steps
1. Generate feature ID: {next-number}-{slugified-description}
2. Create feature directory: blueprint/features/{feature-id}/
3. Create feature.md with metadata
4. Invoke Specifier Worker:
   - Load: blueprint/constitutions/base.md
   - Load: blueprint/constitutions/workers/specifier.md
   - Task: Analyze requirements, create spec.md and plan.md
5. Create task files based on plan
6. Trigger Specification Gate review

## Output
- Feature directory created
- spec.md with requirements
- plan.md with implementation strategy
- task-*.md files
- Gate review results
```

---

## Planned Command: /implement

```markdown
# /implement

Begin the Implementation Phase for a specified feature.

---

## Task
Implement code based on the feature's plan and tasks.

## Prerequisites
- Specification Gate must be passed
- plan.md must exist

## Steps
1. Load feature's plan.md
2. Check task dependencies
3. For each task (respecting dependencies):
   - Invoke Implementer Worker
   - Load: blueprint/constitutions/base.md
   - Load: blueprint/constitutions/workers/implementer.md
   - Load: task-*.md
4. Update task status as completed
5. When all tasks done, trigger Implementation Gate

## Output
- Implemented code files
- Updated task statuses
- Gate review results
```

---

## Planned Command: /review

```markdown
# /review

Run gate validation on current work.

---

## Task
Validate artifacts against gate criteria.

## Input
Gate type (auto-detected or specified: spec/impl)

## Steps
1. Determine current phase and gate
2. Load gate definition from blueprint/gates/
3. For each Aspect in gate:
   - Invoke Reviewer Worker
   - Load: blueprint/constitutions/workers/reviewer.md
   - Load: Aspect criteria
   - Check artifacts against criteria
4. Aggregate results
5. Report pass/fail with details

## Output
- Per-aspect results
- Overall gate status
- Feedback for failed criteria
```

---

## Installation

To use these commands in a project:

```bash
# Copy commands to project
cp -r commands/* /path/to/project/.claude/commands/

# Or include in initialization
./initializers/init.sh /path/to/project --with-commands
```

---

## Best Practices

### Keep Commands Focused

Each command should do one thing well:
- `/specify` only does specification
- `/implement` only does implementation
- Don't combine multiple phases

### Provide Feedback

Commands should report:
- What they're doing
- What they created/changed
- Next steps

### Handle Errors Gracefully

- Check prerequisites before proceeding
- Provide helpful error messages
- Suggest how to fix issues

---

## Related

- `.claude/commands/` in target project
- `../initializers/` for setup scripts
- `../templates/claude-agents/` for Worker definitions
