---
name: uv-vcs-versioning
description: Configure or review dynamic versioning for a Python library managed with uv, using Git tags as the only manually maintained version source. Use when working with Hatchling, hatch-vcs, dynamic project metadata, package __version__, or version-related pyproject.toml settings.
---

# uv VCS Versioning

Derive the package version from Git tags through `hatch-vcs`.

## Policy

* Treat Git tags as the only manually maintained version source.
* Do not define `[project].version`.
* Do not use `uv version` to update the version.
* Do not hard-code version strings in source files.
* Read `__version__` from installed distribution metadata.
* Use tags in the form `v<PEP 440 version>`.

## Procedure

### 1. Identify the distribution name

Use `[project].name` as the distribution name.

Do not confuse the distribution name with the import package name.

Example:

```text
Distribution name: my-package
Import package: my_package
```

### 2. Configure `pyproject.toml`

```toml
[build-system]
requires = ["hatchling", "hatch-vcs"]
build-backend = "hatchling.build"

[project]
name = "my-package"
dynamic = ["version"]

[tool.hatch.version]
source = "vcs"
tag-pattern = "^v(?P<version>.+)$"
```

Replace `my-package` with the actual distribution name.

Remove an existing `[project].version` field.

Do not replace an existing build backend without checking compatibility. This configuration applies to projects using Hatchling.

### 3. Expose `__version__`

Add the following to the top-level package’s `__init__.py`:

```python
from importlib.metadata import version

__version__ = version("my-package")
```

The argument to `version()` must exactly match `[project].name`.

Do not use `version(__package__)`. `version()` accepts a distribution name, not an import package name.

## Version examples

At tag:

```text
v0.1.0 → 0.1.0
```

After additional commits:

```text
0.1.1.dev3+gabcdef1
```

The exact development-version format depends on `hatch-vcs` and `setuptools-scm` configuration. Do not write code that depends on that format.

## Development assumptions

`importlib.metadata.version()` reads installed distribution metadata.

Install the project into the uv environment instead of importing it only through `PYTHONPATH`:

```bash
uv sync
```

Verify the resolved version:

```bash
uv run python -c "import my_package; print(my_package.__version__)"
```

## Review checklist

* `[project].version` is absent.
* `[project].dynamic` contains `"version"`.
* `hatchling` and `hatch-vcs` are build requirements.
* `[tool.hatch.version].source` is `"vcs"`.
* `version()` receives the exact `[project].name`.
* No version string is duplicated in source code.
* Static version updates are not mixed with Git-tag-based versioning.
