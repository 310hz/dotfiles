---
name: git-commit

description: Create consistent Git commits by splitting changes into logical units and writing messages with an English prefix and Japanese description. Use when committing changes, proposing or revising commit messages, or deciding how to split changes.
---

# Git Commit

## Create commits

1. Inspect the target diff and existing commit history.
2. Split changes into logical units that can be reviewed and reverted independently.
3. Stage only the intended changes and review the staged diff before committing.
4. Do not include unrelated or user-owned changes.
5. Write each commit message according to the rules below.

## Write messages

Use this format:

```text
<type>(<scope>): <Japanese summary>

<Japanese body, only when needed>
````

* Write `type` in lowercase English.
* Add `scope` only when it clarifies the affected area. Prefer lowercase English.
* Write the summary and body in Japanese, preserving proper nouns, API names, and identifiers.
* Keep the summary concrete and concise. Do not end it with `。`.
* Omit the body unless it adds useful context such as reason, background, constraints, or impact.
* Mark breaking changes with `!` and explain the impact and migration path.
* Add `Refs: #123` or `Closes: #123` when linking an issue.

## Choose a prefix

* `feat`: Add a user-visible feature.
* `fix`: Fix a defect.
* `docs`: Documentation only.
* `refactor`: Change structure without changing behavior.
* `test`: Add or modify tests.
* `perf`: Improve performance.
* `style`: Formatting or notation only.
* `build`: Build process or dependencies.
* `ci`: CI configuration or scripts.
* `chore`: Maintenance not covered above.
* `revert`: Revert a previous commit.

Choose the single `type` that best represents the commit. If multiple types are equally necessary, split the changes.

## Split commits

Split changes when:

* Independent features and fixes are mixed.
* Refactoring can be separated from behavior changes.
* Unrelated areas are changed.
* Changes can be reviewed or reverted independently.

Keep implementation and tests for the same purpose together. Order commits so each keeps the build and tests working whenever practical.

## Examples

```text
feat(auth): パスキーによるログインを追加
```

```text
fix(config): 未設定時に既定値が適用されない問題を修正

空文字列を設定済みとして扱っていたため、未設定判定を明示的に行う。
```

```
