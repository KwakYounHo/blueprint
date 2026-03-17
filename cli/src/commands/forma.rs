/// Document templates
#[derive(clap::Args)]
pub struct Args {
    #[command(subcommand)]
    pub action: Option<Action>,
}

#[derive(clap::Subcommand)]
pub enum Action {
    /// List available templates
    List,
    /// Show template content
    Show { template: String },
    /// Copy template to target directory
    Copy { template: String, target: String },
}

pub fn run(args: Args) {
    match args.action {
        Some(Action::List) => eprintln!("forma list: not yet implemented"),
        Some(Action::Show { template }) => eprintln!("forma show {template}: not yet implemented"),
        Some(Action::Copy { template, target }) => {
            eprintln!("forma copy {template} {target}: not yet implemented")
        }
        None => eprintln!("forma: run 'blueprint forma --help' for usage"),
    }
}
