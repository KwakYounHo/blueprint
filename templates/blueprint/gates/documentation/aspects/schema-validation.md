---
type: aspect
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [aspect, documentation, schema-validation]
dependencies: [../gate.md]

name: schema-validation
gate: documentation
description: "Validates FrontMatter compliance against schema definitions"
---

# Aspect: Schema Validation

## Description

Validates that document FrontMatter conforms to the schema defined for its document type.
Schema definitions are located in `blueprint/front-matters/`.

## Criteria

### Required (Must Pass)

#### Common Fields (base.schema.md)
- [ ] `type` field exists and matches a valid type defined in schema
- [ ] `status` field exists and matches valid values for the document category
- [ ] `created` field follows YYYY-MM-DD format
- [ ] `updated` field follows YYYY-MM-DD format
- [ ] `version` field follows semantic versioning format (X.Y.Z)

#### Type-Specific Fields
- [ ] All required fields defined in `{type}.schema.md` are present
- [ ] Each field value satisfies constraints defined in schema

#### Dependencies Integrity
- [ ] `dependencies` array contains only first-degree relationships when present
- [ ] Documents with hierarchical relationships include their direct parent in `dependencies`
- [ ] All paths in `dependencies` array reference existing documents
- [ ] No missing relationships with related documents within Orchestrator-specified scope

### Recommended (Should Pass)

- [ ] `tags` is an array and includes the document type

## Validation Method

1. Parse target document's FrontMatter
2. Identify document type from `type` field
3. Validate common fields against `blueprint/front-matters/base.schema.md`
4. Validate type-specific fields against `blueprint/front-matters/{type}.schema.md`
5. Validate `dependencies` array for path validity and hierarchical integrity
