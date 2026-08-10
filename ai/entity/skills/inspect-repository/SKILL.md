---
name: inspect-repository
description: Inspect a cloned or local repository in read-only mode to explain its structure, implementation details, behavior, design intent, or experimental and algorithmic details omitted from an accompanying academic paper. Use when the user wants to understand repository contents, locate or explain a feature's implementation, investigate details through a paper's published code, or asks about capability or feasibility with questions such as "Can it do this?" or "Does it support this?" without explicitly requesting a change.
---

# Inspect Repository

Investigate primary sources in the repository and explain only what the user asked, concisely. Do not modify code or configuration unless the user explicitly requests a change.

## Investigation Workflow

1. Identify the user's specific question and the investigation target.
2. Establish the overall context from `AGENTS.md`, the README, manifests, and major directories.
3. Use `rg` and other read-only commands to narrow the investigation to relevant implementations, configuration, tests, documentation, and history.
4. Distinguish facts established by the code from inferences. Cite supporting files and line numbers whenever practical.
5. Lead with the conclusion and provide only the essential explanation. Add surrounding context or detail only when the user requests it.

For a repository accompanying an academic paper, do not rely on the paper alone. Inspect the implementation, defaults, configuration, data processing, evaluation code, and dependencies. Explicitly identify discrepancies between the paper and implementation, as well as details confirmed only by the code.

## Read-Only Boundary

- Keep the investigation read-only. Do not edit or generate files, format code, install dependencies, create commits, or write to external services.
- Treat questions such as "Can it do this?", "Does it support this?", and "How could this be done?" as requests to explain capability, current behavior, or feasibility. Do not implement anything in response.
- Make changes only when the user explicitly asks with language such as "implement", "write", "fix", "add", or an equivalent direct instruction.
- When it is unclear whether the user wants investigation or modification, make no changes and report the findings. If a change appears necessary, explain that and ask for confirmation.
- Avoid investigation commands that may create caches, build artifacts, lockfiles, or other repository changes. If execution is essential, explain the possible effects and obtain permission first.

## Response Guidelines

- Answer the user's specific question directly.
- By default, provide only the conclusion and its main evidence. Defer exhaustive explanation until requested.
- Do not present unverified claims as facts. Briefly state what was checked and what information is missing when the answer cannot be confirmed.
- Do not include patches or finished code unless the user requested a change. If useful, provide only a high-level implementation approach.
