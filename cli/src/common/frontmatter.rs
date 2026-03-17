use std::collections::HashMap;
use std::fs;
use std::path::Path;

/// Parsed FrontMatter: key-value pairs extracted from YAML between `---` markers.
pub type FrontMatter = HashMap<String, String>;

/// Result of parsing a file with optional FrontMatter.
pub struct ParsedDocument {
    /// FrontMatter fields (empty if no FrontMatter found)
    pub frontmatter: FrontMatter,
    /// Document body (content after FrontMatter)
    pub body: String,
}

/// Parse a Markdown file, extracting FrontMatter and body.
///
/// FrontMatter is the YAML block between the first two `---` lines.
/// If no FrontMatter is found, returns empty FrontMatter and the entire content as body.
pub fn parse_file(path: &Path) -> Result<ParsedDocument, String> {
    let content =
        fs::read_to_string(path).map_err(|e| format!("Failed to read {}: {e}", path.display()))?;

    parse_string(&content)
}

/// Parse a string with optional FrontMatter.
pub fn parse_string(content: &str) -> Result<ParsedDocument, String> {
    let trimmed = content.trim_start();

    if !trimmed.starts_with("---") {
        return Ok(ParsedDocument {
            frontmatter: HashMap::new(),
            body: content.to_string(),
        });
    }

    // Find the closing `---`
    let after_first = &trimmed[3..].trim_start_matches(['\r', '\n']);
    let Some(end_pos) = after_first.find("\n---") else {
        return Ok(ParsedDocument {
            frontmatter: HashMap::new(),
            body: content.to_string(),
        });
    };

    let yaml_block = &after_first[..end_pos];
    let body_start = &after_first[end_pos + 4..]; // skip "\n---"
    let body = body_start.trim_start_matches(['\r', '\n']).to_string();

    let frontmatter = parse_yaml_simple(yaml_block);

    Ok(ParsedDocument {
        frontmatter,
        body,
    })
}

/// Simple YAML parser for flat key-value FrontMatter.
///
/// Handles basic `key: value` pairs. Arrays like `tags: [a, b, c]`
/// are stored as the raw string "[a, b, c]".
fn parse_yaml_simple(yaml: &str) -> FrontMatter {
    let mut map = HashMap::new();

    for line in yaml.lines() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }

        if let Some((key, value)) = line.split_once(':') {
            let key = key.trim().to_string();
            let value = value.trim().to_string();
            if !key.is_empty() {
                map.insert(key, value);
            }
        }
    }

    map
}

/// Get a specific field from a file's FrontMatter.
pub fn get_field(path: &Path, field: &str) -> Result<Option<String>, String> {
    let doc = parse_file(path)?;
    Ok(doc.frontmatter.get(field).cloned())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_with_frontmatter() {
        let content = "---\ntype: constitution\nstatus: active\nversion: 1.0.0\n---\n\n# Title\n\nBody content here.";
        let doc = parse_string(content).unwrap();
        assert_eq!(doc.frontmatter.get("type").unwrap(), "constitution");
        assert_eq!(doc.frontmatter.get("status").unwrap(), "active");
        assert_eq!(doc.frontmatter.get("version").unwrap(), "1.0.0");
        assert!(doc.body.starts_with("# Title"));
    }

    #[test]
    fn parse_without_frontmatter() {
        let content = "# Title\n\nJust a regular document.";
        let doc = parse_string(content).unwrap();
        assert!(doc.frontmatter.is_empty());
        assert_eq!(doc.body, content);
    }

    #[test]
    fn parse_with_array_field() {
        let content = "---\ntags: [schema, common]\n---\n\nBody";
        let doc = parse_string(content).unwrap();
        assert_eq!(doc.frontmatter.get("tags").unwrap(), "[schema, common]");
    }
}
