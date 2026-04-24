---
name: generic-shared-agent-guidance
description: "Set up or refactor repo-level guidance so Codex and Claude Code share one canonical source via root AGENTS.md, .agents/skills, and CLAUDE.md imports. Use when creating shared agent instructions, migrating from .codex layouts, or cleaning up duplicated guidance across coding agents."
---

# Shared Agent Guidance

## Goal
Use this skill for Shared repo agent guidance.

## Use When
- Set up or refactor repo-level guidance so Codex and Claude Code share one canonical source via root AGENTS.md, .agents/skills, and CLAUDE.md imports. Use when creating shared agent instructions, migrating from .codex layouts, or cleaning up duplicated guidance across coding agents

## Workflow
### Canonical Layout
- Put repo-wide instructions in root `AGENTS.md`.
- Put reusable repo skills in `.agents/skills/<skill-name>/SKILL.md`.
- Put Claude Code imports in root `CLAUDE.md`.
- Keep agent-specific wrapper files thin. They should point at the shared source of truth instead of duplicating it.

Example `CLAUDE.md` imports:

```md
@AGENTS.md
@.agents/skills/customer-invoices/SKILL.md
@.agents/skills/integration-flow/SKILL.md
```

### New Repo Setup
1. Create a root `AGENTS.md` with the repo instructions Codex should always read.
2. Create `.agents/skills/<skill-name>/SKILL.md` for each reusable repo workflow.
3. Add a root `CLAUDE.md` that imports `AGENTS.md` and the shared skill files.
4. Keep the canonical text in one place. Avoid parallel `docs/agent-guidance`, `.codex`, or other duplicate instruction trees.
5. Verify Codex can discover the skills natively from `.agents/skills`.
6. Verify Claude Code loads the same guidance through `CLAUDE.md` imports.

### Refactoring An Existing Repo
When a repo already has `.codex`, `.claude`, or duplicate guidance folders:

1. Move the canonical instruction text into root `AGENTS.md` and `.agents/skills`.
2. Update `CLAUDE.md` so it imports the shared files instead of carrying a second copy of the same guidance.
3. Keep any temporary bridge files only until the shared layout is validated.
4. Remove the old duplicate trees once both agents can read the shared source successfully.
5. If the repo already has a different instruction file, adapt that file into the new shared layout rather than keeping both as competing sources of truth.
6. If skills are duplicated across folders, keep one canonical copy and make the other paths thin bridges only during migration.

## References
- No bundled reference files or helper directories.

## Notes
- Codex sees the repo skills directly from `.agents/skills`.
- Claude Code sees the same content through `CLAUDE.md`.
- The repo has no stale duplicate guidance trees left in source control unless it intentionally keeps them.
- The layout change preserved behavior before deleting the old files.

### Keep It Tight
- Prefer one canonical instruction file per concern.
- Use thin bridges only when another agent cannot read the canonical files natively.
- Refactor by moving the canonical content first, then repointing the loaders, then deleting the old copies.
