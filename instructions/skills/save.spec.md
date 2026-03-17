# Specification: save

## Description

Save session state for Plan handoff (adaptive)

## Platform Topics

| Topic | Usage |
|-------|-------|
| `user-interaction` | Step 5.2: Implementation notes review, Step 7: ADR detection |

## Delegated Agents

None — save operates without agent delegation.

## Blueprint CLI Submodules

| Submodule | Commands Used |
|-----------|--------------|
| `plan` | `dir`, `resolve <id>` |
| `forma` | `copy current-quick`, `copy current-standard`, `copy current-compressed`, `show`, `copy adr` |
| `frontis` | `show` |
| `hermes` | `after-save` |

## Agent Requirements

N/A

## Special Requirements

- Plan Recognition priority: CURRENT.md > Git Branch > Argument
- Auto-detects project scale (Quick/Standard/Compressed) from HISTORY.md
