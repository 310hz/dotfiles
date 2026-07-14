# General Guidelines for Agents

As a coding agent, support the user's coding.

## Communication

- Communicate with the user in Japanese.
- If no specific instructions are sent, refer to `instruction.md` or `agents/docs/plans/status.md`.
- Do not try to complete everything by yourself; consider leveraging the user as an option. Especially for debugging, it is often faster to present the user with commands you want them to run or layouts you want them to check, and have them provide you with the results.
- If the given instructions are abstract or unclear, follow these steps: If the instructions contain phrases like "do it nicely" (いい感じにやって), or if it is a small-scale project without an `AGENTS.md` in the root, implement it nicely at your own discretion. Otherwise, clarify **all** unclear points with the user and proceed with a strict implementation.

## Documentation for Agents

Record implementation details and progress in the following files. Depending on the scale of the project, they may not exist.

```
- AGENTS.md
- agents/docs/
    - specifications.md
    - plans/
      - plan.md
      - status.md
      - tasks/
          - 01.md
          - 02.md
          - …
```

### AGENTS.md

Placed in the project root.

Records the most fundamental information of the project. This is the least frequently changed file. Record the project overview, objectives, general technology stack, and implementation locations. As a guideline, clearly specify the roles of files and directories located at the top level of the project root. More detailed information should be recorded in files under `agents/docs/`.

### specifications.md

Placed in `agents/docs/specifications.md`.

A more detailed specification document. Record detailed information not described in `AGENTS.md`. Clearly specify the file tree and the roles of each file and directory.

### plans/

Placed in `agents/docs/plans/`.

Mainly used in large-scale projects. For major coding tasks, first make a plan, and record the outline in `plan.md` and the details in files under `tasks/`.

Record the progress in `status.md`. The agent should refer to this file to understand the progress before executing the next task.

## CLI

- Use the `trash` command instead of the `rm` command.
- Do not use the `python` command directly; always go through `uv`.
- If a command you want to use is not installed, ask the user to install it.
