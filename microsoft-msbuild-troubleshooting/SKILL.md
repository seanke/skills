---
name: microsoft-msbuild-troubleshooting
description: Use when an MSBuild or .NET build fails, needs a binlog replay, or has generated-file or output-path problems.
---

# MSBuild Troubleshooting

## Goal
Use this skill to route build failures to the right subtopic quickly.

## Use When
- Build errors are unclear or cascade across projects
- You need a binlog replay or text log
- Build outputs clash in bin/obj or files are overwritten
- Generated files are missing from compilation or output

## Workflow
### 1. Capture the build trace
If you do not already have a binlog, open `references/binlog-generation.md` and capture one first.

### 2. Replay and inspect
Use `references/binlog-analysis.md` to turn the binlog into readable logs and find the first meaningful failure.

### 3. Check for build-shape problems
If the error looks like a file clash, open `references/output-path-clashes.md`. If a generated file is missing, open `references/generated-files.md`.

### 4. Stop at the root cause
Do not keep digging once you know whether the issue is a bad dependency, a bad output path, or missing generated-file wiring.

## References
- [Binlog Generation](references/binlog-generation.md)
- [Binlog Analysis](references/binlog-analysis.md)
- [Output Path Clashes](references/output-path-clashes.md)
- [Generated Files](references/generated-files.md)

## Notes
- Use `microsoft-msbuild-performance` for slowness and timing questions.
