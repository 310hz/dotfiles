convert-all() {
  if (( $# < 2 )); then
    printf 'usage: convert-all <pattern> <extension> [ffmpeg options...]\n' >&2
    return 2
  fi

  local pattern="$1"
  local extension="${2#.}"
  shift 2

  local -a files
  files=( ${~pattern}(N.) )

  if (( ${#files} == 0 )); then
    printf 'convert-all: no files matched: %s\n' "$pattern" >&2
    return 1
  fi

  local input output
  for input in "${files[@]}"; do
    output="${input:r}.${extension}"
    ffmpeg -i "$input" "$@" "$output" || return
  done
}

alias convert-all='noglob convert-all'
