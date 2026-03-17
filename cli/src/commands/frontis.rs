/// FrontMatter search and schemas
#[derive(clap::Args)]
pub struct Args {
    #[command(subcommand)]
    pub action: Option<Action>,
}

#[derive(clap::Subcommand)]
pub enum Action {
    /// Search documents by FrontMatter field
    Search { field: String, value: String },
    /// Show FrontMatter of a file
    Show { file: String },
    /// View FrontMatter schema
    Schema { doc_type: String },
}

pub fn run(args: Args) {
    match args.action {
        Some(Action::Search { field, value }) => {
            eprintln!("frontis search {field} {value}: not yet implemented")
        }
        Some(Action::Show { file }) => eprintln!("frontis show {file}: not yet implemented"),
        Some(Action::Schema { doc_type }) => {
            eprintln!("frontis schema {doc_type}: not yet implemented")
        }
        None => eprintln!("frontis: run 'blueprint frontis --help' for usage"),
    }
}
