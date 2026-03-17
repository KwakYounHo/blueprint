use std::fs;
use std::path::Path;

use crate::common::registry::{self, Project, Registry};

/// Project alias management
#[derive(clap::Args)]
pub struct Args {
    #[command(subcommand)]
    pub action: Option<Action>,
}

#[derive(clap::Subcommand)]
pub enum Action {
    /// Initialize a new project
    Init {
        alias: String,
        #[arg(long)]
        path: Option<String>,
        #[arg(long)]
        notes: Option<String>,
        /// Project type: repo or bare
        #[arg(long, default_value = "repo")]
        r#type: String,
    },
    /// List registered projects
    List,
    /// Show project details
    Show { alias: String },
    /// Show current project context
    Current,
    /// Remove a project
    Remove { alias: String },
    /// Link a path to a project
    Link { alias: String, path: String },
    /// Unlink a path from a project
    Unlink { alias: String, path: String },
    /// Set up project configuration
    Setup,
    /// Sync base content to project
    Sync {
        #[arg(long)]
        dry_run: bool,
    },
    /// Manage unregistered projects
    Manage,
}

pub fn run(args: Args) {
    match args.action {
        Some(Action::Init { alias, path, notes, r#type }) => {
            do_init(&alias, path.as_deref(), notes.as_deref(), &r#type);
        }
        Some(Action::List) => do_list(),
        Some(Action::Show { alias }) => do_show(&alias),
        Some(Action::Current) => do_current(),
        Some(Action::Remove { alias }) => do_remove(&alias),
        Some(Action::Link { alias, path }) => do_link(&alias, &path),
        Some(Action::Unlink { alias, path }) => do_unlink(&alias, &path),
        Some(Action::Setup) => {
            eprintln!("project setup: not yet implemented (JUN-35)");
        }
        Some(Action::Sync { .. }) => {
            eprintln!("project sync: not yet implemented (JUN-35)");
        }
        Some(Action::Manage) => {
            eprintln!("project manage: not yet implemented (JUN-35)");
        }
        None => {
            eprintln!("Usage: blueprint project <init|list|show|current|remove|link|unlink|setup|sync|manage>");
            std::process::exit(1);
        }
    }
}

fn do_init(alias: &str, path: Option<&str>, notes: Option<&str>, project_type: &str) {
    let mut reg = load_registry();

    // Check alias uniqueness
    if reg.find_by_alias(alias).is_some() {
        eprintln!("Project '{alias}' already exists.");
        eprintln!("Use 'blueprint project show {alias}' to view details.");
        std::process::exit(1);
    }

    // Resolve path
    let current_path = match path {
        Some(p) => resolve_absolute_path(p),
        None => std::env::current_dir()
            .expect("Failed to get current directory")
            .to_string_lossy()
            .to_string(),
    };

    // Check path uniqueness
    if let Some(existing) = reg.find_by_path(&current_path) {
        eprintln!("Path already registered as '{}'.", existing.alias);
        eprintln!("Use 'blueprint project show {}' to view details.", existing.alias);
        std::process::exit(1);
    }

    // Create project data directory
    let data_dir = registry::project_data_dir(alias);
    fs::create_dir_all(&data_dir).unwrap_or_else(|e| {
        eprintln!("Failed to create project directory: {e}");
        std::process::exit(1);
    });

    // Add to registry
    reg.add(Project {
        alias: alias.to_string(),
        r#type: project_type.to_string(),
        paths: vec![current_path.clone()],
        notes: notes.unwrap_or("").to_string(),
    });

    save_registry(&reg);

    println!();
    println!("Project initialized: {alias}");
    println!("  Type: {project_type}");
    println!("  Path: {current_path}");
    println!("  Data: {}", data_dir.display());
    if let Some(n) = notes {
        if !n.is_empty() {
            println!("  Notes: {n}");
        }
    }
}

fn do_list() {
    let reg = load_registry();

    if reg.projects.is_empty() {
        println!("No projects registered.");
        println!();
        println!("Initialize a project:");
        println!("  blueprint project init <alias>");
        return;
    }

    println!("{:<15} {:<6} {:<6} {}", "ALIAS", "TYPE", "PATHS", "NOTES");
    println!("{}", "-".repeat(50));

    for project in &reg.projects {
        println!(
            "{:<15} {:<6} {:<6} {}",
            project.alias,
            project.r#type,
            project.paths.len(),
            if project.notes.is_empty() { "-" } else { &project.notes }
        );
    }
}

fn do_show(alias: &str) {
    let reg = load_registry();

    let Some(project) = reg.find_by_alias(alias) else {
        eprintln!("Project '{alias}' not found.");
        eprintln!();
        suggest_projects(&reg);
        std::process::exit(1);
    };

    let data_dir = registry::project_data_dir(alias);
    let plans_dir = registry::project_plans_dir(alias);

    println!("Project: {}", project.alias);
    println!("  Type: {}", project.r#type);
    println!("  Notes: {}", if project.notes.is_empty() { "-" } else { &project.notes });
    println!("  Data: {}", data_dir.display());
    println!("  Plans: {}", plans_dir.display());
    println!("  Paths:");

    for path in &project.paths {
        let exists = Path::new(path).exists();
        let marker = if exists { "✓" } else { "✗" };
        println!("    {marker} {path}");
    }
}

fn do_current() {
    let reg = load_registry();

    match registry::detect_current_project(&reg) {
        Some(project) => {
            println!("{}", project.alias);
        }
        None => {
            eprintln!("No project found for current directory.");
            eprintln!();
            let cwd = std::env::current_dir()
                .map(|p| p.to_string_lossy().to_string())
                .unwrap_or_else(|_| "(unknown)".to_string());
            eprintln!("Current directory: {cwd}");
            eprintln!();
            eprintln!("Register this project:");
            eprintln!("  blueprint project init <alias>");
            std::process::exit(1);
        }
    }
}

fn do_remove(alias: &str) {
    let mut reg = load_registry();

    if !reg.remove(alias) {
        eprintln!("Project '{alias}' not found.");
        suggest_projects(&reg);
        std::process::exit(1);
    }

    save_registry(&reg);

    // Note: We don't delete the data directory — user can do that manually
    let data_dir = registry::project_data_dir(alias);
    println!("Project '{alias}' removed from registry.");
    if data_dir.exists() {
        println!("  Data directory retained: {}", data_dir.display());
        println!("  Remove manually if no longer needed.");
    }
}

fn do_link(alias: &str, path: &str) {
    let mut reg = load_registry();

    let absolute_path = resolve_absolute_path(path);

    let Some(project) = reg.find_by_alias_mut(alias) else {
        eprintln!("Project '{alias}' not found.");
        suggest_projects(&reg);
        std::process::exit(1);
    };

    // Check if already linked
    if project.paths.iter().any(|p| {
        fs::canonicalize(p).ok() == fs::canonicalize(&absolute_path).ok()
    }) {
        eprintln!("Path already linked to '{alias}'.");
        std::process::exit(1);
    }

    project.paths.push(absolute_path.clone());
    save_registry(&reg);

    println!("Linked '{absolute_path}' to project '{alias}'.");
}

fn do_unlink(alias: &str, path: &str) {
    let mut reg = load_registry();

    let absolute_path = resolve_absolute_path(path);

    let Some(project) = reg.find_by_alias_mut(alias) else {
        eprintln!("Project '{alias}' not found.");
        suggest_projects(&reg);
        std::process::exit(1);
    };

    let before = project.paths.len();
    project.paths.retain(|p| {
        fs::canonicalize(p).ok() != fs::canonicalize(&absolute_path).ok()
    });

    if project.paths.len() == before {
        eprintln!("Path '{absolute_path}' not linked to '{alias}'.");
        std::process::exit(1);
    }

    save_registry(&reg);
    println!("Unlinked '{absolute_path}' from project '{alias}'.");
}

// --- Helpers ---

fn load_registry() -> Registry {
    Registry::load().unwrap_or_else(|e| {
        eprintln!("{e}");
        std::process::exit(1);
    })
}

fn save_registry(reg: &Registry) {
    reg.save().unwrap_or_else(|e| {
        eprintln!("{e}");
        std::process::exit(1);
    });
}

fn suggest_projects(reg: &Registry) {
    if reg.projects.is_empty() {
        return;
    }
    eprintln!("Available projects:");
    for p in &reg.projects {
        eprintln!("  - {}", p.alias);
    }
}

fn resolve_absolute_path(path: &str) -> String {
    fs::canonicalize(path)
        .unwrap_or_else(|_| {
            // If path doesn't exist yet, resolve relative to cwd
            let cwd = std::env::current_dir().expect("Failed to get current directory");
            cwd.join(path)
        })
        .to_string_lossy()
        .to_string()
}
