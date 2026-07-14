---
name: planning
description: Create an implementation-ready plan from instruction.md. Use when Codex must investigate and clarify a requested product or change, then write deterministic planning documents under agents/docs/plans/ without implementing it.
---

# Planning

Produce a plan from `instruction.md` that requires no material design decisions from its implementer. Plan only; do not implement.

## Process

1. Use the user-specified project root or the current directory. Read `instruction.md`, applicable `AGENTS.md`, and existing `agents/docs/`. Ask which `instruction.md` is authoritative if missing or ambiguous.
2. Inspect relevant code, tests, manifests, configuration, schemas, and documentation. Identify current behavior and exact integration points. Thoroughly research every required technical and non-technical domain using primary sources, research papers, official standards, and other authoritative publications. Do not rely on unsupported general knowledge.
3. Convert abstract ideas into concrete proposed behavior, scope, data flow, failures, and acceptance criteria.
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
- task dependency order, test strategy, acceptance criteria, and external sources;
- an explicit statement that no material questions remain.

### `status.md`

Initially, write only that implementation has not started and there is no progress to report. Add confirmed decisions, task progress, blockers, and the next action only after implementation begins.

### `tasks/*.md`

Create one file per independently verifiable implementation unit. Specify:

- prerequisites and dependencies;
- exact files and symbols to change;
- ordered implementation steps;
- interfaces, invariants, edge cases, and failures;
- tests, verification commands, expected results, and acceptance criteria.

Use numeric prefixes for execution order and identify parallel tasks. For a small change, keep the complete procedure in `plan.md` and omit empty task scaffolding.

## Completion Gate

Before declaring the plan ready, verify:

- every instruction maps to a requirement, task, or non-goal;
- every task maps to a confirmed requirement;
- paths, symbols, commands, and dependencies match the repository;
- no placeholders, assumptions, unresolved choices, or vague directions remain;
- independent implementers can produce equivalent behavior without inventing decisions.
