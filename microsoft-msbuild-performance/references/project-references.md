# Project References

Use this when `ResolveProjectReferences` appears expensive in the summary.

## Important Detail

`ResolveProjectReferences` often reports wait time, not real CPU work. The target can look expensive because it is waiting for dependent projects to finish.

## What to Inspect Instead

- `Task Performance Summary`
- `Csc`
- `ResolveAssemblyReference`
- `Copy`
- Any target that actually does the expensive work

## Practical Rule

Do not optimize the target name itself first. Check the work it is waiting on, then decide whether the dependency graph should be shortened or a downstream target should be improved.

If the target dominates but the machine is still underused, the fix may be in `references/parallelism.md`.
