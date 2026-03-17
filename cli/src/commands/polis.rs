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
    if args.list {
        eprintln!("polis --list: not yet implemented");
    } else if let Some(agent) = &args.agent {
        eprintln!("polis {agent}: not yet implemented");
    } else {
        eprintln!("polis: run 'blueprint polis --help' for usage");
    }
}
