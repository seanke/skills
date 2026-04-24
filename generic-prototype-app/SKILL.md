---
name: generic-prototype-app
description: Use when the workspace should start empty and the user wants to prototype a new web app by initializing git, scaffolding a React + Tailwind + TypeScript project, creating a private GitHub repo, and optionally publishing to GitHub Pages.
---

# Prototype App

## Goal
Turn an empty folder into a new web app prototype, then optionally push it to a private GitHub repository and publish it with GitHub Pages.

## Use When
- The user says the workspace should start from a clean, empty folder
- The user wants a new app prototype instead of editing an existing codebase
- The user wants React, Tailwind, and TypeScript as the starting stack
- The user wants GitHub repo creation and push workflow handled as part of the setup
- The user may want GitHub Pages deployment after the prototype exists

## Workflow
### 1. Verify the workspace is clean
- Confirm the current folder is empty enough to bootstrap.
- If existing project files are present, stop and ask the user to move to a clean folder.
- Do not overwrite unrelated work.

### 2. Collect the minimum inputs
- Ask for the GitHub project/repo name before creating the remote.
- Ask whether the repo should live under the user’s personal account or an organization.
- Ask whether the app should be published to GitHub Pages.
- If the user wants Pages, explicitly note that the site will be public.
- Ask about any non-default needs that change the starter shape, such as backend, auth, database, routing, or a component library.

### 3. Bootstrap the app
- Initialize git in the empty folder.
- Default to Vite + React + TypeScript + Tailwind unless the workspace already standardizes on another setup.
- Keep the first scaffold small, working, and easy to extend.
- Add the minimum useful project files: app shell, styling setup, `.gitignore`, and a brief README.
- Install dependencies and run the first build or lint pass before moving on.

### 4. Create and connect GitHub
- Create a private GitHub repository under the user’s identity unless they request otherwise.
- Commit the initial scaffold before pushing.
- Push the branch and set upstream tracking.
- Help the user verify the repo URL and basic push status.

### 5. Optional GitHub Pages
- Only enable Pages after explicit approval.
- If approved, add a GitHub Actions workflow that builds and deploys the app.
- Enable GitHub Pages on the repository and push the workflow.
- State clearly that GitHub Pages content is public, even if the repository remains private.

### 6. Build the prototype
- Implement the user’s requested screens and interactions in small increments.
- Keep the prototype lightweight and easy to modify.
- Ask before adding backend services, authentication, persistence, or other infrastructure.

## References
- [Decision Points](references/decision-points.md)

## Notes
- Default stack: Vite + React + TypeScript + Tailwind
- Default package manager: npm unless the workspace already uses something else
- Default branch: `main`
- Default repository visibility: private
- Default deployment choice: no GitHub Pages until the user opts in
- If the user wants a different frontend stack, treat that as a separate decision before scaffolding
