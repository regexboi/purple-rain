#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_DIR="$ROOT_DIR/codex-app"
STATE_FILE="${CODEX_HOME:-$HOME/.codex}/.codex-global-state.json"
CODEX_PROCESS_PATTERN='/Applications/Codex.app/Contents/MacOS/Codex'
CODEX_HELPER_PATTERN='/Applications/Codex.app/Contents/Frameworks/Codex Helper'
CODEX_APP_SERVER_PATTERN='/Applications/Codex.app/Contents/Resources/codex app-server'
THEME_SURFACE='#1a0533'
TITLE_COLOR='#ffffff'
COLOR_ENABLED=0
PICKED_THEME_FILE=""
NAME_COL_WIDTH=28
BG_COL_WIDTH=22
ACCENT_COL_WIDTH=20
TEXT_COL_WIDTH=18

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  COLOR_ENABLED=1
fi

usage() {
  cat <<EOF
Set the active Codex app theme from the Purple Rain presets.

Usage:
  ./scripts/set-codex-theme.sh
  ./scripts/set-codex-theme.sh --list
  ./scripts/set-codex-theme.sh <theme-name|path-to-theme>

Examples:
  ./scripts/set-codex-theme.sh purple-rain-classic
  ./scripts/set-codex-theme.sh codex-app/purple-rain-neon-royale.theme
EOF
}

is_codex_running() {
  pgrep -f "$CODEX_PROCESS_PATTERN" >/dev/null 2>&1 \
    || pgrep -f "$CODEX_HELPER_PATTERN" >/dev/null 2>&1 \
    || pgrep -f "$CODEX_APP_SERVER_PATTERN" >/dev/null 2>&1
}

wait_for_codex_stop() {
  local attempt=0

  while is_codex_running && [[ $attempt -lt 20 ]]; do
    sleep 0.5
    attempt=$((attempt + 1))
  done
}

stop_codex() {
  pkill -KILL -f "$CODEX_PROCESS_PATTERN" >/dev/null 2>&1 || true
  pkill -KILL -f "$CODEX_HELPER_PATTERN" >/dev/null 2>&1 || true
  pkill -KILL -f "$CODEX_APP_SERVER_PATTERN" >/dev/null 2>&1 || true

  wait_for_codex_stop

  if is_codex_running; then
    echo "Unable to stop Codex before applying the theme." >&2
    exit 1
  fi
}

start_codex() {
  open -a Codex >/dev/null 2>&1 || true
}

theme_group() {
  case "$1" in
    purple-rain-classic|purple-rain-frostbite|purple-rain-gold-flash|purple-rain-laser-lemon)
      echo "High readability"
      ;;
    purple-rain-aurora-mint|purple-rain-blue-hour|purple-rain-cyan-surge|purple-rain-lavender-haze|purple-rain-sunset-spark|purple-rain-ultraviolet)
      echo "Balanced neon"
      ;;
    purple-rain-cotton-candy|purple-rain-neon-mix|purple-rain-neon-royale|purple-rain-orchid-ice)
      echo "Max chaos"
      ;;
    *)
      echo "Other"
      ;;
  esac
}

describe_theme() {
  case "$1" in
    purple-rain-aurora-mint)
      echo "purple background, mint accents, electric blue text"
      ;;
    purple-rain-blue-hour)
      echo "purple background, electric blue accents, bright pink text"
      ;;
    purple-rain-classic)
      echo "purple background, neon pink accents, lavender text"
      ;;
    purple-rain-cotton-candy)
      echo "purple background, bright pink accents, yellow text"
      ;;
    purple-rain-cyan-surge)
      echo "purple background, neon cyan accents, bright pink text"
      ;;
    purple-rain-frostbite)
      echo "purple background, bright cyan accents, lavender text"
      ;;
    purple-rain-gold-flash)
      echo "purple background, yellow accents, electric blue text"
      ;;
    purple-rain-laser-lemon)
      echo "purple background, laser yellow accents, lavender text"
      ;;
    purple-rain-lavender-haze)
      echo "purple background, vivid purple accents, mint text"
      ;;
    purple-rain-neon-mix)
      echo "purple background, neon pink accents, cyan text"
      ;;
    purple-rain-neon-royale)
      echo "purple background, vibrant purple accents, cyan text"
      ;;
    purple-rain-orchid-ice)
      echo "purple background, bright pink accents, bright cyan text"
      ;;
    purple-rain-sunset-spark)
      echo "purple background, coral accents, yellow text"
      ;;
    purple-rain-ultraviolet)
      echo "purple background, indigo accents, mint text"
      ;;
    *)
      echo "purple background, custom Purple Rain variant"
      ;;
  esac
}

theme_names() {
  find "$THEME_DIR" -maxdepth 1 -type f -name '*.theme' -print \
    | sed "s|$THEME_DIR/||" \
    | sed 's/\.theme$//' \
    | sort
}

theme_file_path() {
  printf '%s/%s.theme\n' "$THEME_DIR" "$1"
}

theme_json_for_name() {
  local raw_theme

  raw_theme="$(tr -d '\n' < "$(theme_file_path "$1")")"
  printf '%s\n' "${raw_theme#codex-theme-v1:}"
}

theme_value() {
  local name="$1"
  local jq_path="$2"

  jq -r "$jq_path" <<< "$(theme_json_for_name "$name")"
}

hex_rgb_triplet() {
  local hex="${1#\#}"
  printf '%d;%d;%d' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

color_name() {
  case "$1" in
    '#1a0533')
      echo "deep purple"
      ;;
    '#69ffab')
      echo "mint"
      ;;
    '#59b8ff')
      echo "electric blue"
      ;;
    '#ff59d6')
      echo "neon pink"
      ;;
    '#ff8de6')
      echo "bright pink"
      ;;
    '#00e5ff')
      echo "cyan"
      ;;
    '#5cefff')
      echo "bright cyan"
      ;;
    '#ffda45')
      echo "yellow"
      ;;
    '#b44dff')
      echo "vivid purple"
      ;;
    '#7b5eff')
      echo "indigo"
      ;;
    '#ff6b8a')
      echo "coral"
      ;;
    '#a78bfa')
      echo "lavender"
      ;;
    '#e8e0f0')
      echo "soft lavender"
      ;;
    *)
      echo "$1"
      ;;
  esac
}

color_text() {
  local hex="$1"
  local text="$2"

  if [[ "$COLOR_ENABLED" -eq 1 ]]; then
    printf '\033[38;2;%sm%s\033[0m' "$(hex_rgb_triplet "$hex")" "$text"
  else
    printf '%s' "$text"
  fi
}

color_bg_text() {
  local bg_hex="$1"
  local fg_hex="$2"
  local text="$3"

  if [[ "$COLOR_ENABLED" -eq 1 ]]; then
    printf '\033[48;2;%sm\033[38;2;%sm%s\033[0m' \
      "$(hex_rgb_triplet "$bg_hex")" \
      "$(hex_rgb_triplet "$fg_hex")" \
      "$text"
  else
    printf '%s' "$text"
  fi
}

warning_text() {
  local text="$1"

  if [[ "$COLOR_ENABLED" -eq 1 ]]; then
    printf '\033[1;31m%s\033[0m' "$text"
  else
    printf '%s' "$text"
  fi
}

warning_accent_text() {
  local text="$1"

  if [[ "$COLOR_ENABLED" -eq 1 ]]; then
    printf '\033[1;33m%s\033[0m' "$text"
  else
    printf '%s' "$text"
  fi
}

pad_text() {
  local width="$1"
  local text="$2"
  printf '%-*s' "$width" "$text"
}

print_table_header() {
  printf '  %-3s | %-*s | %-*s | %-*s | %-*s\n' \
    'No.' \
    "$NAME_COL_WIDTH" 'Theme' \
    "$BG_COL_WIDTH" 'Background' \
    "$ACCENT_COL_WIDTH" 'Accent' \
    "$TEXT_COL_WIDTH" 'Text'
  printf '  %s-+-%s-+-%s-+-%s-+-%s\n' \
    '---' \
    "$(printf '%*s' "$NAME_COL_WIDTH" '' | tr ' ' '-')" \
    "$(printf '%*s' "$BG_COL_WIDTH" '' | tr ' ' '-')" \
    "$(printf '%*s' "$ACCENT_COL_WIDTH" '' | tr ' ' '-')" \
    "$(printf '%*s' "$TEXT_COL_WIDTH" '' | tr ' ' '-')"
}

print_theme_row() {
  local number="$1"
  local name="$2"
  local accent
  local ink
  local surface_name
  local accent_name
  local ink_name
  local name_cell
  local bg_cell
  local accent_cell
  local ink_cell

  accent="$(theme_value "$name" '.theme.accent')"
  ink="$(theme_value "$name" '.theme.ink')"
  surface_name="$(color_name "$THEME_SURFACE")"
  accent_name="$(color_name "$accent")"
  ink_name="$(color_name "$ink")"
  name_cell="$(pad_text "$NAME_COL_WIDTH" "$name")"
  bg_cell="$(pad_text "$BG_COL_WIDTH" "$surface_name")"
  accent_cell="$(pad_text "$ACCENT_COL_WIDTH" "$accent_name")"
  ink_cell="$(pad_text "$TEXT_COL_WIDTH" "$ink_name")"

  printf '  %3d | ' "$number"
  color_text "$TITLE_COLOR" "$name_cell"
  printf ' | '
  color_text "$THEME_SURFACE" "$bg_cell"
  printf ' | '
  color_text "$accent" "$accent_cell"
  printf ' | '
  color_text "$ink" "$ink_cell"
  printf '\n'
}

print_grouped_themes() {
  local all_names=()
  local line
  local group
  local number=1
  local printed_group=0

  while IFS= read -r line; do
    all_names[${#all_names[@]}]="$line"
  done < <(theme_names)

  for group in "High readability" "Balanced neon" "Max chaos" "Other"; do
    printed_group=0
    for line in "${all_names[@]}"; do
      [[ "$(theme_group "$line")" == "$group" ]] || continue
      if [[ "$printed_group" -eq 0 ]]; then
        printf '%s:\n' "$group"
        print_table_header
        printed_group=1
      fi
      print_theme_row "$number" "$line"
      number=$((number + 1))
    done
    if [[ "$printed_group" -eq 1 ]]; then
      printf '\n'
    fi
  done
}

list_themes() {
  print_grouped_themes
}

resolve_theme_file() {
  local input="$1"

  if [[ -f "$input" ]]; then
    printf '%s\n' "$input"
    return 0
  fi

  if [[ -f "$ROOT_DIR/$input" ]]; then
    printf '%s\n' "$ROOT_DIR/$input"
    return 0
  fi

  if [[ "$input" != *.theme && -f "$THEME_DIR/$input.theme" ]]; then
    printf '%s\n' "$THEME_DIR/$input.theme"
    return 0
  fi

  if [[ -f "$THEME_DIR/$input" ]]; then
    printf '%s\n' "$THEME_DIR/$input"
    return 0
  fi

  return 1
}

pick_theme_interactively() {
  local theme_names=()
  local line
  local selection
  local selected_name
  local confirm
  local number=1
  local group
  local printed_group=0
  local numbered_names=()

  while IFS= read -r line; do
    theme_names[${#theme_names[@]}]="$line"
  done < <(theme_names)

  if [[ ${#theme_names[@]} -eq 0 ]]; then
    echo "No theme files found in $THEME_DIR"
    exit 1
  fi

  warning_text '============================================================'
  printf '\n'
  warning_accent_text 'WARNING: THIS WILL FORCE KILL CODEX AND STOP ANY PENDING JOBS'
  printf '\n'
  warning_text '============================================================'
  printf '\n'
  printf '%s\n' 'Available Codex themes:'

  for group in "High readability" "Balanced neon" "Max chaos" "Other"; do
    printed_group=0
    for line in "${theme_names[@]}"; do
      [[ "$(theme_group "$line")" == "$group" ]] || continue
      if [[ "$printed_group" -eq 0 ]]; then
        printf '%s:\n' "$group"
        print_table_header
        printed_group=1
      fi
      print_theme_row "$number" "$line"
      numbered_names[$number]="$line"
      number=$((number + 1))
    done
    if [[ "$printed_group" -eq 1 ]]; then
      printf '\n'
    fi
  done

  printf 'Pick a theme number: '
  read -r selection

  if [[ -z "$selection" ]]; then
    echo "No theme selected."
    exit 1
  fi

  if [[ "$selection" =~ ^[0-9]+$ ]]; then
    if [[ "$selection" -lt 1 || "$selection" -ge "$number" ]]; then
      echo "Invalid theme number: $selection"
      exit 1
    fi

    selected_name="${numbered_names[$selection]}"
    printf '\n'
    printf 'Apply %s? Codex will restart and interrupt any running threads or automations. [y/N]: ' "$selected_name"
    read -r confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "Theme change cancelled."
      exit 1
    fi

    PICKED_THEME_FILE="$(resolve_theme_file "$selected_name")"
    return 0
  fi

  if ! PICKED_THEME_FILE="$(resolve_theme_file "$selection")"; then
    echo "Theme not found: $selection"
    exit 1
  fi
}

if [[ ! -f "$STATE_FILE" ]]; then
  echo "Codex state file not found: $STATE_FILE" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but was not found in PATH." >&2
  exit 1
fi

if [[ $# -gt 1 ]]; then
  usage >&2
  exit 1
fi

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--list" ]]; then
  list_themes
  exit 0
fi

THEME_FILE=""

if [[ $# -eq 1 ]]; then
  if ! THEME_FILE="$(resolve_theme_file "$1")"; then
    echo "Theme not found: $1" >&2
    exit 1
  fi
else
  pick_theme_interactively
  THEME_FILE="$PICKED_THEME_FILE"
fi

RAW_THEME="$(tr -d '\n' < "$THEME_FILE")"
PREFIX="codex-theme-v1:"

if [[ "$RAW_THEME" != "$PREFIX"* ]]; then
  echo "Theme file is missing the codex-theme-v1 prefix: $THEME_FILE" >&2
  exit 1
fi

THEME_JSON="${RAW_THEME#$PREFIX}"
TMP_FILE="$(mktemp)"
WAS_RUNNING=0

if is_codex_running; then
  WAS_RUNNING=1
  echo "Codex is running. Restarting it to apply the new theme..." >&2
  stop_codex
fi

jq --argjson theme "$THEME_JSON" '
  .appearanceDarkCodeThemeId = $theme.codeThemeId
  | .appearanceDarkChromeTheme = $theme.theme
  | ."electron-persisted-atom-state" |= (
    .appearanceDarkCodeThemeId = $theme.codeThemeId
    | .appearanceDarkChromeTheme = $theme.theme
  )
' "$STATE_FILE" > "$TMP_FILE"

mv "$TMP_FILE" "$STATE_FILE"

if [[ "$WAS_RUNNING" -eq 1 ]]; then
  start_codex
fi

echo "Applied Codex theme:"
echo "  $(basename "$THEME_FILE" .theme)"
echo
echo "Updated:"
echo "  $STATE_FILE"

if [[ "$WAS_RUNNING" -eq 1 ]]; then
  echo
  echo "Codex was restarted to load the new theme."
fi
