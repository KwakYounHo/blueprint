---
type: gate
status: active
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [gate, {gate-name}]
dependencies: []

name: {gate-name}
validates: code | document
description: "{One-line description of what this gate validates}"
---

# Gate: {Gate Name}

## Purpose

{Detailed description of what this gate validates and why it exists.}

## When to Apply

- {Condition 1 when this gate should be run}
- {Condition 2}

## Related Aspects

| Aspect | Description |
|--------|-------------|
| {aspect-name} | {What it validates} |

## Pass Criteria

All associated Aspects must pass for this gate to pass.

## Fail Actions

- {Action to take on failure}
