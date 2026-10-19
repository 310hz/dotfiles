# flatdir only prints the chosen path; this defines the function that cd's into it.
# The function is owned by the flatdir project, so nothing about it is kept in this repo.
if command -v flatdir >/dev/null 2>&1; then
  eval "$(command flatdir shell)"
fi
