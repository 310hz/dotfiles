---
name: onboarding
description: Inspect a project and create missing agent documentation at the project root.
---

# Initialize Agent Docs

Create only the missing agent documentation after deriving its contents from the actual project.

## Workflow

1. Treat the current project or the user-specified directory as the project root.
2. Check for `AGENTS.md` and `.agents/docs/specifications.md` before writing anything.
3. If both files exist, report that no initialization is needed and make no changes.
4. Inspect enough of the project to write accurate documentation:
   - Read existing instruction and documentation files that apply to the project.
   - List top-level files and directories, including hidden configuration files when relevant.
   - Inspect package manifests, lockfiles, build configuration, entry points, and representative source and test files.
   - Use evidence from the repository; do not invent objectives, commands, technologies, or file roles.
5. Create parent directories only when required.
6. Create each missing file using `apply_patch`. Never overwrite or rewrite an existing target file.
7. Re-read the created files and verify that paths, commands, and descriptions agree with the repository.
8. Report which files were created and which existing files were preserved.

## `AGENTS.md` Content

Keep this file concise and stable. Include:

- Project overview and observable objective.
- High-level technology stack supported by manifests or source files.
- Main implementation, test, configuration, and documentation locations.
- Roles of top-level files and directories that contributors need to navigate the project.
- Essential project-specific commands only when verified from repository configuration or existing documentation.

State uncertainty explicitly when the repository does not establish an intended objective. Do not add speculative product requirements or generic coding advice.

## `specifications.md` Content

Write `.agents/docs/specifications.md` as the detailed companion to `AGENTS.md`. Include:

- Current behavior and architecture observable in the codebase.
- A structured file tree covering relevant files and directories, with a role for each entry.
- Entry points, important modules, data flow, external interfaces, configuration, persistence, and tests when present.
- Known gaps or ambiguities only when supported by inspection.

Describe the project as it exists. Do not turn inferred future work into a committed specification.

## Safety Rules

- Preserve all existing files, including partially populated target documents.
- Do not initialize planning files unless the user explicitly requests them.
- Do not modify application code, configuration, dependencies, or generated artifacts.
- Follow any existing instructions with narrower scope.
- Ask the user only when a material ambiguity cannot be resolved by inspecting the project; otherwise use conservative, evidence-based wording.
