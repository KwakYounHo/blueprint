/// Agent handoff forms
#[derive(clap::Args)]
pub struct Args {
    /// Form name (e.g., "request:review:session-state", "after-load:standard")
    pub form: Option<String>,
    /// List available forms
    #[arg(long, short)]
    pub list: bool,
}

pub fn run(args: Args) {
    if args.list {
        eprintln!("hermes --list: not yet implemented");
    } else if let Some(form) = &args.form {
        eprintln!("hermes {form}: not yet implemented");
    } else {
        eprintln!("hermes: run 'blueprint hermes --help' for usage");
    }
}
