use std::fs;

use serde::{Deserialize, Serialize};

use super::paths;

/// A single project entry in the registry.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Project {
    pub alias: String,
    #[serde(default = "default_type")]
    pub r#type: String,
    #[serde(default)]
    pub paths: Vec<String>,
    #[serde(default)]
    pub notes: String,
}

fn default_type() -> String {
    "repo".to_string()
}

/// The registry containing all registered projects.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Registry {
    #[serde(default)]
    pub projects: Vec<Project>,
}

impl Registry {
    /// Load registry from disk. Creates empty registry if file doesn't exist.
    pub fn load() -> Result<Self, String> {
        let path = paths::registry_file();

        if !path.exists() {
            return Ok(Registry {
                projects: Vec::new(),
            });
        }

        let content = fs::read_to_string(&path)
            .map_err(|e| format!("Failed to read registry: {e}"))?;

        serde_json::from_str(&content)
            .map_err(|e| format!("Failed to parse registry: {e}"))
    }

    /// Save registry to disk.
    pub fn save(&self) -> Result<(), String> {
        let path = paths::registry_file();

        // Ensure parent directory exists
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent)
                .map_err(|e| format!("Failed to create directory: {e}"))?;
        }

        let content = serde_json::to_string_pretty(self)
            .map_err(|e| format!("Failed to serialize registry: {e}"))?;

        fs::write(&path, content)
            .map_err(|e| format!("Failed to write registry: {e}"))
    }

    /// Find a project by alias.
    pub fn find_by_alias(&self, alias: &str) -> Option<&Project> {
        self.projects.iter().find(|p| p.alias == alias)
    }

    /// Find a project by alias (mutable).
    pub fn find_by_alias_mut(&mut self, alias: &str) -> Option<&mut Project> {
        self.projects.iter_mut().find(|p| p.alias == alias)
    }

    /// Find a project that has a given path registered.
    pub fn find_by_path(&self, path: &str) -> Option<&Project> {
        let canonical = canonicalize_path(path);
        self.projects.iter().find(|p| {
            p.paths.iter().any(|registered| {
                canonicalize_path(registered) == canonical
            })
        })
    }

    /// Add a new project to the registry.
    pub fn add(&mut self, project: Project) {
        self.projects.push(project);
    }

    /// Remove a project by alias. Returns true if found and removed.
    pub fn remove(&mut self, alias: &str) -> bool {
        let len = self.projects.len();
        self.projects.retain(|p| p.alias != alias);
        self.projects.len() < len
    }
}

/// Resolve the data directory for a given project alias.
///
/// Returns `~/.blueprint/projects/{alias}/`
pub fn project_data_dir(alias: &str) -> std::path::PathBuf {
    paths::projects_dir().join(alias)
}

/// Resolve the plans directory for a given project alias.
///
/// Returns `~/.blueprint/projects/{alias}/plans/`
pub fn project_plans_dir(alias: &str) -> std::path::PathBuf {
    project_data_dir(alias).join("plans")
}

/// Attempt to canonicalize a path for comparison, falling back to the original.
fn canonicalize_path(path: &str) -> String {
    fs::canonicalize(path)
        .map(|p| p.to_string_lossy().to_string())
        .unwrap_or_else(|_| path.to_string())
}

/// Detect the current project based on the working directory.
///
/// Walks up from the current directory checking if any path is registered.
pub fn detect_current_project(registry: &Registry) -> Option<&Project> {
    let cwd = std::env::current_dir().ok()?;

    // Check current directory and all parents
    let mut dir = Some(cwd.as_path());
    while let Some(current) = dir {
        if let Some(project) = registry.find_by_path(current.to_str()?) {
            return Some(project);
        }
        dir = current.parent();
    }

    None
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn empty_registry() {
        let reg = Registry { projects: Vec::new() };
        assert!(reg.find_by_alias("test").is_none());
        assert_eq!(reg.projects.len(), 0);
    }

    #[test]
    fn add_and_find_project() {
        let mut reg = Registry { projects: Vec::new() };
        reg.add(Project {
            alias: "myproject".to_string(),
            r#type: "repo".to_string(),
            paths: vec!["/tmp/myproject".to_string()],
            notes: String::new(),
        });

        assert!(reg.find_by_alias("myproject").is_some());
        assert!(reg.find_by_alias("other").is_none());
    }

    #[test]
    fn remove_project() {
        let mut reg = Registry { projects: Vec::new() };
        reg.add(Project {
            alias: "test".to_string(),
            r#type: "repo".to_string(),
            paths: vec![],
            notes: String::new(),
        });

        assert!(reg.remove("test"));
        assert!(!reg.remove("test")); // already removed
        assert_eq!(reg.projects.len(), 0);
    }

    #[test]
    fn serialize_deserialize() {
        let mut reg = Registry { projects: Vec::new() };
        reg.add(Project {
            alias: "test".to_string(),
            r#type: "bare".to_string(),
            paths: vec!["/tmp/a".to_string(), "/tmp/b".to_string()],
            notes: "test project".to_string(),
        });

        let json = serde_json::to_string(&reg).unwrap();
        let loaded: Registry = serde_json::from_str(&json).unwrap();

        assert_eq!(loaded.projects.len(), 1);
        assert_eq!(loaded.projects[0].alias, "test");
        assert_eq!(loaded.projects[0].paths.len(), 2);
    }
}
