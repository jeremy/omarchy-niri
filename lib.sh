OMARCHY_NIRI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
omarchy_wm() { echo "${OMARCHY_WM:-hyprland}"; }
is_niri() { [[ "$(omarchy_wm)" == "niri" ]]; }
