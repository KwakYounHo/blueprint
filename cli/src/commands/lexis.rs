/// Constitution viewer
#[derive(clap::Args)]
pub struct Args {
    /// Agent name (or --base for project constitution)
    pub agent: Option<String>,
    /// Show base (project) constitution
    #[arg(long)]
    pub base: bool,
}

pub fn run(args: Args) {
    if args.base {
        eprintln!("lexis --base: not yet implemented");
    } else if let Some(agent) = &args.agent {
        eprintln!("lexis {agent}: not yet implemented");
    } else {
        eprintln!("lexis: run 'blueprint lexis --help' for usage");
    }
}
