---
name: microsoft-azure-devops-mcp
description: "Install, configure, and use the Azure DevOps MCP server in Codex or VS Code. Use when an agent needs to bring up the server, connect to an Azure DevOps organization, list projects or work items, choose MCP domains, or troubleshoot startup and auth issues."
---

# Azure DevOps MCP

## Goal
Use this skill for Azure DevOps MCP setup and use.

## Use When
- Install, configure, and use the Azure DevOps MCP server in Codex or VS Code. Use when an agent needs to bring up the server, connect to an Azure DevOps organization, list projects or work items, choose MCP domains, or troubleshoot startup and auth issues

## Workflow
### Fast Path
1. If `mcp__ado_*` tools are already available in the current session, use them directly.
2. If the tools are not available, add the server to the global client config.
3. Prefer the narrow domain set `core`, `work`, `work-items` unless you need more.
4. Verify the setup by listing projects first, then work items.

### Codex Config
Add this to `~/.codex/config.toml`:

```toml
[mcp_servers.ado]
command = "npx"
args = ["-y", "@azure-devops/mcp@next", "<ADO_ORG>", "-d", "core", "work", "work-items"]
```

Use `@azure-devops/mcp` instead of `@azure-devops/mcp@next` if you want the stable release.

### VS Code Config
If the target client is VS Code, use `mcp.json`:

```json
{
  "inputs": [
    {
      "id": "ado_org",
      "type": "promptString",
      "description": "Azure DevOps organization name"
    }
  ],
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp@next", "${input:ado_org}", "-d", "core", "work", "work-items"]
    }
  }
}
```

### Verify Connectivity
1. Call the project listing tool first.
2. Use the exact project name returned by the server.
3. Call the assigned-work-items tool for that project.
4. Use the batch work-item tool when you need titles, states, and assignees.

## References
- No bundled reference files or helper directories.

## Notes
- If `npx` fails on cache or permissions, point npm at a writable cache directory and retry.
- If the server prompts for auth, sign in with the account that belongs to the target org.
- If a tool name is unclear, list tools first rather than guessing.
- If startup is slow, keep the domain list small and restart the client after config changes.
