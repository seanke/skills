---
name: microsoft-azure-pipelines-modular
description: "Design, refactor, or review Azure DevOps `azure-pipelines.yml` to use modular stages, job templates, and step templates. Use when standardizing CI/CD YAML, extracting reusable templates, or aligning pipeline structure across multiple apps/environments in any repository."
---

# Azure Pipelines Modular

## Goal
Use this skill for Modular Azure Pipelines design.

## Use When
- Design, refactor, or review Azure DevOps `azure-pipelines.yml` to use modular stages, job templates, and step templates. Use when standardizing CI/CD YAML, extracting reusable templates, or aligning pipeline structure across multiple apps/environments in any repository

## Workflow
1. Inspect existing pipeline files.
- Locate the root `azure-pipelines.yml` and any referenced templates.
- Map stages -> jobs -> steps and identify duplicated logic.

2. Extract reusable templates.
- Convert repeated step sequences into step templates.
- Convert repeated job patterns into job templates.
- Use parameters for variable paths, environments, and service connections.

3. Standardize stage flow.
- Keep stage names consistent (`Build`, `Test`, `DeployDev`, `DeployProd`).
- Use `dependsOn` and branch conditions for promotion gates.

4. Keep it generic.
- Replace product names, subscriptions, and organization-specific identifiers with placeholders.
- Use neutral naming like `serviceConnectionName`, `environment`, `workingDirectory`.

5. Validate outputs.
- Ensure templates accept required parameters.
- Ensure template paths are correct.
- Keep secrets in variable groups or service connections, never in YAML.

### Output Patterns
Use these patterns unless the repo already enforces alternatives:
- Root pipeline orchestrates stages and references templates.
- Job templates encapsulate deploy or test workflows.
- Step templates encapsulate component build/test sequences.

For detailed examples and naming conventions, see `references/azure-pipelines-patterns.md`.

## References
- `references/azure-pipelines-patterns.md`

## Notes
- No additional notes.
