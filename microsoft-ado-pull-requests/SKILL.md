---
name: microsoft-ado-pull-requests
description: Use when Codex needs to create, read, inspect, update, comment on, or resolve Azure DevOps/Azure Repos pull requests using deterministic scripts instead of ad hoc REST or Azure CLI commands.
---

# Microsoft ADO Pull Requests

## Goal
Use this skill to handle Azure DevOps pull request work through checked helper scripts that build the REST calls consistently, support dry-run output for writes, and avoid guessing endpoint shapes.

## Use When
- Create a draft Azure DevOps PR from source and target branches.
- Read one PR, list repo PRs, or inspect PR review threads/comments.
- Update PR metadata such as title, description, status, target branch, auto-complete, merge options, or completion options.
- Add PR-level comments, add inline comments when the caller has line/tracking context, or resolve/update review thread status.
- You need repeatable ADO PR automation and want to test request payloads before live writes.

## Workflow
### 1. Resolve context first
Prefer explicit parameters for organization, project, and repository. If they are not supplied, the scripts try `ADO_ORG`, `ADO_PROJECT`, `ADO_REPOSITORY`, then parse `git remote.origin.url`.

For live calls, authenticate with one of:
- `ADO_PAT` or `AZURE_DEVOPS_EXT_PAT` for PAT/basic auth.
- `ADO_BEARER_TOKEN` or `SYSTEM_ACCESSTOKEN` for bearer auth.
- `-AuthMode GitCredential` to ask Git Credential Manager for the Azure Repos credential associated with the resolved remote.
- Azure CLI fallback via `az account get-access-token` for the Azure DevOps resource.

### 2. Dry-run before writing
Run every create, update, comment, or thread-status change with `-DryRun` first. Inspect the method, URL, and JSON body, then rerun with `-ConfirmLiveWrite` only when the target PR and payload are correct.

### 3. Use the scripts by action
- Read/list: `scripts/Get-AdoPullRequest.ps1`
- Create: `scripts/New-AdoPullRequest.ps1`
- Edit PR metadata: `scripts/Update-AdoPullRequest.ps1`
- Add PR comments or replies: `scripts/Add-AdoPullRequestComment.ps1`
- Edit review thread status: `scripts/Set-AdoPullRequestThreadStatus.ps1`

For create operations, use `scripts/New-AdoPullRequest.ps1`. Do not create PRs through the Azure DevOps UI, `az repos pr create`, MCP calls, custom REST calls, or another script unless the user explicitly overrides this skill. This script is the enforcement point for draft-only PR creation, dry-run output, and browser-link output.

### 4. Validate locally after edits
Run `scripts/Test-AdoPrScripts.ps1` after changing this skill. It parses every PowerShell script and exercises dry-run create, read, update, comment, and thread-status paths without network access.

### 5. Always surface the PR link
Every script output that targets or returns a specific PR must include `pullRequestWebUrl`. Put that link in the final response whenever using this skill so the user can open the exact PR that was read, created, updated, commented on, or resolved.

### 6. Treat live writes as state changes
Never create, abandon, complete, retarget, comment on, or resolve a PR unless the user asked for that specific live action. If the request is exploratory, stop at read-only calls or dry-run output.

### 7. Always create draft PRs
`New-AdoPullRequest.ps1` must always send `isDraft: true`. After a live create, it must read the created PR back and verify that Azure DevOps reports `isDraft: true` before reporting success. If ADO returns `isDraft: false` or omits the value, treat the action as failed and report the PR link so the user can inspect the non-draft PR immediately. Do not add a non-draft creation path to this skill; PRs should be promoted out of draft manually or by an explicit later update.

## References
- [ADO PR REST notes](references/ado-pr-rest.md)

## Notes
- REST calls use Azure DevOps Git API `api-version=7.1`.
- Prefer the `pullRequestWebUrl` field over REST API `url` fields when reporting the PR to the user.
- New PR creation is intentionally draft-only and must be verified from ADO's stored PR state.
- Branch arguments can be `main`, `feature/x`, or full refs such as `refs/heads/main`; scripts normalize branch names before sending them.
- Inline comment creation can require Azure DevOps iteration and change-tracking context. If that context is unknown, create a PR-level comment or read threads/iterations first instead of inventing line metadata.
