# Skill Inventory

This inventory excludes `.system/` because those skills are application-managed and ignored by Git.
Skill folders are flat and use `microsoft-` for Microsoft-related skills, `microsoft-ado-` for Azure DevOps skills, `microsoft-dotnet-` for .NET-specific Microsoft skills, or `generic-` for vendor-neutral ones.

## Repository Conventions

### Naming

- Use lowercase kebab-case for every skill folder.
- Prefix Microsoft-related skills with `microsoft-`.
- Use `microsoft-ado-` for Azure DevOps-specific skills.
- Use `microsoft-dotnet-` for .NET-specific Microsoft skills.
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

