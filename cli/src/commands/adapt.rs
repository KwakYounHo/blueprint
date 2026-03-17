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
    let action = match &args.action {
        Action::Install => "install",
        Action::Uninstall => "uninstall",
        Action::Status => "status",
    };
    eprintln!("adapt {} {action}: not yet implemented", args.platform);
}
