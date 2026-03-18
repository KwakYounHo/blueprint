use std::fs;
use std::path::Path;

use crate::common::registry;

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
    let template_dir = registry::resolve_content_dir().join("templates");

    match args.action {
        Some(Action::List) => list_templates(&template_dir),
        Some(Action::Show { template }) => show_template(&template_dir, &template),
        Some(Action::Copy { template, target }) => copy_template(&template_dir, &template, &target),
        None => {
            eprintln!("Usage: blueprint forma <list|show|copy>");
            std::process::exit(1);
        }
    }
}

fn list_templates(template_dir: &Path) {
    let Ok(entries) = fs::read_dir(template_dir) else {
        eprintln!("Template directory not found: {}", template_dir.display());
        std::process::exit(1);
    };

    let mut names: Vec<String> = entries
        .filter_map(|entry| {
            let name = entry.ok()?.file_name().to_str()?.to_string();
            name.strip_suffix(".template.md").map(String::from)
        })
        .collect();

    names.sort();

    println!("Available templates:");
    println!();

    if names.is_empty() {
        println!("  (no templates found)");
    } else {
        for name in &names {
            println!("  - {name}");
        }
    }
}

fn show_template(template_dir: &Path, name: &str) {
    let file = template_dir.join(format!("{name}.template.md"));

    if !file.exists() {
        eprintln!("Template not found: {name}");
        eprintln!();
        list_templates(template_dir);
        std::process::exit(1);
    }

    match fs::read_to_string(&file) {
        Ok(content) => print!("{content}"),
        Err(e) => {
            eprintln!("Failed to read template: {e}");
            std::process::exit(1);
        }
    }
}

fn copy_template(template_dir: &Path, name: &str, target: &str) {
    let template_file = template_dir.join(format!("{name}.template.md"));

    if !template_file.exists() {
        eprintln!("Template not found: {name}");
        eprintln!();
        list_templates(template_dir);
        std::process::exit(1);
    }

    let output_path = if target.ends_with('/') || Path::new(target).is_dir() {
        let output_name = map_output_filename(name);
        fs::create_dir_all(target).ok();
        Path::new(target).join(output_name)
    } else {
        if let Some(parent) = Path::new(target).parent() {
            fs::create_dir_all(parent).ok();
        }
        Path::new(target).to_path_buf()
    };

    match fs::copy(&template_file, &output_path) {
        Ok(_) => println!("Created: {}", output_path.display()),
        Err(e) => {
            eprintln!("Failed to copy template: {e}");
            std::process::exit(1);
        }
    }
}

/// Map template names to proper output filenames.
fn map_output_filename(name: &str) -> &str {
    match name {
        "brief" => "BRIEF.md",
        "plan" => "PLAN.md",
        "roadmap" => "ROADMAP.md",
        "current-standard" | "current-quick" | "current-compressed" => "CURRENT.md",
        "todo" => "TODO.md",
        "history" => "HISTORY.md",
        "checkpoint-summary" => "CHECKPOINT-SUMMARY.md",
        "weekly-review" => "WEEKLY-REVIEW.md",
        "implementation-notes" => "implementation-notes.md",
        "adr" => "adr.md",
        _ => "output.md",
    }
}
