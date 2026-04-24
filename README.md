# Skill Inventory

This inventory excludes `.system/` because those skills are application-managed and ignored by Git.
Skill folders are flat and use `microsoft-` for Microsoft-related skills or `generic-` for vendor-neutral ones.

## Repository Conventions

### Naming

- Use lowercase kebab-case for every skill folder.
- Prefix Microsoft-related skills with `microsoft-`.
- Prefix vendor-neutral skills with `generic-`.
- Keep the folder name, `SKILL.md` frontmatter `name`, and generated metadata aligned.

### Skill Structure

- Every repo-managed skill should have `SKILL.md` and `agents/openai.yaml`.
- Keep `SKILL.md` frontmatter limited to `name` and `description`.
- Write `description` as the primary trigger text and say when the skill should be used.
- Use a consistent body shape: `Goal`, `Use When`, `Workflow`, `References`, and `Notes`.
- Put reusable documentation in `references/`, helper code in `scripts/`, and output assets in `assets/`.
- Keep `agents/openai.yaml` concise, user-facing, and explicit about the skill by name.

### Validation

- Make sure the folder name, frontmatter `name`, and `agents/openai.yaml` metadata all match.
- Remove placeholder text before treating a skill as complete.
- Prefer focused skills over broad catch-all skills.

### Combine vs Split

- Combine skills when they serve the same user intent and only differ by substep, branch, or reference material.
- Keep skills separate when they solve different problems, use different tools, or are likely to be selected independently.
- Use one umbrella skill plus `references/` files when the agent would otherwise need to compare several sibling skills before acting.
- Keep the top-level skill short and route details into subreferences when the shared workflow is obvious.
- Good combine candidates are workflows like discovery plus creation, baseline plus tuning, or docs plus code samples.
- Good separate candidates are workflows that look related but answer different questions, such as performance tuning versus bug investigation.

## Repo-Managed Skills

- `generic-create-skill`
- `generic-figma`
- `generic-pdf`
- `generic-project-planning`
- `generic-prototype-app`
- `generic-shared-agent-guidance`
- `generic-tdd-bug-fixing`
- `microsoft-analyzing-dotnet-performance`
- `microsoft-azure-devops-mcp`
- `microsoft-azure-observability`
- `microsoft-azure-pipelines-modular`
- `microsoft-clr-activation-debugging`
- `microsoft-convert-to-cpm`
- `microsoft-csharp-edit-hygiene`
- `microsoft-csharp-scripts`
- `microsoft-directory-build-organization`
- `microsoft-docx`
- `microsoft-dotnet-template-workflow`
- `microsoft-dotnet-trace-collect`
- `microsoft-msbuild-antipatterns`
- `microsoft-msbuild-modernization`
- `microsoft-msbuild-performance`
- `microsoft-msbuild-troubleshooting`
- `microsoft-nuget-trusted-publishing`
- `microsoft-optimizing-ef-core-queries`
- `microsoft-reference-lookup`
- `microsoft-run-tests`
- `microsoft-thread-abort-migration`
