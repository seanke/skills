# Baseline

Record a baseline before changing anything. This is the first step for slow builds because it tells you whether the pain is in restore, compilation, incremental behavior, or graph shape.

## Measure Three Scenarios

| Scenario | What it tells you |
| --- | --- |
| Cold build | Full restore and compilation cost |
| Warm build | Whether recently changed projects rebuild too much |
| No-op build | Whether incremental checks are working |

Use a binlog for each pass:

```bash
dotnet build /bl:baseline.binlog -m
```

If the no-op build is slow, jump to `references/incremental-build.md`. If every scenario is slow, jump to `references/performance-diagnostics.md`.

## What to Record

- Total build time
- Restore time
- Project count
- Whether the build is CPU-bound or waiting on dependency chains

Keep the baseline simple and repeatable. Change one thing at a time after that.
