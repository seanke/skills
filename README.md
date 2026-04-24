# Skill Inventory

This inventory excludes `.system/` because those skills are application-managed and ignored by Git.
Skill folders are flat and use `microsoft-` for Microsoft-related skills or `generic-` for vendor-neutral ones.

## Repository Conventions

### Ordering

- Keep the inventory sorted by score from lowest to highest so the weakest skills are easiest to find first.
- When scores tie, sort by skill folder name.
- Keep skill folders flat; do not reintroduce nested skill folders for skills themselves.
- Leave `.system/` out of the tracked inventory because those skills are application-managed.

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

The scores below are a heuristic 1-10 quality rating based on:

- frontmatter quality
- consistent body structure
- bundled resources and `agents/openai.yaml` coverage
- placeholder hygiene and supporting detail

Lower scores are the first cleanup targets.

## Score Distribution

- 10: 26

## Inventory

| Skill | Score |
| --- | ---: |
| generic-create-skill | 10 |
| generic-figma | 10 |
| generic-pdf | 10 |
| generic-shared-agent-guidance | 10 |
| generic-tdd-bug-fixing | 10 |
| microsoft-analyzing-dotnet-performance | 10 |
| microsoft-azure-devops-mcp | 10 |
| microsoft-azure-observability | 10 |
| microsoft-azure-pipelines-modular | 10 |
| microsoft-clr-activation-debugging | 10 |
| microsoft-convert-to-cpm | 10 |
| microsoft-csharp-edit-hygiene | 10 |
| microsoft-csharp-scripts | 10 |
| microsoft-directory-build-organization | 10 |
| microsoft-docx | 10 |
| microsoft-dotnet-template-workflow | 10 |
| microsoft-dotnet-trace-collect | 10 |
| microsoft-msbuild-antipatterns | 10 |
| microsoft-msbuild-modernization | 10 |
| microsoft-msbuild-performance | 10 |
| microsoft-msbuild-troubleshooting | 10 |
| microsoft-nuget-trusted-publishing | 10 |
| microsoft-optimizing-ef-core-queries | 10 |
| microsoft-reference-lookup | 10 |
| microsoft-run-tests | 10 |
| microsoft-thread-abort-migration | 10 |
