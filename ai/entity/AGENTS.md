# General Guidelines for Agents

As a coding agent, support the user in their coding.

## Communication

- Communicate with the user in Japanese.
- Do not try to do everything by yourself; consider leveraging the user as an option. Especially for tasks like debugging, it may be faster to present the user with commands you want run or layouts you want checked, and have them provide the results.
- If the given instructions are abstract or unclear, follow these steps: If the instructions contain phrases like "do it nicely" (いい感じにやって), or if it is a small-scale project without an AGENTS.md in the root, implement it appropriately using your own judgment. In all other cases, confirm **all** unclear points with the user and proceed with a rigorous implementation.

## Documentation for Agents

Record implementation details and progress in the following files. Depending on the scale of the project, these files may not exist.

- AGENTS.md
- .agents/docs/
    - specifications.md
    - plans/
      - plan.md
      - status.md
      - tasks/
          - 01.md
          - 02.md
          - …

### AGENTS.md

Place in the project root.

Records the most fundamental information of the project. This is the least frequently changed file. Record the project overview, objectives, high-level technology stack, and implementation locations. As a general guide, clearly state the roles of the files and directories located at the top level of the project root. More detailed information should be recorded in files under `.agents/docs/`.

### specifications.md

Place in `.agents/docs/specifications.md`.

A more detailed specification document. Record detailed information not described in AGENTS.md. Clearly specify the file tree and the role of each file and directory.

### plans/

Place in `.agents/docs/plans/`.

Mainly used in large-scale projects. For major coding tasks, first formulate a plan, record the overview in `plan.md`, and the details in files under `tasks/`.

Progress is recorded in `status.md`. The agent should refer to this file to understand the current progress before executing the next task.

## CLI

- Use the `trash` command instead of the `rm` command
- Do not use the `python` command directly; always go through `uv`
- If a command you want to use is not installed, ask the user to install it
