# Specifications

This directory contains Specification documents - the "source code" of the SDD framework.

## Directory Structure

```
specs/
├── lib/                    # Implementation Specs (declaration)
│   └── {module-name}/
│       └── spec.yaml
└── features/               # Feature Specs (invocation)
    └── {feature-name}/
        └── spec.yaml
```

## Spec Types

| Type | Location | Analogy | Purpose |
|------|----------|---------|---------|
| Implementation | `lib/` | Library | Reusable units, pure functions, declarations |
| Feature | `features/` | Main | Business flows, compositions, invocations |

## Lifecycle

```
Discussion → Lexer → Parser → Specifier → Specification
                                              ↓
                              draft → review → complete
                                              ↓
                              Implementer → Code
```

Only `complete` status Specifications proceed to implementation.

## Schema

See `blueprint/front-matters/spec.schema.md` for the full schema definition.

### Required Sections (10)

1. `what` - What are we building?
2. `why` - Why are we building it?
3. `scope` - What's the boundary?
4. `constraints` - What constraints apply?
5. `input` - What goes in?
6. `output` - What comes out?
7. `edge_cases` - What are the exceptions?
8. `anti_patterns` - What should we avoid?
9. `dependencies` - What do we depend on?
10. `acceptance_criteria` - How do we know it's done?

## Commands

```bash
# Search for specs
frontis search type spec specs/

# Search by status
frontis search status complete specs/

# View spec schema
frontis schema spec
```
