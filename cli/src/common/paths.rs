use std::path::PathBuf;

/// Resolve the Blueprint home directory.
///
/// Priority: $BLUEPRINT_HOME > ~/.blueprint/
pub fn blueprint_home() -> PathBuf {
    if let Ok(home) = std::env::var("BLUEPRINT_HOME") {
        return PathBuf::from(home);
    }

    let mut path = home_dir();
    path.push(".blueprint");
    path
}

/// Resolve the base content directory (~/.blueprint/base/).
pub fn base_dir() -> PathBuf {
    let mut path = blueprint_home();
    path.push("base");
    path
}

/// Resolve the projects directory (~/.blueprint/projects/).
pub fn projects_dir() -> PathBuf {
    let mut path = blueprint_home();
    path.push("projects");
    path
}

/// Resolve the project registry file (~/.blueprint/projects/.registry.json).
pub fn registry_file() -> PathBuf {
    let mut path = projects_dir();
    path.push(".registry.json");
    path
}

/// Get the user's home directory.
fn home_dir() -> PathBuf {
    std::env::var("HOME")
        .map(PathBuf::from)
        .expect("HOME environment variable not set")
}

#[cfg(test)]
mod tests {
    use super::*;

    // Environment variable tests are combined into one test
    // because tests run in parallel and share the process environment.
    #[test]
    fn path_resolution_with_env_override() {
        unsafe { std::env::set_var("BLUEPRINT_HOME", "/tmp/test-blueprint") };

        assert_eq!(blueprint_home(), PathBuf::from("/tmp/test-blueprint"));
        assert_eq!(base_dir(), PathBuf::from("/tmp/test-blueprint/base"));
        assert_eq!(projects_dir(), PathBuf::from("/tmp/test-blueprint/projects"));
        assert_eq!(
            registry_file(),
            PathBuf::from("/tmp/test-blueprint/projects/.registry.json")
        );

        unsafe { std::env::remove_var("BLUEPRINT_HOME") };
    }

    #[test]
    fn default_path_uses_home_directory() {
        // Ensure BLUEPRINT_HOME is not set for this test
        let saved = std::env::var("BLUEPRINT_HOME").ok();
        unsafe { std::env::remove_var("BLUEPRINT_HOME") };

        let home = std::env::var("HOME").unwrap();
        let result = blueprint_home();
        assert_eq!(result, PathBuf::from(format!("{home}/.blueprint")));

        // Restore if it was set
        if let Some(val) = saved {
            unsafe { std::env::set_var("BLUEPRINT_HOME", val) };
        }
    }
}
