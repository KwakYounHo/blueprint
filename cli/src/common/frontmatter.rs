use std::collections::HashMap;
use std::fs;
use std::path::Path;

use serde_yml::Value;

/// Parsed FrontMatter: key-value pairs from YAML.
/// Values are stored as their YAML string representation.
/// Arrays are stored as comma-separated strings (e.g., "schema, common").
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

    let frontmatter = parse_yaml(yaml_block);

    Ok(ParsedDocument {
        frontmatter,
        body,
    })
}

/// Parse YAML block into a flat key-value map using serde_yml.
///
/// Scalar values are stored as-is.
/// Arrays are stored as comma-separated strings.
/// Nested objects are skipped (FrontMatter is typically flat).
fn parse_yaml(yaml: &str) -> FrontMatter {
    let mut map = HashMap::new();

    let Ok(value) = serde_yml::from_str::<Value>(yaml) else {
        return map;
    };

    let Some(mapping) = value.as_mapping() else {
        return map;
    };

    for (key, val) in mapping {
        let Some(key_str) = key.as_str() else {
            continue;
        };

        let value_str = yaml_value_to_string(val);
        map.insert(key_str.to_string(), value_str);
    }

    map
}

/// Convert a YAML Value to a string representation.
fn yaml_value_to_string(value: &Value) -> String {
    match value {
        Value::String(s) => s.clone(),
        Value::Number(n) => n.to_string(),
        Value::Bool(b) => b.to_string(),
        Value::Null => String::new(),
        Value::Sequence(seq) => {
            // Convert array to comma-separated string
            seq.iter()
                .filter_map(|v| match v {
                    Value::String(s) => Some(s.clone()),
                    Value::Number(n) => Some(n.to_string()),
                    Value::Bool(b) => Some(b.to_string()),
                    _ => None,
                })
                .collect::<Vec<_>>()
                .join(", ")
        }
        Value::Mapping(_) => "(object)".to_string(),
        Value::Tagged(tagged) => yaml_value_to_string(&tagged.value),
    }
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
        assert_eq!(doc.frontmatter.get("tags").unwrap(), "schema, common");
    }

    #[test]
    fn parse_with_quoted_string() {
        let content = "---\ndescription: \"Validates document format\"\n---\n\nBody";
        let doc = parse_string(content).unwrap();
        assert_eq!(
            doc.frontmatter.get("description").unwrap(),
            "Validates document format"
        );
    }

    #[test]
    fn parse_with_boolean_and_number() {
        let content = "---\nenabled: true\ncount: 42\n---\n\nBody";
        let doc = parse_string(content).unwrap();
        assert_eq!(doc.frontmatter.get("enabled").unwrap(), "true");
        assert_eq!(doc.frontmatter.get("count").unwrap(), "42");
    }
}
