# Specification: code-reuse-reviewer

## Description

Reviews code changes for reuse opportunities — flags duplicated logic and underutilized existing utilities.

## Platform Topics

None — code-reuse-reviewer is a leaf agent, delegated TO by verify.

## Delegated Agents

None.

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `lexis` | `--base` (base constitution) |
| `hermes` | `response:verify:production` (output format) |

## Required Capabilities

| Capability | Purpose |
|------------|---------|
| File reading | Read source files for comparison |
| Content search | Search for existing utilities/helpers |
| File search | Find related modules and shared code |
| Shell execution | Run `blueprint` CLI commands |

## Special Requirements

- Must search codebase broadly before flagging duplication
- Each finding must include concrete existing alternative with file path
