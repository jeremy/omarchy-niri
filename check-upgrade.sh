#!/bin/bash
set -euo pipefail

# Check for omarchy scripts that use Hyprland-specific tools but don't have niri wrappers.
# Run after omarchy-update to detect drift.

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OMARCHY_BIN="$HOME/.local/share/omarchy/bin"
NIRI_BIN="$REPO/bin"

# Hyprland-specific tools that won't work under Niri
HYPR_PATTERN='hyprctl|hypridle|hyprlock|hyprsunset|hyprpicker|hyprpaper|hyprland-ipc'

# Find all omarchy scripts that reference any Hyprland-specific tool
mapfile -t hypr_scripts < <(grep -rlE "$HYPR_PATTERN" "$OMARCHY_BIN" 2>/dev/null | sort)

missing=()
changed=()

for script in "${hypr_scripts[@]}"; do
  name=$(basename "$script")
  wrapper="$NIRI_BIN/$name"

  if [[ ! -f "$wrapper" ]]; then
    missing+=("$name")
  fi
done

# Check if existing wrappers' originals have changed (new hypr calls added)
for wrapper in "$NIRI_BIN"/omarchy-*; do
  [[ -f "$wrapper" ]] || continue
  name=$(basename "$wrapper")
  original="$OMARCHY_BIN/$name"

  [[ -f "$original" ]] || continue

  original_calls=$(grep -cE "$HYPR_PATTERN" "$original" 2>/dev/null || true)
  wrapper_sources_lib=$(grep -c 'lib.sh' "$wrapper" 2>/dev/null || true)

  if [[ "$wrapper_sources_lib" -gt 0 && "$original_calls" -gt 0 ]]; then
    original_hypr=$(grep -E "$HYPR_PATTERN" "$original" 2>/dev/null | sed 's/^[[:space:]]*/  /')
    changed+=("$name|$original_calls|$original_hypr")
  fi
done

echo "═══ omarchy-niri upgrade check ═══"
echo ""

if [[ ${#missing[@]} -eq 0 ]]; then
  echo "No new omarchy scripts with Hyprland-specific calls found."
else
  echo "MISSING WRAPPERS — these omarchy scripts use Hyprland tools but have no niri wrapper:"
  echo ""
  for name in "${missing[@]}"; do
    calls=$(grep -cE "$HYPR_PATTERN" "$OMARCHY_BIN/$name" 2>/dev/null || true)
    tools=$(grep -oE "$HYPR_PATTERN" "$OMARCHY_BIN/$name" 2>/dev/null | sort -u | paste -sd, -)
    echo "  $name ($calls calls: $tools)"
    grep -E "$HYPR_PATTERN" "$OMARCHY_BIN/$name" 2>/dev/null | sed 's/^[[:space:]]*/    /'
    echo ""
  done
fi

echo ""
echo "EXISTING WRAPPERS — verify these still cover all Hyprland calls in their originals:"
echo ""
for entry in "${changed[@]}"; do
  IFS='|' read -r name count calls <<< "$entry"
  echo "  $name ($count Hyprland calls in original)"
done

echo ""
echo "Wrapper scripts: $(ls "$NIRI_BIN"/omarchy-* 2>/dev/null | wc -l)"
echo "Omarchy scripts with Hyprland tools: ${#hypr_scripts[@]}"
echo "Scanning for: ${HYPR_PATTERN//|/, }"
