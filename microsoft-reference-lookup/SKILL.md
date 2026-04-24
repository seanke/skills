---
name: microsoft-reference-lookup
description: Use when a Microsoft question needs official docs, API signatures, or working code samples.
---

# Microsoft Reference Lookup

## Goal
Use this skill to decide whether a Microsoft question needs docs, code samples, or both.

## Use When
- The user asks how a Microsoft technology works
- You need configuration, limits, quotas, tutorials, or best practices
- You need to verify an API signature or find a working sample
- You want official sources rather than memory

## Workflow
### 1. Pick the reference type

| Need | Open |
| --- | --- |
| Concepts, tutorials, configuration, limits, or best practices | `references/docs.md` |
| API signatures, code samples, or SDK usage | `references/code-reference.md` |

### 2. Use the official source first
Search the docs or sample index before guessing. If the question touches both concept and code, read both references.

### 3. Verify before answering
Do not answer from memory if the question depends on current Microsoft behavior or signatures.

## References
- [Docs](references/docs.md)
- [Code Reference](references/code-reference.md)

## Notes
- If the answer requires a live Microsoft doc lookup, use the docs reference instead of free-form guessing.
