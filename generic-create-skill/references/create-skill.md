# Skill Template

Use this reference when creating or updating a Codex skill in this repository.

## Repository Rules

- Use a flat folder layout
- Name the folder in lowercase kebab-case
- Keep the folder name and frontmatter `name` identical
- Keep `SKILL.md` frontmatter limited to `name` and `description`
- Add `agents/openai.yaml`
- Put deeper material in `references/`

## Recommended Body Shape

1. `Goal`
2. `Use When`
3. `Workflow`
4. `References`
5. `Notes`

## Description Guidance

Write the description as the trigger text for the skill:

- Say when to use it
- Include the user problem or context
- Keep it short and searchable
- Avoid summarizing the whole workflow

## Combine or Split

Before creating a new skill, check whether the capability belongs in an existing umbrella skill. Combine skills when they serve the same intent and only differ by substep or reference material. Split skills when they solve different problems or are likely to be selected independently.

## Validation Checklist

- [ ] Folder name uses lowercase kebab-case
- [ ] Frontmatter `name` matches the folder name
- [ ] Frontmatter `description` is specific and trigger-focused
- [ ] `agents/openai.yaml` exists
- [ ] Body uses the repository section order
- [ ] Long examples or details live in `references/`
- [ ] README inventory is updated if the skill is added, removed, or renamed
