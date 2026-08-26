convert-all-gif() {
  if (( $# < 1 )); then
    printf 'usage: convert-all-gif <pattern> [--fps <fps>] [--width <pixels>] [--speed <rate>] [--no|--yes] [ffmpeg options...]\n' >&2
    return 2
  fi

  local pattern="$1"
  local fps=15
  local width=
  local speed=1
  local overwrite=
  shift

  local -a ffmpeg_options
  while (( $# > 0 )); do
    case "$1" in
      --fps)
        if (( $# < 2 )); then
          printf 'convert-all-gif: --fps requires a value\n' >&2
          return 2
        fi
        fps="$2"
        shift 2
        ;;
      --width)
        if (( $# < 2 )); then
          printf 'convert-all-gif: --width requires a value\n' >&2
          return 2
        fi
        width="$2"
        shift 2
        ;;
      --speed)
        if (( $# < 2 )); then
          printf 'convert-all-gif: --speed requires a value\n' >&2
          return 2
        fi
        speed="$2"
        shift 2
        ;;
      --no)
        overwrite=-n
        shift
        ;;
      --yes)
        overwrite=-y
        shift
        ;;
      --)
        shift
        ffmpeg_options+=( "$@" )
        break
        ;;
      *)
        ffmpeg_options+=( "$1" )
        shift
        ;;
    esac
  done

  if [[ ! "$fps" =~ '^[0-9]+([.][0-9]+)?$' ]] || (( fps <= 0 )); then
    printf 'convert-all-gif: --fps must be a positive number: %s\n' "$fps" >&2
    return 2
  fi
  if [[ -n "$width" ]] && { [[ ! "$width" =~ '^[0-9]+$' ]] || (( width <= 0 )); }; then
    printf 'convert-all-gif: --width must be a positive integer: %s\n' "$width" >&2
    return 2
  fi
  if [[ ! "$speed" =~ '^[0-9]+([.][0-9]+)?$' ]] || (( speed <= 0 )); then
    printf 'convert-all-gif: --speed must be a positive number: %s\n' "$speed" >&2
    return 2
  fi

  local -a files
  files=( ${~pattern}(N.) )

  if (( ${#files} == 0 )); then
    printf 'convert-all-gif: no files matched: %s\n' "$pattern" >&2
    return 1
  fi

  local filter="setpts=PTS/${speed},fps=${fps}"
  if [[ -n "$width" ]]; then
    filter+=",scale=${width}:-1:flags=lanczos"
  fi
  filter+=',split[gif][palette];[palette]palettegen[palette_out];[gif][palette_out]paletteuse'

  local input output
  for input in "${files[@]}"; do
    output="${input:r}.gif"
    ffmpeg ${overwrite:+"$overwrite"} -i "$input" -filter_complex "$filter" "${ffmpeg_options[@]}" "$output" || return
  done
}

alias convert-all-gif='noglob convert-all-gif'
