#!/usr/bin/env bash
set -euo pipefail

# dependencies
# shellcheck source=lib/fzf_select.sh
source "${FLATDIR_LIB_DIR}/fzf_select.sh"

flatdir_remove() {
  # select directories from managed roots (depth 1) then delete them
  local targets target

  targets="$(flatdir_fzf_select --multi)"

  [[ -n "$targets" ]] || flatdir_die "no selection"

  while IFS= read -r target; do
    [[ -n "$target" ]] || continue
    [[ -d "$target" ]] || flatdir_die "not a directory: $target"
  done <<<"$targets"

  while IFS= read -r target; do
    [[ -n "$target" ]] || continue
    flatdir_safe_rm "$target"
  done <<<"$targets"
}
