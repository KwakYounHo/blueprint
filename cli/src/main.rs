mod commands;
mod common;

use clap::Parser;
use commands::Subcommand;

/// Blueprint - Platform-agnostic governance framework CLI
#[derive(Parser)]
#[command(name = "blueprint", version, about)]
struct Cli {
    #[command(subcommand)]
    command: Subcommand,
}

fn main() {
    let cli = Cli::parse();
    commands::run(cli.command);
}
