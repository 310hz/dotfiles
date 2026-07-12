---
name: python-coding-rules
description: Rules and best practices for Python coding. Always refer to this when coding in Python.
---

# Python Coding Rules

- Use `pathlib` for all path management. Do not use `os.path` or `glob.glob`.
- Follow the prefixes below for path-related variable names:
    - File path: fpath
    - File name: fname
    - Directory path: dpath
    - Directory name: dname
- Variable names should follow the `abstract_concrete` format.
    - This makes it easier to read when multiple related variables are listed together. Example: dpath_dataset, dpath_output, fpath_config
- Use `typer` for managing command-line arguments. Ensure that help display with `-h` is enabled.

```
CONTEXT_SETTINGS = dict(help_option_names=["-h", "--help"])
app = typer.Typer(add_completion=False, context_settings=CONTEXT_SETTINGS)
```

- Keep line length to 79 characters, and 72 characters for comments, etc.
- When writing long strings, use `()` effectively to keep them within 79 characters as shown below.

```
@app.command()
def main(
    api_key: str = typer.Option(
        None,
        "--api-key", "-k",
        help=(
            "API key for authentication. Defaults to the value of the "
            "OPENROUTER_API_KEY environment variable."
        ),
    ),
):
```
