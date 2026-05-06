---
name: generic-project-planning
description: Use when a complex plan should be captured in a repo-root `.plan/<plan-name>/` folder with `open-questions.md` and numbered step files.
---

# Goal
Capture a complex plan as a concise repo-local workspace that tells an agent exactly what to do.

# Use When
- The work has multiple phases, dependencies, or unknowns.
- The plan needs to persist outside chat.
- You need separate files for questions and executable steps.

# Workflow
1. Identify the repository root and create `.plan/` there if it does not already exist.
2. Create a subfolder for the specific plan using a concise lowercase kebab-case name.
3. Write `.plan/<plan-name>/open-questions.md` first. List only unresolved questions there.
4. Mark each question with a status:
   - `🟢` resolved
   - `🟡` not blocking implementation, but a production blocker or follow-up remains
   - `🔴` blocks starting implementation
5. Create one markdown file per step, using zero-padded numeric prefixes such as `01-`, `02-`, and `03-` so the files sort in execution order.
6. Put a `Current state:` line near the top of every numbered step file.
7. Give every step file exactly two sections:
   - `## Plan` for the step, its dependencies, its output, and its completion criteria
   - `## Findings / Outcome` for blockers, decisions, or a short recap of work completed
8. Update the plan files in place as scope changes, but keep numbering stable unless the sequence itself changes.
9. If the request is still underspecified, add the gap to `open-questions.md` instead of inventing details.

# References
- [Plan Layout](references/plan-layout.md)

# Notes
- Use ASCII filenames and lowercase kebab-case for folders.
- Put question statuses only in `open-questions.md`.
- Put lifecycle states only in numbered step files.
- `Current state:` uses `🆕` brand new, `🔵` in progress, `🟡` follow-up needed, `🔴` blocked, `🟢` ready, and `✅` completed.
- If a plan is small and simple, skip the file scaffold and answer directly.
