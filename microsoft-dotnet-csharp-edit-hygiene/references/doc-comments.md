# C# Doc Comments

Use this when the code needs XML documentation or intent-focused comments.

## Good Fits

- Public classes, methods, properties, records, enums, and events
- Internal members with non-obvious behavior
- Branches that need rationale, not narration

## What To Write

- `summary` for purpose
- `param` for meaning and caller expectations
- `returns` for semantic meaning
- `remarks` for rules, side effects, or invariants

## Style

- Keep comments factual and short
- Update stale comments when behavior changes
- Prefer durable rationale over repeating the code

If the file also needs unused using cleanup, open `references/clean-usings.md` next.
