# Output Path Clashes

Use this when the build fails with file already exists, access denied, or retry-sensitive output errors.

## Typical Symptoms

- `Cannot create a file when that file already exists`
- `The process cannot access the file because it is being used by another process`
- A build succeeds on retry
- Multiple projects appear to write to the same `bin` or `obj` location

## What Usually Causes It

- Shared `BaseOutputPath` or `BaseIntermediateOutputPath`
- Missing `AppendTargetFrameworkToOutputPath`
- Missing `AppendRuntimeIdentifierToOutputPath`
- Extra global properties that create duplicate project instances

## Common Fixes

- Give each project a unique intermediate path
- Keep `obj` inside each project unless you have a deliberate shared-output design
- Add `AppendTargetFrameworkToOutputPath` and `AppendRuntimeIdentifierToOutputPath` when needed
- Remove unnecessary global properties that do not affect output paths

## Rule of Thumb

If two evaluations write to the same path, the path needs to become unique or the build needs to stop creating duplicate project instances.
