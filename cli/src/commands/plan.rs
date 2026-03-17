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
    match args.action {
        Some(Action::Dir) => eprintln!("plan dir: not yet implemented"),
        Some(Action::List { status }) => {
            let filter = status.as_deref().unwrap_or("all");
            eprintln!("plan list --status {filter}: not yet implemented");
        }
        Some(Action::Resolve { identifier }) => {
            eprintln!("plan resolve {identifier}: not yet implemented")
        }
        None => eprintln!("plan: run 'blueprint plan --help' for usage"),
    }
}
