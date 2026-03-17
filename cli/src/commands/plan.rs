use std::fs;
use std::path::{Path, PathBuf};

use crate::common::frontmatter;
use crate::common::registry::{self, Registry};

/// Plan directory and listing
#[derive(clap::Args)]
pub struct Args {
    #[command(subcommand)]
    pub action: Option<Action>,
}

#[derive(clap::Subcommand)]
pub enum Action {
    /// Show plans directory path
    Dir,
    /// List plans (optionally filtered by status)
    List {
        #[arg(long)]
        status: Option<String>,
    },
    /// Resolve plan identifier to path
    Resolve { identifier: String },
}

pub fn run(args: Args) {
    let plans_dir = resolve_plans_dir();

    match args.action {
        Some(Action::Dir) => println!("{}", plans_dir.display()),
        Some(Action::List { status }) => list_plans(&plans_dir, status.as_deref()),
        Some(Action::Resolve { identifier }) => resolve_plan(&plans_dir, &identifier),
        None => {
            eprintln!("Usage: blueprint plan <dir|list|resolve>");
            std::process::exit(1);
        }
    }
}

/// Resolve the plans directory for the current project.
///
/// Priority: $BLUEPRINT_PLANS_DIR > registry-based detection
fn resolve_plans_dir() -> PathBuf {
    // Environment override
    if let Ok(dir) = std::env::var("BLUEPRINT_PLANS_DIR") {
        return PathBuf::from(dir);
    }

    // Detect current project from registry
    let Ok(reg) = Registry::load() else {
        eprintln!("Failed to load project registry.");
        eprintln!("Initialize a project first: blueprint project init <alias>");
        std::process::exit(1);
    };

    match registry::detect_current_project(&reg) {
        Some(project) => registry::project_plans_dir(&project.alias),
        None => {
            eprintln!("No project found for current directory.");
            eprintln!();
            eprintln!("Options:");
            eprintln!("  1. Initialize: blueprint project init <alias>");
            eprintln!("  2. Override: BLUEPRINT_PLANS_DIR=/path/to/plans blueprint plan dir");
            std::process::exit(1);
        }
    }
}

fn list_plans(plans_dir: &Path, status_filter: Option<&str>) {
    let Ok(entries) = fs::read_dir(plans_dir) else {
        eprintln!("Plans directory not found: {}", plans_dir.display());
        std::process::exit(1);
    };

    let mut plans: Vec<String> = entries
        .filter_map(|entry| {
            let path = entry.ok()?.path();
            if !path.is_dir() {
                return None;
            }

            let name = path.file_name()?.to_str()?.to_string();

            // Apply status filter if provided
            if let Some(filter) = status_filter {
                let plan_file = path.join("PLAN.md");
                if let Ok(Some(status)) = frontmatter::get_field(&plan_file, "status") {
                    if status != filter {
                        return None;
                    }
                } else {
                    return None; // No PLAN.md or no status field → skip when filtering
                }
            }

            Some(name)
        })
        .collect();

    plans.sort();

    if plans.is_empty() {
        if let Some(filter) = status_filter {
            eprintln!("No plans found with status: {filter}");
        } else {
            eprintln!("No plans found in {}", plans_dir.display());
        }
    } else {
        for name in &plans {
            println!("{name}");
        }
    }
}

fn resolve_plan(plans_dir: &Path, identifier: &str) {
    let Ok(entries) = fs::read_dir(plans_dir) else {
        eprintln!("Plans directory not found: {}", plans_dir.display());
        std::process::exit(1);
    };

    let is_number = identifier.chars().all(|c| c.is_ascii_digit());
    let has_number_prefix = identifier
        .split_once('-')
        .map(|(prefix, _)| prefix.chars().all(|c| c.is_ascii_digit()))
        .unwrap_or(false);

    let mut matches: Vec<PathBuf> = entries
        .filter_map(|entry| {
            let path = entry.ok()?.path();
            if !path.is_dir() {
                return None;
            }

            let name = path.file_name()?.to_str()?;

            let matched = if is_number {
                // "001" → matches "001-*"
                name.starts_with(&format!("{identifier}-"))
            } else if has_number_prefix {
                // "001-auth" → matches "001-auth*"
                name.starts_with(identifier)
            } else {
                // "auth" → matches "*-*auth*"
                name.contains('-') && name.contains(identifier)
            };

            matched.then(|| path.to_path_buf())
        })
        .collect();

    matches.sort();

    match matches.len() {
        0 => {
            eprintln!("No plan found matching: {identifier}");
            eprintln!();
            eprintln!("Available plans:");
            list_plans(plans_dir, None);
            std::process::exit(1);
        }
        1 => println!("{}", matches[0].display()),
        _ => {
            eprintln!("Multiple plans match '{identifier}':");
            for m in &matches {
                if let Some(name) = m.file_name().and_then(|n| n.to_str()) {
                    eprintln!("  - {name}");
                }
            }
            eprintln!();
            eprintln!("Please be more specific.");
            std::process::exit(1);
        }
    }
}
