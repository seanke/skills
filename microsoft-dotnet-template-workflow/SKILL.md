---
name: microsoft-dotnet-template-workflow
description: Use when creating a .NET project from a template and you may need discovery or instantiation guidance.
---

# .NET Template Workflow

## Goal
Use this skill to move from template selection to project creation without switching between separate skills.

## Use When
- The user wants a new .NET project, app, or solution
- You need to compare templates before creating one
- You need to preview the files a template would create
- The workspace may use Central Package Management or other existing conventions

## Workflow
### 1. Decide whether this is discovery or instantiation

| Symptom | Open |
| --- | --- |
| Need to compare templates or understand parameters | `references/discovery.md` |
| Need to create a project from a chosen template | `references/instantiation.md` |

### 2. Prefer dry-run before creation
If the user has not asked for raw creation yet, preview the template output first and make sure the result matches the workspace shape.

### 3. Create and verify
After creation, add the new project to the solution if needed and run a build.

## References
- [Template Discovery](references/discovery.md)
- [Template Instantiation](references/instantiation.md)

## Notes
- If the user is authoring a custom template rather than using one, use a different skill.
