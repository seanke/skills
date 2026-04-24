# MSBuild Server

Use this when command-line builds feel slower than IDE builds or when you want to reset the persistent build server.

## Commands

```bash
dotnet build-server status
dotnet build-server shutdown
```

Shut the server down after SDK changes, custom task changes, or stale build behavior. Then rebuild so the server warms up again.

## When This Helps

- CLI builds repeatedly pay startup cost
- You changed build tooling and want a clean process
- You suspect stale in-memory state is affecting repeated builds

If the issue is not startup overhead, move to `references/performance-diagnostics.md` or `references/incremental-build.md`.
