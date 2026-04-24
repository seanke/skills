# Incremental Build

Use this when a build is slow on the second run, rebuilds without changes, or reruns targets that should have been skipped.

## How MSBuild Decides To Skip

MSBuild compares target `Inputs` and `Outputs`. If every output is newer than every input, the target is skipped. If a target has no `Inputs` and `Outputs`, it runs every time.

```xml
<Target Name="Transform"
        Inputs="@(TransformFiles)"
        Outputs="@(TransformFiles->'$(IntermediateOutputPath)%(Filename).out')">
  <!-- work here -->
</Target>
```

## Common Reasons Incremental Builds Break

- Missing `Inputs` or `Outputs` on a custom target
- Volatile output paths or filenames
- Files written during the build but not registered in `FileWrites`
- Globs that only expand at evaluation time
- Visual Studio Fast Up-to-Date Check disagreeing with MSBuild

## Diagnose

1. Build twice and capture binlogs.
2. Replay the second build to a diagnostic log.
3. Search for `Building target completely`, `Building target incrementally`, and `Skipping target`.
4. Look for `is newer than output` messages to find the input that forced the rerun.

## Fix Pattern

- Put generated files under `$(IntermediateOutputPath)`
- Add generated source to `Compile`
- Add every generated file to `FileWrites`
- Use stable target `Inputs` and `Outputs`
- Use `BeforeTargets="CoreCompile;BeforeCompile"` for generated source

## Visual Studio Up-To-Date Check

If VS rebuilds when the command line does not, the Fast Up-To-Date Check may be wrong. You can disable it temporarily with:

```xml
<PropertyGroup>
  <DisableFastUpToDateCheck>true</DisableFastUpToDateCheck>
</PropertyGroup>
```

This reference should be the first stop when the build is rerunning work it should have skipped.
