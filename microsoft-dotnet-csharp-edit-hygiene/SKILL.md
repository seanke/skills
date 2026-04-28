---
name: microsoft-dotnet-csharp-edit-hygiene
description: Use when finishing a C# edit and you need XML docs or a low-risk using cleanup pass.
---

# C# Edit Hygiene

## Goal
Use this skill to finish a C# change with the right documentation and cleanup.

## Use When
- You have just added or refactored C# code
- XML documentation needs to be added or corrected
- Unused usings or low-risk formatting cleanup is left over
- You want a final pass that does not change behavior

## Workflow
### 1. Document the code
If the change introduces public API or non-obvious behavior, open `references/doc-comments.md` first.

### 2. Clean the file
If the edit left unused usings or simple analyzer issues, open `references/clean-usings.md`.

### 3. Keep the scope small
Do not turn a hygiene pass into a redesign pass. Stay on the changed files unless there is a clear reason to widen scope.

## References
- [Doc Comments](references/doc-comments.md)
- [Clean Usings](references/clean-usings.md)

## Notes
- If the C# edit also needs behavior changes, handle that in the feature or fix skill first.
