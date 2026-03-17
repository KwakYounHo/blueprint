pub mod aegis;
pub mod forma;
pub mod frontis;
pub mod hermes;
pub mod lexis;
pub mod plan;
pub mod polis;
pub mod project;

/// All available subcommands
#[derive(clap::Subcommand)]
pub enum Subcommand {
    /// Gate validation and aspects
    Aegis(aegis::Args),
    /// Document templates
    Forma(forma::Args),
    /// FrontMatter search and schemas
    Frontis(frontis::Args),
    /// Agent handoff forms
    Hermes(hermes::Args),
    /// Constitution viewer
    Lexis(lexis::Args),
    /// Plan directory and listing
    Plan(plan::Args),
    /// Agent registry
    Polis(polis::Args),
    /// Project alias management
    Project(project::Args),
}

/// Route subcommand to its handler
pub fn run(cmd: Subcommand) {
    match cmd {
        Subcommand::Aegis(args) => aegis::run(args),
        Subcommand::Forma(args) => forma::run(args),
        Subcommand::Frontis(args) => frontis::run(args),
        Subcommand::Hermes(args) => hermes::run(args),
        Subcommand::Lexis(args) => lexis::run(args),
        Subcommand::Plan(args) => plan::run(args),
        Subcommand::Polis(args) => polis::run(args),
        Subcommand::Project(args) => project::run(args),
    }
}
