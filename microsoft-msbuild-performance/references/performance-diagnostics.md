# Performance Diagnostics

Use this when you already know the build is slow and you need to find the expensive targets or tasks.

## Replay the Binlog

```bash
dotnet msbuild build.binlog -noconlog -fl -flp:v=diag;logfile=full.log;performancesummary
```

Then inspect:

```bash
grep "Target Performance Summary\|Task Performance Summary" -A 50 full.log
```

## Read the Summary

- `ResolveAssemblyReference` over 5 seconds is worth investigating
- Analyzer time should not dominate `Csc`
- Copy-heavy builds often point at file I/O, not compilation
- Low node utilization means the graph is too serial
- A single target over half the build time usually deserves attention

## Common Bottleneck Families

- `ResolveAssemblyReference`
- Roslyn analyzers and source generators
- Copy tasks and other file I/O
- Evaluation overhead
- Restore running in the inner build loop
- Deep project dependency chains

## Next Step

If the hot spot is a timing artifact rather than real work, open `references/project-references.md`. If the build is just not using the machine well, open `references/parallelism.md`.
