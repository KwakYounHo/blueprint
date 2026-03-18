use std::fs;

use crate::common::frontmatter;
use crate::common::paths;

/// Agent registry
#[derive(clap::Args)]
pub struct Args {
    /// Agent name
    pub agent: Option<String>,
    /// List available agents
    #[arg(long, short)]
    pub list: bool,
}

pub fn run(args: Args) {
    let agents_dir = paths::base_dir().join("instructions").join("agents");

    if args.list {
        list_agents(&agents_dir);
    } else if let Some(agent) = &args.agent {
        show_agent(&agents_dir, agent);
    } else {
        eprintln!("Usage: blueprint polis [--list | <agent>]");
        std::process::exit(1);
    }
}

fn list_agents(agents_dir: &std::path::Path) {
    let Ok(entries) = fs::read_dir(agents_dir) else {
        eprintln!("Agents directory not found: {}", agents_dir.display());
        std::process::exit(1);
    };

    // Collect agent names (*.md excluding *.spec.md and README.md)
    let mut agents: Vec<(String, String)> = entries
        .filter_map(|entry| {
            let path = entry.ok()?.path();
            let name = path.file_name()?.to_str()?;

            if !name.ends_with(".md") || name.ends_with(".spec.md") || name == "README.md" {
                return None;
            }

            let agent_name = name.strip_suffix(".md")?.to_string();

            // Read description from spec file
            let spec_path = path.with_extension("spec.md");
            let desc = get_description_from_spec(&spec_path).unwrap_or_default();

            Some((agent_name, desc))
        })
        .collect();

    agents.sort_by(|a, b| a.0.cmp(&b.0));

    println!("Available Agents:");
    println!();

    if agents.is_empty() {
        println!("  (no agents found)");
    } else {
        for (name, desc) in &agents {
            println!("  {name:<20} {desc}");
        }
    }
}

fn show_agent(agents_dir: &std::path::Path, agent: &str) {
    let agent_file = agents_dir.join(format!("{agent}.md"));

    if !agent_file.exists() {
        eprintln!("Agent not found: {agent}");
        eprintln!();
        list_agents(agents_dir);
        std::process::exit(1);
    }

    match fs::read_to_string(&agent_file) {
        Ok(content) => print!("{content}"),
        Err(e) => {
            eprintln!("Failed to read {}: {e}", agent_file.display());
            std::process::exit(1);
        }
    }
}

/// Extract description from a .spec.md file's ## Description section.
fn get_description_from_spec(spec_path: &std::path::Path) -> Option<String> {
    let doc = frontmatter::parse_file(spec_path).ok()?;
    // Find the line after "## Description"
    let mut found_header = false;
    for line in doc.body.lines() {
        if line.trim() == "## Description" {
            found_header = true;
            continue;
        }
        if found_header {
            let trimmed = line.trim();
            if !trimmed.is_empty() {
                return Some(trimmed.to_string());
            }
        }
    }
    None
}
