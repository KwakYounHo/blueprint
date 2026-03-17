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
        Some(action) => {
            let name = match &action {
                Action::Init { alias, .. } => format!("init {alias}"),
                Action::List => "list".to_string(),
                Action::Show { alias } => format!("show {alias}"),
                Action::Current => "current".to_string(),
                Action::Remove { alias } => format!("remove {alias}"),
                Action::Link { alias, path } => format!("link {alias} {path}"),
                Action::Unlink { alias, path } => format!("unlink {alias} {path}"),
                Action::Setup => "setup".to_string(),
                Action::Sync { dry_run } => {
                    if *dry_run {
                        "sync --dry-run".to_string()
                    } else {
                        "sync".to_string()
                    }
                }
                Action::Manage => "manage".to_string(),
            };
            eprintln!("project {name}: not yet implemented");
        }
        None => eprintln!("project: run 'blueprint project --help' for usage"),
    }
}
