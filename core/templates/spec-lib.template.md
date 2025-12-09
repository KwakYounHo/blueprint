---
type: spec
status: draft
version: 1.0.0
created: {{date}}
updated: {{date}}
tags: [spec, lib]
dependencies: []

spec-type: lib
spec-id: "LIB-{namespace}/{module}"
name: "{Module Name}"
source-discussion: "{path/to/discussion.md}"
source-memory: "{path/to/memory.md}"
---

# {Module Name}

## 1. Purpose

{Single sentence describing what this module does.}

## 2. File Location

```
{exact/path/to/file.ts}
```

## 3. Implementation

```typescript
// Complete code - NO placeholders
// Forbidden: "// TODO", "...", "REPLACE_*"

{actual implementation code}
```

## 4. Integration Point

**Called from**: `{file.ts:line}` in `{function/context}`

```typescript
import { xxx } from "{path}";

// How this module is used
{usage example}
```

## 5. Acceptance Criteria

| # | Criterion | Verification |
|---|-----------|--------------|
| 1 | {criterion} | {how to verify} |
| 2 | {criterion} | {how to verify} |
