use std::fs;
use std::path::Path;

use crate::common::frontmatter;
use crate::common::paths;

/// FrontMatter search and schemas
#[derive(clap::Args)]
pub struct Args {
    #[command(subcommand)]
    pub action: Option<Action>,
}

#[derive(clap::Subcommand)]
pub enum Action {
    /// Search documents by FrontMatter field
    Search {
        field: String,
        value: String,
        /// Search path (defaults to current directory)
        path: Option<String>,
    },
    /// Show FrontMatter of file(s)
    Show {
        /// Files to show FrontMatter for
        #[arg(required = true)]
        files: Vec<String>,
    },
    /// View FrontMatter schema
    Schema {
        /// Schema type (or --list to list all)
        doc_type: String,
    },
}

pub fn run(args: Args) {
    match args.action {
        Some(Action::Search { field, value, path }) => {
            do_search(&field, &value, path.as_deref().unwrap_or("."));
        }
        Some(Action::Show { files }) => do_show(&files),
        Some(Action::Schema { doc_type }) => do_schema(&doc_type),
        None => {
            eprintln!("Usage: blueprint frontis <search|show|schema>");
            std::process::exit(1);
        }
    }
}

fn do_search(field: &str, value: &str, search_path: &str) {
    let path = Path::new(search_path);

    if !path.is_dir() {
        eprintln!("Search path not found: {search_path}");
        std::process::exit(1);
    }

    let mut found = false;
    search_recursive(path, field, value, &mut found);

    if !found {
        eprintln!("No documents found with {field}: {value} in {search_path}");
    }
}

fn search_recursive(dir: &Path, field: &str, value: &str, found: &mut bool) {
    let Ok(entries) = fs::read_dir(dir) else {
        return;
    };

    for entry in entries.flatten() {
        let path = entry.path();

        if path.is_dir() {
            search_recursive(&path, field, value, found);
            continue;
        }

        let Some(ext) = path.extension().and_then(|e| e.to_str()) else {
            continue;
        };

        if ext != "md" && ext != "yaml" {
            continue;
        }

        if let Ok(Some(field_value)) = frontmatter::get_field(&path, field) {
            if field_value.contains(value) {
                println!("{}", path.display());
                *found = true;
            }
        }
    }
}

fn do_show(files: &[String]) {
    for file in files {
        let path = Path::new(file);
        println!("=== {file} ===");

        if !path.exists() {
            println!("File not found");
            println!();
            continue;
        }

        match frontmatter::parse_file(path) {
            Ok(doc) => {
                if doc.frontmatter.is_empty() {
                    println!("(no FrontMatter)");
                } else {
                    println!("---");
                    let mut keys: Vec<&String> = doc.frontmatter.keys().collect();
                    keys.sort();
                    for key in keys {
                        println!("{key}: {}", doc.frontmatter[key]);
                    }
                    println!("---");
                }
            }
            Err(e) => println!("Error: {e}"),
        }
        println!();
    }
}

fn do_schema(doc_type: &str) {
    let schema_dir = paths::base_dir().join("front-matters");

    if doc_type == "--list" || doc_type == "-l" {
        list_schemas(&schema_dir);
        return;
    }

    // "schema" type maps to "base" to avoid self-reference
    let actual_type = if doc_type == "schema" { "base" } else { doc_type };
    let schema_file = schema_dir.join(format!("{actual_type}.schema.md"));

    if !schema_file.exists() {
        eprintln!("Schema not found: {doc_type}");
        eprintln!();
        list_schemas(&schema_dir);
        std::process::exit(1);
    }

    match fs::read_to_string(&schema_file) {
        Ok(content) => print!("{content}"),
        Err(e) => {
            eprintln!("Failed to read schema: {e}");
            std::process::exit(1);
        }
    }
}

fn list_schemas(schema_dir: &Path) {
    let Ok(entries) = fs::read_dir(schema_dir) else {
        eprintln!("Schema directory not found: {}", schema_dir.display());
        std::process::exit(1);
    };

    let mut names: Vec<String> = entries
        .filter_map(|entry| {
            let name = entry.ok()?.file_name().to_str()?.to_string();
            name.strip_suffix(".schema.md").map(String::from)
        })
        .collect();

    names.sort();

    println!("Available schemas:");
    println!();

    if names.is_empty() {
        println!("  (no schemas found)");
    } else {
        for name in &names {
            println!("  - {name}");
        }
    }
}
