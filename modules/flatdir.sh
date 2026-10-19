# flatdir only prints the chosen path; a program cannot cd its parent shell.
# Same text as `flatdir shell`, written out so shell startup does not run the binary.
flatdir() {
  local out
  out="$(command flatdir "$@")" || return
  [ -z "$out" ] && return
  if [ "$#" -eq 0 ] && [ -d "$out" ]; then
    cd "$out"
  else
    printf '%s\n' "$out"
  fi
}
