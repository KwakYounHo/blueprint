use std::fs;
use std::path::{Path, PathBuf};

use super::frontmatter;
use super::paths;

/// Platform-specific adapter definition.
pub struct PlatformDef {
    pub name: &'static str,
    pub agent_target_dir: PathBuf,
    pub skill_target_dir: PathBuf,
    pub hooks_target_dir: PathBuf,
    pub bootstrap_template: &'static str,
    /// Map capability names from spec to platform tool names.
    pub capability_map: &'static [(&'static str, &'static str)],
}

/// Information extracted from a .spec.md file.
pub struct SpecInfo {
    pub description: String,
    pub capabilities: Vec<String>,
}

/// Install Blueprint for a platform.
///
/// 1. Read Instructions from ~/.blueprint/base/instructions/
/// 2. For each: generate FrontMatter + inject Bootstrap + write to platform dir
/// 3. Copy hooks
pub fn install(platform: &PlatformDef) {
    let instructions_dir = paths::base_dir().join("instructions");

    if !instructions_dir.exists() {
        eprintln!("Instructions directory not found: {}", instructions_dir.display());
        eprintln!("Run the Blueprint installer first.");
        std::process::exit(1);
    }

    println!();
    println!("Blueprint Adapter: {}", platform.name);
    println!("=================================");
    println!();

    // Install agents
    let agents_dir = instructions_dir.join("agents");
    if agents_dir.is_dir() {
        println!("Installing agents → {}", platform.agent_target_dir.display());
        fs::create_dir_all(&platform.agent_target_dir).ok();
        install_instructions(&agents_dir, &platform.agent_target_dir, platform, InstructionType::Agent);
        println!();
    }

    // Install skills
    let skills_dir = instructions_dir.join("skills");
    if skills_dir.is_dir() {
        println!("Installing skills → {}", platform.skill_target_dir.display());
        fs::create_dir_all(&platform.skill_target_dir).ok();
        install_instructions(&skills_dir, &platform.skill_target_dir, platform, InstructionType::Skill);
        println!();
    }

    // Copy hooks
    let hooks_source = paths::base_dir().join("hooks");
    if hooks_source.is_dir() {
        println!("Installing hooks → {}", platform.hooks_target_dir.display());
        fs::create_dir_all(&platform.hooks_target_dir).ok();
        copy_directory(&hooks_source, &platform.hooks_target_dir);
        println!();
    }

    println!("Installation complete.");
    println!();
    println!("Next steps:");
    println!("  1. cd /path/to/your/project");
    println!("  2. blueprint project init <alias>");
}

/// Show installation status for a platform.
pub fn status(platform: &PlatformDef) {
    println!("Blueprint Adapter Status: {}", platform.name);
    println!();

    let check = |dir: &Path, label: &str| {
        if dir.exists() {
            let count = fs::read_dir(dir)
                .map(|entries| entries.filter_map(|e| e.ok()).filter(|e| {
                    let name = e.file_name().to_string_lossy().to_string();
                    name.ends_with(".md") && !name.ends_with(".spec.md")
                }).count())
                .unwrap_or(0);
            println!("  {label}: {count} files ({})", dir.display());
        } else {
            println!("  {label}: not installed");
        }
    };

    check(&platform.agent_target_dir, "Agents");
    check(&platform.skill_target_dir, "Skills");

    if platform.hooks_target_dir.exists() {
        println!("  Hooks:  installed ({})", platform.hooks_target_dir.display());
    } else {
        println!("  Hooks:  not installed");
    }
}

/// Uninstall Blueprint from a platform.
pub fn uninstall(platform: &PlatformDef) {
    println!("Uninstalling Blueprint from {}...", platform.name);
    println!();

    // Remove installed instruction files (only Blueprint-generated ones)
    remove_blueprint_files(&platform.agent_target_dir, "agents");
    remove_blueprint_files(&platform.skill_target_dir, "skills");

    println!();
    println!("Uninstallation complete.");
    println!("Note: hooks and configuration were preserved. Remove manually if needed:");
    println!("  Hooks: {}", platform.hooks_target_dir.display());
}

// --- Internal ---

#[derive(Clone, Copy)]
enum InstructionType {
    Agent,
    Skill,
}

fn install_instructions(
    source_dir: &Path,
    target_dir: &Path,
    platform: &PlatformDef,
    inst_type: InstructionType,
) {
    let Ok(entries) = fs::read_dir(source_dir) else {
        return;
    };

    for entry in entries.flatten() {
        let path = entry.path();
        let name = entry.file_name().to_string_lossy().to_string();

        // Skip spec files and non-md files
        if !name.ends_with(".md") || name.ends_with(".spec.md") {
            continue;
        }

        let stem = name.strip_suffix(".md").unwrap_or(&name);

        // Read instruction body
        let Ok(body) = fs::read_to_string(&path) else {
            eprintln!("  {stem}: failed to read");
            continue;
        };

        // Read spec for metadata
        let spec_path = source_dir.join(format!("{stem}.spec.md"));
        let spec_info = read_spec_info(&spec_path);

        // Generate platform file
        let frontmatter = generate_frontmatter(platform, &spec_info, stem, inst_type);
        let output = format!("{frontmatter}\n{}\n{body}", platform.bootstrap_template);

        // Write to target
        let target_file = match inst_type {
            InstructionType::Agent => target_dir.join(&name),
            InstructionType::Skill => {
                // Skills use subdirectory structure: {name}/SKILL.md
                let skill_dir = target_dir.join(stem);
                fs::create_dir_all(&skill_dir).ok();
                skill_dir.join("SKILL.md")
            }
        };
        match fs::write(&target_file, output) {
            Ok(_) => println!("  {stem}: installed"),
            Err(e) => eprintln!("  {stem}: failed to write — {e}"),
        }
    }
}

fn generate_frontmatter(
    platform: &PlatformDef,
    spec: &SpecInfo,
    name: &str,
    inst_type: InstructionType,
) -> String {
    match inst_type {
        InstructionType::Agent => {
            // Map capabilities to platform tool names
            let tools: Vec<&str> = spec.capabilities.iter()
                .filter_map(|cap| {
                    platform.capability_map.iter()
                        .find(|(key, _)| cap.contains(key))
                        .map(|(_, tool)| *tool)
                })
                .collect();

            let tools_str = if tools.is_empty() {
                "Read, Grep, Glob, Bash".to_string() // fallback
            } else {
                // Deduplicate
                let mut unique: Vec<&str> = Vec::new();
                for t in &tools {
                    if !unique.contains(t) {
                        unique.push(t);
                    }
                }
                unique.join(", ")
            };

            format!(
                "---\nname: {name}\ndescription: {}\ntools: {tools_str}\n---\n",
                spec.description
            )
        }
        InstructionType::Skill => {
            format!(
                "---\nname: {name}\ndescription: {}\n---\n",
                spec.description
            )
        }
    }
}

fn read_spec_info(spec_path: &Path) -> SpecInfo {
    let default = SpecInfo {
        description: String::new(),
        capabilities: Vec::new(),
    };

    let Ok(doc) = frontmatter::parse_file(spec_path) else {
        return default;
    };

    let body = &doc.body;

    // Extract description (first non-empty line after "## Description")
    let description = extract_section_first_line(body, "## Description")
        .unwrap_or_default();

    // Extract capabilities (lines in "## Required Capabilities" table)
    let capabilities = extract_table_first_column(body, "## Required Capabilities");

    SpecInfo {
        description,
        capabilities,
    }
}

fn extract_section_first_line(body: &str, header: &str) -> Option<String> {
    let mut found = false;
    for line in body.lines() {
        if line.trim() == header {
            found = true;
            continue;
        }
        if found {
            let trimmed = line.trim();
            if !trimmed.is_empty() {
                return Some(trimmed.to_string());
            }
        }
    }
    None
}

fn extract_table_first_column(body: &str, header: &str) -> Vec<String> {
    let mut in_section = false;
    let mut in_table = false;
    let mut results = Vec::new();

    for line in body.lines() {
        if line.trim() == header {
            in_section = true;
            continue;
        }

        if in_section && !in_table {
            if line.contains('|') && line.contains("Capability") {
                in_table = true;
                continue; // header row
            }
            if line.starts_with("## ") {
                break; // next section
            }
        }

        if in_table {
            if line.trim().starts_with("|--") || line.trim().starts_with("| --") {
                continue; // separator row
            }
            if !line.contains('|') || line.starts_with("## ") {
                break; // end of table
            }

            // Extract first column
            let parts: Vec<&str> = line.split('|').collect();
            if parts.len() >= 2 {
                let cell = parts[1].trim();
                if !cell.is_empty() {
                    results.push(cell.to_string());
                }
            }
        }
    }

    results
}

fn copy_directory(source: &Path, target: &Path) {
    let Ok(entries) = fs::read_dir(source) else {
        return;
    };

    for entry in entries.flatten() {
        let path = entry.path();
        let name = entry.file_name();
        let target_path = target.join(&name);

        if path.is_dir() {
            fs::create_dir_all(&target_path).ok();
            copy_directory(&path, &target_path);
        } else {
            match fs::copy(&path, &target_path) {
                Ok(_) => println!("  {}: copied", name.to_string_lossy()),
                Err(e) => eprintln!("  {}: failed — {e}", name.to_string_lossy()),
            }
        }
    }
}

fn remove_blueprint_files(dir: &Path, label: &str) {
    if !dir.exists() {
        println!("  {label}: not installed (skipped)");
        return;
    }

    // Read installed instructions to know which files we placed
    let instructions_dir = paths::base_dir().join("instructions");
    let sub = match label {
        "agents" => "agents",
        "skills" => "skills",
        _ => return,
    };

    let source = instructions_dir.join(sub);
    if !source.is_dir() {
        return;
    }

    let mut removed = 0;
    if let Ok(entries) = fs::read_dir(&source) {
        for entry in entries.flatten() {
            let name = entry.file_name().to_string_lossy().to_string();
            if name.ends_with(".md") && !name.ends_with(".spec.md") {
                let stem = name.strip_suffix(".md").unwrap_or(&name);

                if label == "skills" {
                    // Skills use subdirectory structure: {name}/SKILL.md
                    let skill_dir = dir.join(stem);
                    if skill_dir.is_dir() {
                        fs::remove_dir_all(&skill_dir).ok();
                        removed += 1;
                    }
                } else {
                    // Agents are flat files
                    let target = dir.join(&name);
                    if target.exists() {
                        fs::remove_file(&target).ok();
                        removed += 1;
                    }
                }
            }
        }
    }

    println!("  {label}: {removed} files removed");
}
