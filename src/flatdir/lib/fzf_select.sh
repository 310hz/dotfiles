#!/usr/bin/env bash
set -euo pipefail

flatdir_fzf_select() {
  local multi=0
  if [[ "${1:-}" == "--multi" ]]; then
    multi=1
    shift
  fi

  flatdir_require_cmd fzf
  flatdir_require_cmd zoxide

  # collect depth1 dirs under all managed roots (full paths)
  local -a roots=()
  local root
  while IFS= read -r root; do
    [[ -n "$root" ]] || continue
    [[ -d "$root" ]] || flatdir_die "not a directory: $root"
    roots+=("$root")
  done < <(flatdir_dirs_array)

  if [[ ${#roots[@]} -eq 0 ]]; then
    flatdir_die "no directories found (did you run: flatdir track <path> ?)"
  fi

  # exclude hidden directories
  local sorted
  sorted="$(find "${roots[@]}" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -print | flatdir_sort_by_zoxide)"

  if [[ -z "$sorted" ]]; then
    flatdir_die "no directories found (did you run: flatdir track <path> ?)"
  fi

  # build fzf rows: "display\tfullpath"
  # - display: root-relative if one managed root, else HOME-relative (see flatdir_display_path_for_dir)
  # - fullpath: used for preview + stdout
  local rows prefix
  if [[ ${#roots[@]} -eq 1 ]]; then
    prefix="${roots[0]%/}/"
  else
    prefix="${HOME%/}/"
  fi
  rows="$(awk -v prefix="$prefix" '
    { d = (index($0, prefix) == 1) ? substr($0, length(prefix) + 1) : $0; printf "%s\t%s\n", d, $0 }
  ' <<<"$sorted")"

  local -a fzf_opts=(
    --height=60%
    --reverse
    --delimiter=$'\t'
    --with-nth=1
    --preview="bash -lc 'source \"$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh\"; flatdir_preview_exec_for_path \"\$1\"' _ {2}"
  )

  if [[ "$multi" -eq 1 ]]; then
    fzf_opts+=(
      --multi
      --bind=tab:toggle+down,shift-tab:toggle+up
      --header='Tab: select multiple  Enter: confirm'
    )
  fi

  local selection_lines
  selection_lines="$(
    printf '%s\n' "$rows" |
      fzf "${fzf_opts[@]}"
  )" || true

  # align with wrapper usage: on cancel, print nothing and return success.
  if [[ -z "$selection_lines" ]]; then
    return 0
  fi

  # stdout must be full path (2nd field)
  printf '%s\n' "$selection_lines" | cut -f2-
}
