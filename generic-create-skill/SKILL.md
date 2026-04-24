---
name: generic-create-skill
description: Use when creating or updating a Codex skill so it matches this repository's naming, layout, and documentation conventions.
---

# Create Skill

## Goal
Use this skill to add or update a repository skill without drifting from the conventions in this repository.

## Use When
- You are creating a new skill folder
- You are editing an existing skill to match the repo standard
- You need to decide whether to combine a skill or keep it separate
- You want the skill to ship with the right `SKILL.md` structure and `agents/openai.yaml`

## Workflow
### 1. Check the repo conventions first
Read the root [README](../README.md) and follow the naming and structure rules there before writing anything new.

### 2. Decide whether the skill should exist
If the idea overlaps heavily with existing skills, prefer one umbrella skill plus `references/` files rather than another sibling skill.

### 3. Create the skill folder

Required layout:

```text
skill-name/
  SKILL.md
  agents/openai.yaml
  references/   # optional, for deeper material
  scripts/      # optional, for runnable helpers
  assets/       # optional, for templates or static files
```

### 4. Write the top-level `SKILL.md`

Keep the file consistent with the repo standard:

```yaml
---
name: skill-name
description: Use when ...
---
```

Body sections should follow this order:

1. `Goal`
2. `Use When`
3. `Workflow`
4. `References`
5. `Notes`

### 5. Add `agents/openai.yaml`

Keep the metadata concise and aligned to the folder name and skill intent. The default prompt should name the skill explicitly.

### 6. Move depth into references

Put long examples, sub-workflows, or detailed checklists under `references/` instead of bloating the top-level skill file.

### 7. Validate the result

- Folder name is lowercase kebab-case
- Frontmatter `name` matches the folder name
- Frontmatter has only `name` and `description`
- The description says when to use the skill
- `agents/openai.yaml` exists and matches the skill name
- The skill body follows the repo section order

## References
- [Skill Template](references/create-skill.md)

## Notes
- Use `generic-shared-agent-guidance` for repo-wide guidance, not single-skill scaffolding.
