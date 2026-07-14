---
name: planning
description: Create an implementation-ready plan from instruction.md. Use when Codex must investigate and clarify a requested product or change, then write deterministic planning documents under agents/docs/plans/ without implementing it.
---

# Planning

Produce a plan from `instruction.md` that requires no material design decisions from its implementer. Plan only; do not implement.

## Process

1. Use the user-specified project root or the current directory. Read `instruction.md`, applicable `AGENTS.md`, and existing `agents/docs/`. Ask which `instruction.md` is authoritative if missing or ambiguous.
2. Inspect relevant code, tests, manifests, configuration, schemas, and documentation. Identify current behavior and exact integration points. Thoroughly research every required technical and non-technical domain using primary sources, research papers, official standards, and other authoritative publications. Do not rely on unsupported general knowledge.
3. Convert abstract ideas into concrete proposed behavior, scope, data flow, failures, and acceptance criteria. For a comparatively large change, divide the work into user-review checkpoints: each task must be small enough for the user to verify before implementation proceeds to the next task.
4. Ask the user to decide every material ambiguity. Present evidence, alternatives, tradeoffs, and a recommendation. Never silently decide product behavior, scope, compatibility, security, privacy, migration, public interfaces, or acceptance criteria.
5. Repeat research and questioning until every material requirement is confirmed or explicitly out of scope. If anything remains unresolved, stop with a clearly marked draft; never call it implementation-ready.
6. Write and validate the planning documents below.

## Output

Write under `agents/docs/plans/` unless project instructions specify otherwise:

```text
plan.md
status.md
tasks/01-<name>.md
tasks/02-<name>.md
```

### `plan.md`

Include:

- objective, confirmed requirements, constraints, and non-goals;
- repository findings with exact paths and symbols;
- chosen design, data/control flow, interfaces, validation, errors, and state;
- persistence, migration, compatibility, rollout, and rollback when applicable;
- decisions, rationale, rejected alternatives, risks, and mitigations;
- task dependency order, user-review checkpoints, test strategy, acceptance criteria, and external sources;
- an explicit statement that no material questions remain.

### `status.md`

Initially, write only that implementation has not started and there is no progress to report. Add confirmed decisions, task progress, blockers, and the next action only after implementation begins.

### `tasks/*.md`

Create one file per independently verifiable implementation unit. Tasks exist so the user can inspect the implementation after each unit, not merely to organize work. The implementation workflow must stop after each task, present its results and verification evidence, and wait for the user's confirmation before beginning the next task.

Specify:

- prerequisites and dependencies;
- exact files and symbols to change;
- ordered implementation steps;
- interfaces, invariants, edge cases, and failures;
- tests, verification commands, expected results, and acceptance criteria;
- a user-facing verification procedure, including any setup or test data required;
- the concrete points the user should inspect, including behavior, output, UI, logs, files, or state as applicable;
- one or more task-specific verification scripts or equivalent reproducible tools that the implementation must add or update when practical. Give their exact paths, commands, inputs, expected output, and cleanup procedure. If automation is not practical, explain why and provide an exact manual verification checklist instead;
- a completion handoff that tells the implementer what evidence to show the user and explicitly requires user confirmation before the next task starts.

Use numeric prefixes for execution order and identify dependency relationships. Do not schedule implementation tasks to run in parallel when doing so would bypass a user-review checkpoint. For a small change, keep the complete procedure in `plan.md` and omit empty task scaffolding.

## Completion Gate

Before declaring the plan ready, verify:

- every instruction maps to a requirement, task, or non-goal;
- every task maps to a confirmed requirement;
- every non-final task ends at a meaningful user-review checkpoint and requires confirmation before the next task;
- every task provides a reproducible way for the user to verify it and states exactly what the user should inspect;
- paths, symbols, commands, and dependencies match the repository;
- no placeholders, assumptions, unresolved choices, or vague directions remain;
- independent implementers can produce equivalent behavior without inventing decisions.
