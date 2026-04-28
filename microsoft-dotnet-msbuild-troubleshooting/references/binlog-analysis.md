# Binlog Analysis

Use this when you need to replay a `.binlog` into searchable text and find the real failure.

## Replay

```bash
dotnet msbuild build.binlog -noconlog -fl -flp:v=diag;logfile=full.log;performancesummary
```

You can also separate errors and warnings into dedicated files if that is easier to scan.

## What To Search For

- The first real error, not the cascade after it
- `CoreCompile` failures versus dependency failures
- Missing imports, package downgrades, and version conflicts
- Which project actually failed first

## Stop Early

Once you know the root cause, stop. Build failure analysis is about the first actionable failure, not about reading every line in the log.

If the failure is about file placement or generated files, move to the matching reference file.
