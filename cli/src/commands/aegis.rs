/// Gate validation and aspects
#[derive(clap::Args)]
pub struct Args {
    /// Gate name
    pub gate: Option<String>,
    /// Aspect name
    pub aspect: Option<String>,
    /// List available gates
    #[arg(long, short)]
    pub list: bool,
}

pub fn run(args: Args) {
    eprintln!("aegis: not yet implemented");
    if args.list {
        eprintln!("  would list gates");
    } else if let Some(gate) = &args.gate {
        eprintln!("  gate: {gate}");
        if let Some(aspect) = &args.aspect {
            eprintln!("  aspect: {aspect}");
        }
    }
}
