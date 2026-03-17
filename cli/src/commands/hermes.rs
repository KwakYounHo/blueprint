use std::fs;

use crate::common::paths;

/// Agent handoff forms
#[derive(clap::Args)]
pub struct Args {
    /// Form name (e.g., "after-save", "request:review:session-state")
    pub form: Option<String>,
    /// List available forms
    #[arg(long, short)]
    pub list: bool,
}

pub fn run(args: Args) {
    let forms_file = paths::base_dir().join("forms").join("handoff.schema.md");

    if !forms_file.exists() {
        eprintln!("Handoff forms not found: {}", forms_file.display());
        std::process::exit(1);
    }

    let content = match fs::read_to_string(&forms_file) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("Failed to read {}: {e}", forms_file.display());
            std::process::exit(1);
        }
    };

    if args.list {
        list_forms(&content);
    } else if let Some(form) = &args.form {
        show_form(&content, form);
    } else {
        eprintln!("Usage: blueprint hermes [--list | <form>]");
        std::process::exit(1);
    }
}

/// List all OBJECTIVE[...] form names.
fn list_forms(content: &str) {
    println!("Available Handoff forms:");
    println!();

    let mut found = false;
    for line in content.lines() {
        // Find all OBJECTIVE[name] occurrences
        let mut search = line;
        while let Some(start) = search.find("OBJECTIVE[") {
            let after = &search[start + 10..];
            if let Some(end) = after.find(']') {
                let name = &after[..end];
                println!("  - {name}");
                found = true;
                search = &after[end + 1..];
            } else {
                break;
            }
        }
    }

    if !found {
        println!("  (no Handoff forms found)");
    }
}

/// Extract and print the content of a specific form.
///
/// Form content is between `---s` and `---e` markers
/// after the matching `OBJECTIVE[form-name]` line.
fn show_form(content: &str, form: &str) {
    let marker = format!("OBJECTIVE[{form}]");

    let mut found_marker = false;
    let mut in_content = false;

    for line in content.lines() {
        if !found_marker {
            if line.contains(&marker) {
                found_marker = true;
            }
            continue;
        }

        if !in_content {
            if line.trim() == "---s" {
                in_content = true;
            }
            continue;
        }

        if line.trim() == "---e" {
            return;
        }

        println!("{line}");
    }

    if !found_marker {
        eprintln!("Handoff form not found: {form}");
        eprintln!();
        list_forms(content);
        std::process::exit(1);
    }
}
