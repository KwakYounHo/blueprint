use std::fs;
use std::path::Path;

use crate::common::paths;
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
        #[arg(long)]
        force: bool,
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
        Some(Action::Setup) => do_setup(),
        Some(Action::Sync { dry_run, force }) => do_sync(dry_run, force),
        Some(Action::Manage) => do_manage(),
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

// --- Setup, Sync, Manage ---

fn do_setup() {
    let reg = load_registry();

    let Some(project) = registry::detect_current_project(&reg) else {
        eprintln!("No project found for current directory.");
        eprintln!("Run 'blueprint project init <alias>' to register.");
        std::process::exit(1);
    };

    let alias = &project.alias;
    let data_dir = registry::project_data_dir(alias);

    // Ensure project data directory structure
    let subdirs = ["constitutions", "forms", "front-matters", "gates", "templates", "plans"];

    println!("Setting up project: {alias}");
    println!("  Data: {}", data_dir.display());
    println!();

    for subdir in &subdirs {
        let path = data_dir.join(subdir);
        if path.exists() {
            println!("  {subdir}/ — exists");
        } else {
            fs::create_dir_all(&path).unwrap_or_else(|e| {
                eprintln!("Failed to create {}: {e}", path.display());
                std::process::exit(1);
            });
            println!("  {subdir}/ — created");
        }
    }

    println!();
    println!("Project structure ready.");
    println!("Run 'blueprint project sync' to populate from base content.");
    println!("Run 'blueprint adapt <platform> install' to provision for your Code Assistant.");
}

fn do_sync(dry_run: bool, force: bool) {
    let reg = load_registry();

    let Some(project) = registry::detect_current_project(&reg) else {
        eprintln!("No project found for current directory.");
        eprintln!("Run 'blueprint project init <alias>' to register.");
        std::process::exit(1);
    };

    let base = paths::base_dir();
    let target = registry::project_data_dir(&project.alias);

    if !base.exists() {
        eprintln!("Base directory not found: {}", base.display());
        eprintln!("Run the installer to set up Blueprint base files.");
        std::process::exit(1);
    }

    println!("Syncing from: {}", base.display());
    println!("          to: {}", target.display());
    if dry_run {
        println!("(dry-run mode — no changes will be made)");
    }
    println!();

    let sync_dirs = ["constitutions", "forms", "front-matters", "gates", "templates"];

    for dir in &sync_dirs {
        let base_path = base.join(dir);
        let target_path = target.join(dir);

        if !base_path.is_dir() {
            continue;
        }

        println!("{dir}/");
        sync_directory(&base_path, &target_path, dry_run, force, dir);
    }

    println!();
    if dry_run {
        println!("Dry run complete. Use without --dry-run to apply changes.");
    } else {
        println!("Sync complete.");
    }
    println!();
    println!("Tip: To protect customized files from future syncs, update their 'version'");
    println!("     or 'updated' field to a value higher than the base file.");
}

fn sync_directory(base: &Path, target: &Path, dry_run: bool, force: bool, rel_path: &str) {
    let Ok(entries) = fs::read_dir(base) else {
        return;
    };

    if !dry_run {
        fs::create_dir_all(target).ok();
    }

    let mut entries: Vec<_> = entries.flatten().collect();
    entries.sort_by_key(|e| e.file_name());

    for entry in entries {
        let path = entry.path();
        let name = entry.file_name();
        let name_str = name.to_string_lossy();
        let display = format!("{rel_path}/{name_str}");

        if path.is_dir() {
            sync_directory(&path, &target.join(&name), dry_run, force, &display);
            continue;
        }

        let target_file = target.join(&name);
        let status = compare_files(&path, &target_file);

        match status {
            SyncStatus::New => {
                if dry_run {
                    println!("  [NEW]        {display}");
                } else {
                    fs::create_dir_all(target).ok();
                    fs::copy(&path, &target_file).ok();
                    println!("  [NEW]        {display} (copied)");
                }
            }
            SyncStatus::Update { base_ver, project_ver } => {
                if force {
                    if dry_run {
                        println!("  [UPDATE]     {display} ({project_ver} → {base_ver})");
                    } else {
                        fs::copy(&path, &target_file).ok();
                        println!("  [UPDATE]     {display} ({project_ver} → {base_ver}) (updated)");
                    }
                } else {
                    println!("  [UPDATE]     {display} ({project_ver} → {base_ver} available, use --force)");
                }
            }
            SyncStatus::Patch { base_date, project_date } => {
                if force {
                    if dry_run {
                        println!("  [PATCH]      {display} ({project_date} → {base_date})");
                    } else {
                        fs::copy(&path, &target_file).ok();
                        println!("  [PATCH]      {display} ({project_date} → {base_date}) (patched)");
                    }
                } else {
                    println!("  [PATCH]      {display} ({project_date} → {base_date} available, use --force)");
                }
            }
            SyncStatus::Customized => {
                println!("  [CUSTOMIZED] {display} (skipped — project version is newer)");
            }
            SyncStatus::Differs => {
                println!("  [DIFFERS]    {display} (same version/date but content differs)");
                if force && !dry_run {
                    fs::copy(&path, &target_file).ok();
                    println!("               → overwritten with base version");
                } else if !force {
                    println!("               → review manually or use --force to overwrite");
                }
            }
            SyncStatus::Ok => {} // silent
        }
    }
}

use crate::common::frontmatter;

enum SyncStatus {
    New,
    Update { base_ver: String, project_ver: String },
    Patch { base_date: String, project_date: String },
    Customized,
    Differs,
    Ok,
}

fn compare_files(base: &Path, project: &Path) -> SyncStatus {
    if !project.exists() {
        return SyncStatus::New;
    }

    let base_ver = get_file_field(base, "version").unwrap_or_else(|| "0.0.0".to_string());
    let project_ver = get_file_field(project, "version").unwrap_or_else(|| "0.0.0".to_string());

    if version_gt(&base_ver, &project_ver) {
        return SyncStatus::Update { base_ver, project_ver };
    }
    if version_gt(&project_ver, &base_ver) {
        return SyncStatus::Customized;
    }

    let base_date = get_file_field(base, "updated").unwrap_or_else(|| "1970-01-01".to_string());
    let project_date = get_file_field(project, "updated").unwrap_or_else(|| "1970-01-01".to_string());

    if base_date > project_date {
        return SyncStatus::Patch { base_date, project_date };
    }
    if project_date > base_date {
        return SyncStatus::Customized;
    }

    // Same version and date — check content hash
    let base_content = fs::read(base).unwrap_or_default();
    let project_content = fs::read(project).unwrap_or_default();

    if base_content != project_content {
        SyncStatus::Differs
    } else {
        SyncStatus::Ok
    }
}

fn get_file_field(path: &Path, field: &str) -> Option<String> {
    frontmatter::get_field(path, field).ok()?
}

/// Simple semver comparison: returns true if a > b.
fn version_gt(a: &str, b: &str) -> bool {
    if a == b {
        return false;
    }

    let parse = |v: &str| -> Vec<u32> {
        v.split('.').filter_map(|s| s.parse().ok()).collect()
    };

    let va = parse(a);
    let vb = parse(b);

    for i in 0..va.len().max(vb.len()) {
        let a_part = va.get(i).copied().unwrap_or(0);
        let b_part = vb.get(i).copied().unwrap_or(0);
        if a_part != b_part {
            return a_part > b_part;
        }
    }

    false
}

fn do_manage() {
    let reg = load_registry();
    let projects_dir = paths::projects_dir();

    if !projects_dir.exists() {
        println!("No projects directory found.");
        return;
    }

    println!("Scanning projects...");
    println!();

    let required_dirs = ["constitutions", "forms", "front-matters", "gates", "templates"];
    let mut unregistered_valid = Vec::new();
    let mut unregistered_invalid = Vec::new();

    let Ok(entries) = fs::read_dir(&projects_dir) else {
        return;
    };

    for entry in entries.flatten() {
        let path = entry.path();
        if !path.is_dir() {
            continue;
        }

        let name = entry.file_name().to_string_lossy().to_string();

        // Skip hidden directories and registry file
        if name.starts_with('.') {
            continue;
        }

        // Skip if already registered
        if reg.find_by_alias(&name).is_some() {
            continue;
        }

        // Check structure validity
        let missing: Vec<&str> = required_dirs
            .iter()
            .filter(|d| !path.join(d).is_dir())
            .copied()
            .collect();

        if missing.is_empty() {
            unregistered_valid.push(name);
        } else {
            unregistered_invalid.push((name, missing));
        }
    }

    if !unregistered_valid.is_empty() || !unregistered_invalid.is_empty() {
        let total = unregistered_valid.len() + unregistered_invalid.len();
        println!("Unregistered Projects ({total}):");
        println!();

        for name in &unregistered_valid {
            println!("  {name}/");
            println!("    Status: Valid structure");
            println!("    Action: Run 'blueprint project init {name}'");
            println!();
        }

        for (name, missing) in &unregistered_invalid {
            let missing_str = missing.join(", ");
            println!("  {name}/");
            println!("    Status: Invalid (missing: {missing_str})");
            println!("    Action: Consider cleanup or manual repair");
            println!();
        }
    }

    let total = unregistered_valid.len() + unregistered_invalid.len();
    println!("Summary: {total} unregistered");

    if total == 0 {
        println!();
        println!("All projects are properly registered.");
    }
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
