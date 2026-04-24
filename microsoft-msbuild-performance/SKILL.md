---
name: microsoft-msbuild-performance
description: Use when an MSBuild or .NET build is slow, not parallel enough, or needs baseline, incremental, server, or graph tuning.
---

# MSBuild Performance

## Goal
Use this skill to pick the right MSBuild performance subtopic without loading several separate skills.

## Use When
- Cold, warm, or no-op builds are slower than expected
- Parallelism looks poor or the solution has a deep dependency chain
- CLI builds are slower than IDE builds and you want server reuse
- You need to decide whether the problem is baseline, incremental, parallelism, or project-reference shape
- A diagnostic binlog already exists and you want to focus on timing rather than failures

## Workflow
### 1. Start with a baseline
Record cold, warm, and no-op build timings before changing anything. If the no-op build is slow, go to `references/incremental-build.md`. If the build is broadly slow, continue to diagnostics.

### 2. Pick the right performance branch

| Symptom | Open |
| --- | --- |
| Need target/task timing, RAR, analyzers, copy, or evaluation analysis | `references/performance-diagnostics.md` |
| No-op or warm builds keep rerunning | `references/incremental-build.md` |
| CPU is underused or the graph is too serial | `references/parallelism.md` |
| CLI builds feel colder than IDE builds | `references/msbuild-server.md` |
| `ResolveProjectReferences` dominates the summary | `references/project-references.md` |

### 3. Tune one factor at a time
Change the smallest thing that matches the symptom, then rebuild and compare against the baseline. Do not mix incremental, graph, and path changes in one pass.

## References
- [Baseline](references/baseline.md)
- [Performance Diagnostics](references/performance-diagnostics.md)
- [Incremental Build](references/incremental-build.md)
- [Parallelism](references/parallelism.md)
- [MSBuild Server](references/msbuild-server.md)
- [Project References](references/project-references.md)

## Notes
- Use `microsoft-msbuild-troubleshooting` when the build is failing rather than just slow.
