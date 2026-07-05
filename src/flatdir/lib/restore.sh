#!/usr/bin/env bash
set -euo pipefail

flatdir_restore() {
  flatdir_require_cmd fzf

  local archive_root
  archive_root="$(flatdir_archive_root)"

  [[ -d "$archive_root" ]] || flatdir_die "archive directory not found: $archive_root"

  # Use an absolute path string for bash -lc preview (avoid nested quoting issues)
  local common_sh
  common_sh="${FLATDIR_LIB_DIR}/common.sh"

  # Build fzf rows: "display\tarchive_dir\tdest"
  # - display: relative path for UI (rule depends on number of managed roots)
  # - archive_dir: actual directory under archive_root (full path)
  # - dest: restore destination (full path)
  local -a rows=()
  local marker
  while IFS= read -r marker; do
    [[ -n "$marker" ]] || continue

    local archive_dir rel dest display
    archive_dir="${marker%/.flatdir_archived}"
    [[ -d "$archive_dir" ]] || continue

    case "$archive_dir" in
      "$archive_root"/*) rel="${archive_dir#${archive_root}/}" ;;
      *) continue ;;
    esac

    dest="$(flatdir_abs_from_home_rel "$rel")"
    display="$(flatdir_display_path_for_dir "$dest")"

    rows+=("${display}"$'\t'"${archive_dir}"$'\t'"${dest}")
  done < <(find "$archive_root" -type f -name '.flatdir_archived' -print 2>/dev/null || true)

  if [[ ${#rows[@]} -eq 0 ]]; then
    flatdir_die "no archived directories found"
  fi

  local -a fzf_opts=(
    --height=60%
    --reverse
    --delimiter=$'\t'
    --with-nth=1
    --preview="bash -lc 'source \"$common_sh\"; flatdir_preview_exec_for_path \"\$1\"' _ {2}"
    --multi
    --bind=tab:toggle+down,shift-tab:toggle+up
    --header='Tab: select multiple  Enter: confirm'
  )

  local selection_lines
  selection_lines="$(
    printf '%s\n' "${rows[@]}" |
      fzf "${fzf_opts[@]}"
  )" || true

  [[ -n "$selection_lines" ]] || flatdir_die "no selection"

  local display archive_dir dest
  while IFS=$'\t' read -r display archive_dir dest; do
    [[ -n "$archive_dir" ]] || flatdir_die "internal error: empty selection"
    [[ -d "$archive_dir" ]] || flatdir_die "not a directory: $archive_dir"
    [[ -n "$dest" ]] || flatdir_die "internal error: empty dest"

    if [[ -e "$dest" ]]; then
      flatdir_die "restore destination exists: $dest"
    fi
  done <<<"$selection_lines"

  while IFS=$'\t' read -r display archive_dir dest; do
    [[ -n "$archive_dir" ]] || continue

    flatdir_run_cmd mkdir -p -- "$(dirname -- "$dest")"

    flatdir_safe_mv "$archive_dir" "$dest"
    flatdir_run_cmd rm -f -- "$dest/.flatdir_archived"
    echo "restored: $dest" >&2
  done <<<"$selection_lines"
}
