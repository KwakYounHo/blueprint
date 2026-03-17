use std::path::PathBuf;

use crate::common::adapter::{self, PlatformDef};

/// Adapter installation for Code Assistants
#[derive(clap::Args)]
pub struct Args {
    /// Target platform (e.g., "claude", "codex")
    pub platform: String,
    #[command(subcommand)]
    pub action: Action,
}

#[derive(clap::Subcommand)]
pub enum Action {
    /// Install Blueprint for the target platform
    Install,
    /// Uninstall Blueprint from the target platform
    Uninstall,
    /// Show current installation status
    Status,
}

pub fn run(args: Args) {
    let platform = resolve_platform(&args.platform);

    match args.action {
        Action::Install => adapter::install(&platform),
        Action::Uninstall => adapter::uninstall(&platform),
        Action::Status => adapter::status(&platform),
    }
}

fn resolve_platform(name: &str) -> PlatformDef {
    match name {
        "claude" => claude_platform(),
        // "codex" => codex_platform(),  // JUN-37
        _ => {
            eprintln!("Unknown platform: {name}");
            eprintln!();
            eprintln!("Available platforms:");
            eprintln!("  claude    Claude Code");
            // eprintln!("  codex     Codex");
            std::process::exit(1);
        }
    }
}

// =============================================================================
// Claude Code Platform Definition
// =============================================================================

fn claude_platform() -> PlatformDef {
    let home = std::env::var("HOME").expect("HOME not set");
    let claude_dir = PathBuf::from(&home).join(".claude");

    PlatformDef {
        name: "Claude Code",
        agent_target_dir: claude_dir.join("agents"),
        skill_target_dir: claude_dir.join("skills"),
        hooks_target_dir: claude_dir.join("hooks"),
        bootstrap_template: CLAUDE_BOOTSTRAP,
        capability_map: &CLAUDE_CAPABILITY_MAP,
    }
}

/// Claude Code Bootstrap template — injected at the top of every Instruction.
const CLAUDE_BOOTSTRAP: &str = "\
## Platform: Claude Code

### Blueprint Access
Load `/blueprint` skill. Execute: `~/.claude/skills/blueprint/blueprint.sh <submodule> [args]`

### Primitive Mapping
| Vocabulary | Implementation |
|------------|---------------|
| **delegate to [agent]** | Task tool with `subagent_type: {agent}`. Background: `run_in_background: true`. Permission: `mode: bypassPermissions` for read-only. |
| **ask user** | AskUserQuestion tool |
| **enter plan mode** | EnterPlanMode tool |
| **do not poll** | Do NOT use TaskOutput to check delegated results |

---
";

/// Capability name → Claude Code tool name mapping.
const CLAUDE_CAPABILITY_MAP: [(&str, &str); 4] = [
    ("File reading", "Read"),
    ("Content search", "Grep"),
    ("File search", "Glob"),
    ("Shell execution", "Bash"),
];
