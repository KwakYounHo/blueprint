use std::fs;

use crate::common::frontmatter;
use crate::common::registry;

/// Gate validation and aspects
#[derive(clap::Args)]
pub struct Args {
    /// Gate name
    pub gate: Option<String>,
    /// Aspect name (requires gate)
    pub aspect: Option<String>,
    /// List available gates
    #[arg(long, short)]
    pub list: bool,
    /// List aspects for a gate
    #[arg(long, short)]
    pub aspects: bool,
}

pub fn run(args: Args) {
    let gates_dir = registry::resolve_content_dir().join("gates");

    if args.list {
        list_gates(&gates_dir);
    } else if let Some(gate) = &args.gate {
        if args.aspects {
            list_aspects(&gates_dir, gate);
        } else if let Some(aspect) = &args.aspect {
            show_aspect(&gates_dir, gate, aspect);
        } else {
            show_gate(&gates_dir, gate);
        }
    } else {
        eprintln!("Usage: blueprint aegis [--list | <gate> [--aspects | <aspect>]]");
        std::process::exit(1);
    }
}

fn list_gates(gates_dir: &std::path::Path) {
    let Ok(entries) = fs::read_dir(gates_dir) else {
        eprintln!("Gates directory not found: {}", gates_dir.display());
        std::process::exit(1);
    };

    let mut gates: Vec<(String, String)> = entries
        .filter_map(|entry| {
            let path = entry.ok()?.path();
            if !path.is_dir() {
                return None;
            }

            let name = path.file_name()?.to_str()?.to_string();
            let gate_file = path.join("gate.md");
            let desc = if gate_file.exists() {
                get_description(&gate_file).unwrap_or_default()
            } else {
                "(no gate.md)".to_string()
            };

            Some((name, desc))
        })
        .collect();

    gates.sort_by(|a, b| a.0.cmp(&b.0));

    println!("Available gates:");
    println!();

    if gates.is_empty() {
        println!("  (no gates found)");
    } else {
        for (name, desc) in &gates {
            println!("  {name:<20} {desc}");
        }
    }
}

fn list_aspects(gates_dir: &std::path::Path, gate: &str) {
    let aspects_dir = gates_dir.join(gate).join("aspects");

    let Ok(entries) = fs::read_dir(&aspects_dir) else {
        eprintln!("No aspects directory for gate: {gate}");
        return;
    };

    let mut aspects: Vec<(String, String)> = entries
        .filter_map(|entry| {
            let path = entry.ok()?.path();
            if path.extension()?.to_str()? != "md" {
                return None;
            }
            let name = path.file_stem()?.to_str()?.to_string();
            let desc = get_description(&path).unwrap_or_default();
            Some((name, desc))
        })
        .collect();

    aspects.sort_by(|a, b| a.0.cmp(&b.0));

    println!("Aspects for '{gate}' gate:");
    println!();

    if aspects.is_empty() {
        println!("  (no aspects found)");
    } else {
        for (name, desc) in &aspects {
            println!("  {name:<25} {desc}");
        }
    }
}

fn show_gate(gates_dir: &std::path::Path, gate: &str) {
    let gate_dir = gates_dir.join(gate);

    if !gate_dir.is_dir() {
        eprintln!("Gate not found: {gate}");
        eprintln!();
        list_gates(gates_dir);
        std::process::exit(1);
    }

    let gate_file = gate_dir.join("gate.md");
    if !gate_file.exists() {
        eprintln!("Gate definition not found: {}", gate_file.display());
        std::process::exit(1);
    }

    match fs::read_to_string(&gate_file) {
        Ok(content) => print!("{content}"),
        Err(e) => {
            eprintln!("Failed to read {}: {e}", gate_file.display());
            std::process::exit(1);
        }
    }
}

fn show_aspect(gates_dir: &std::path::Path, gate: &str, aspect: &str) {
    let aspect_file = gates_dir.join(gate).join("aspects").join(format!("{aspect}.md"));

    if !aspect_file.exists() {
        eprintln!("Aspect not found: {aspect}");
        eprintln!();
        list_aspects(gates_dir, gate);
        std::process::exit(1);
    }

    match fs::read_to_string(&aspect_file) {
        Ok(content) => print!("{content}"),
        Err(e) => {
            eprintln!("Failed to read {}: {e}", aspect_file.display());
            std::process::exit(1);
        }
    }
}

/// Get description from a file's FrontMatter (System Documents have FrontMatter).
fn get_description(path: &std::path::Path) -> Option<String> {
    frontmatter::get_field(path, "description").ok()?
}
