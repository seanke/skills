# C# Clean Usings

Use this when the C# file is already correct but needs a low-risk cleanup pass.

## Good Fits

- Unused `using` directives
- Formatting cleanup after a code change
- Analyzer noise that can be fixed without design work

## Workflow

1. Clean the changed C# files, not the whole repo.
2. Prefer the editor or refactoring tool for scoped cleanup.
3. Fall back to `dotnet format` if needed.
4. Re-run cleanup after formatting if the file structure changed.

## Rules

- Do not expand into unrelated refactoring
- Skip generated or intentionally exempt files
- Keep behavior unchanged
