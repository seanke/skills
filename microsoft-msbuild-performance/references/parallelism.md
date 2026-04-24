# Parallelism

Use this when the build is not using CPU well or the dependency graph is too serial.

## Main Tools

- `dotnet build -m` to use multiple worker nodes
- `dotnet build /graph` for static graph scheduling
- `BuildInParallel="true"` on custom MSBuild task invocations
- Smaller or fewer `ProjectReference` edges when they are unnecessary

## What to Check

- Whether the critical path is long
- Whether one project blocks many others
- Whether the solution is wide enough to benefit from parallelism
- Whether a solution filter would let you build less work

## Binlog Clues

- Idle nodes while one project runs for a long time
- Sum of per-project times much larger than total build time
- A deep chain of dependencies rather than a wide graph

If the graph is healthy but the build is still slow, the bottleneck is probably in the work the projects are doing, not in scheduling.
