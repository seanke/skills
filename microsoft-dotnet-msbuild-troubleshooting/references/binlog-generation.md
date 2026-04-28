# Binlog Generation

Use a binary log whenever you need to inspect an MSBuild build after the fact.

## Commands That Should Capture a Binlog

- `dotnet build`
- `dotnet test`
- `dotnet pack`
- `dotnet publish`
- `dotnet restore`
- `msbuild` or `msbuild.exe`

## Preferred Pattern

Use a unique filename so repeated builds do not overwrite each other:

```bash
dotnet build /bl:build.binlog
```

On newer MSBuild versions, the `{}` placeholder can generate unique names automatically. PowerShell needs brace escaping.

## Why It Matters

- Failure analysis works best when the trace is already captured
- You can compare runs before and after a fix
- You avoid rerunning a failed build just to get evidence

If you already have a binlog, move to `references/binlog-analysis.md`.
