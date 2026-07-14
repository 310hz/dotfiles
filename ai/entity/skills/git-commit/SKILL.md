---
name: git-commit
description: Create consistent Git commits by splitting changes into appropriate units and writing messages with an English prefix and Japanese description. Use when committing changes, proposing or revising commit messages, or deciding how to split changes across commits.
---

# Git Commit

## Create commits

1. Inspect the target diff and the repository's existing commit history.
2. Group changes into logical units that are meaningful and safe to revert independently.
3. Write a commit message for each unit according to the rules below.
4. Stage only the intended changes and review the staged diff before committing.
5. Do not include unrelated changes or modifications that belong to the user.

## Write messages

Use this format:

```text
<type>(<scope>): <Japanese summary>

<Japanese body, only when needed>
```

- Write `type` in lowercase English.
- Add `scope` only when it clarifies the affected area. Prefer lowercase English for it.
- Write the summary and body in Japanese. Preserve the original spelling of proper nouns, API names, and identifiers.
- Make the summary concrete and concise. Do not end it with a Japanese full stop.
- Omit the body when the summary communicates the intent sufficiently.
- When a body is necessary, explain the reason, background, constraints, or impact instead of narrating the implementation line by line.
- Mark a breaking change with `!`, then explain its impact and migration path in the body or footer.
- When linking an issue, add `Refs: #123` or `Closes: #123` at the end of the body.

## Choose a prefix

- `feat`: Add a user-visible feature.
- `fix`: Fix a defect.
- `docs`: Change documentation only.
- `refactor`: Improve code structure without changing behavior.
- `test`: Add or modify tests.
- `perf`: Improve performance.
- `style`: Change formatting or notation without affecting behavior.
- `build`: Change the build process or dependencies.
- `ci`: Change CI configuration or scripts.
- `chore`: Perform maintenance that does not fit another type.
- `revert`: Revert a previous commit.

Choose the single `type` that best represents the primary purpose. If multiple types are equally necessary, consider splitting the commit.

## Split commits

Changes may be split into multiple commits when the message would otherwise become complex or need to enumerate several purposes. Split them in particular when:

- An independent feature and bug fix are mixed together.
- A refactoring can be separated from a behavior change.
- Multiple unrelated areas are changed.
- Each change can be reviewed or reverted independently.

Keep inseparable implementation and tests for the same purpose in one commit. Order split commits so that each commit keeps the build and tests working whenever practical.

## Examples

```text
feat(auth): パスキーによるログインを追加
```

```text
fix(config): 未設定時に既定値が適用されない問題を修正

空文字列を設定済みとして扱っていたため、未設定判定を明示的に行う。
```
