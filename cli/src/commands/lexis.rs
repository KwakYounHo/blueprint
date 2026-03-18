use std::fs;
use std::path::PathBuf;

use crate::common::registry;

/// Constitution viewer
#[derive(clap::Args)]
pub struct Args {
    /// Agent name to show constitution for
    pub agent: Option<String>,
    /// Show base (project) constitution
    #[arg(long, short)]
    pub base: bool,
    /// Show framework constitution
    #[arg(long, short)]
    pub framework: bool,
    /// List all agents
    #[arg(long, short)]
    pub list: bool,
}

pub fn run(args: Args) {
    let constitutions_dir = registry::resolve_content_dir().join("constitutions");

    if args.list {
        list_agents(&constitutions_dir);
    } else if args.base {
        show_file(&constitutions_dir.join("base.md"));
    } else if args.framework {
        show_file(&constitutions_dir.join("blueprint.md"));
    } else if let Some(agent) = &args.agent {
        show_agent(&constitutions_dir, agent);
    } else {
        eprintln!("Usage: blueprint lexis [--list | --base | --framework | <agent>]");
        std::process::exit(1);
    }
}

fn list_agents(constitutions_dir: &PathBuf) {
    let agents_dir = constitutions_dir.join("agents");

    let Ok(entries) = fs::read_dir(&agents_dir) else {
        eprintln!("Agents directory not found: {}", agents_dir.display());
        std::process::exit(1);
    };

    println!("Available agents:");
    println!();

    let mut found = false;
    let mut names: Vec<String> = entries
        .filter_map(|entry| {
            let entry = entry.ok()?;
            let path = entry.path();
            if path.extension()?.to_str()? == "md" {
                let name = path.file_stem()?.to_str()?.to_string();
                if name != "README" {
                    return Some(name);
                }
            }
            None
        })
        .collect();

    names.sort();

    for name in &names {
        println!("  - {name}");
        found = true;
    }

    if !found {
        println!("  (no agents found)");
    }
}

fn show_agent(constitutions_dir: &PathBuf, agent: &str) {
    let agent_file = constitutions_dir.join("agents").join(format!("{agent}.md"));

    if !agent_file.exists() {
        eprintln!("Agent constitution not found: {agent}");
        eprintln!();
        list_agents(constitutions_dir);
        std::process::exit(1);
    }

    show_file(&agent_file);
}

fn show_file(path: &PathBuf) {
    if !path.exists() {
        eprintln!("File not found: {}", path.display());
        std::process::exit(1);
    }

    match fs::read_to_string(path) {
        Ok(content) => print!("{content}"),
        Err(e) => {
            eprintln!("Failed to read {}: {e}", path.display());
            std::process::exit(1);
        }
    }
}
