---
name: manage-python-version
description: Configure and maintain Git-tag-driven versioning for Python packages using uv, hatchling, hatch-vcs, and importlib.metadata, with optional PyPI publishing through GitHub Actions. Use when creating or migrating a Python package so build metadata, the package __version__ attribute, and Git tags cannot drift; when optionally adding automated tag-triggered publishing; or when diagnosing inconsistent or incorrect package versions.
---

# Manage Python Version

Use the Git tag as the sole version source. Derive build metadata and the runtime
`__version__` from it instead of maintaining duplicate version strings.

Treat PyPI publishing and GitHub Actions release automation as optional. Complete
the version-management setup without them unless the user asks to publish the
package or automate releases.

## Inspect the project

1. Read the repository instructions before changing files.
2. Confirm that the project is a distributable Python package managed by uv.
3. Inspect `pyproject.toml`, `uv.lock`, the import package, the distribution name,
   and existing tags. Inspect release workflows only when publishing or release
   automation is in scope.
4. Stop and explain the incompatibility instead of silently replacing another
   intentional versioning system such as Poetry, PDM, setuptools-scm, or a custom
   release tool.
5. Preserve unrelated build settings and workflow behavior.

Distinguish the distribution name in `[project].name` from the import package
name. They may differ because distribution names normalize hyphens and
underscores.

## Configure tag-derived build metadata

Edit `pyproject.toml` so the build backend reads the version from Git:

```toml
[build-system]
requires = ["hatchling", "hatch-vcs"]
build-backend = "hatchling.build"

[project]
name = "distribution-name"
dynamic = ["version"]

[tool.hatch.version]
source = "vcs"
```

Remove the static `[project].version` field. If `[project].dynamic` already
contains other fields, retain them and add `"version"` once. Retain required
Hatch build-target configuration, especially package path declarations for a
`src/` layout.

Use release tags in the form `vMAJOR.MINOR.PATCH`, for example `v1.4.2`. Do not
write the same version into another tracked file. Let hatch-vcs create PEP 440
development versions for commits after a release tag.

Run `uv lock` after changing the build requirements when the project tracks
`uv.lock`.

## Expose the installed version

Define `__version__` in the import package's `__init__.py` by querying installed
distribution metadata:

```python
from importlib.metadata import PackageNotFoundError, version

try:
    __version__ = version("distribution-name")
except PackageNotFoundError:
    __version__ = "0.0.0"
```

Replace `distribution-name` with the exact `[project].name`. Use an explicit
fallback so source-tree imports have a defined value. Do not derive it from
`__package__` when the distribution and import names can differ.

## Optionally automate PyPI releases

Skip this section unless the user asks to publish to PyPI or automate package
publishing. Tag-derived version management does not require PyPI, GitHub Actions,
or a public package registry.

Create or adapt `.github/workflows/release.yml` to:

- Trigger only on tags matching `v*`.
- Check out the full Git history and tags with `fetch-depth: 0` and
  `fetch-tags: true`.
- Install uv with the repository's established action and version-pinning
  convention.
- Run the project's required tests and checks before publishing when they are
  already defined.
- Run `uv build`, then `uv publish`.
- Grant `id-token: write` and use PyPI Trusted Publishing; do not add a long-lived
  PyPI token.

Before writing action versions, inspect the existing repository configuration
and current official action documentation. Preserve immutable SHA pinning when
the repository uses it.

Publishing is an external side effect. Configure and validate the workflow, but
do not create or push a tag, publish a GitHub Release, configure PyPI, or run
`uv publish` unless the user explicitly requests that action.

## Validate

Perform the applicable checks:

1. Run the repository's format, lint, type-check, and test commands.
2. Run `uv lock --check` when `uv.lock` is tracked.
3. Run `uv build` from a repository with tag history available.
4. Inspect the wheel and sdist filenames and confirm they contain the expected
   tag-derived version.
5. Inspect built metadata or install the wheel into an isolated environment and
   confirm `package.__version__` equals the distribution metadata version.
6. When release automation is in scope, review the workflow syntax and confirm
   checkout is not shallow.

Do not assume an untagged commit will have the next clean release version. Expect
a PEP 440 development version containing distance and commit information. Never
publish such a local version to PyPI.

## Optional PyPI release procedure

Skip this section for projects that only need version management. When the user
explicitly authorizes a PyPI release:

1. Require a clean, tested release commit.
2. Choose the intended semantic version with the user if it was not specified.
3. Create the annotated or lightweight tag according to repository convention.
4. Push that exact tag.
5. Monitor the release workflow and verify the published PyPI version.

Treat a tag as immutable. If a release fails after publication, create a new
patch version instead of moving or overwriting the published tag.
