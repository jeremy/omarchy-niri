#!/bin/bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDDM_CONF="/etc/sddm.conf.d/autologin.conf"

echo "Installing omarchy-niri from $REPO..."
echo ""

# Expand templates (replace @@HOME@@ and @@REPO@@ with actual paths)
expand_template() {
  local tmpl="$1"
  local out="${tmpl%.tmpl}"
  sed -e "s|@@HOME@@|$HOME|g" -e "s|@@REPO@@|$REPO|g" "$tmpl" > "$out"
  echo "  Generated $out"
}

echo "Expanding templates:"
expand_template "$REPO/config/niri/config.kdl.tmpl"
expand_template "$REPO/config/swaylock/config.tmpl"
echo ""

# Config symlinks
ln -sfn "$REPO/config/niri"                ~/.config/niri
ln -sfn "$REPO/config/swaylock"            ~/.config/swaylock
ln -sfn "$REPO/config/xdg-desktop-portal"  ~/.config/xdg-desktop-portal

# Omarchy extensions symlink (menu overrides)
mkdir -p ~/.config/omarchy/extensions
ln -sf "$REPO/extensions/menu.sh"          ~/.config/omarchy/extensions/menu.sh

# Environment for Niri session (sets OMARCHY_WM=niri when launched via UWSM)
mkdir -p ~/.config/environment.d
echo "OMARCHY_WM=niri" > ~/.config/environment.d/omarchy-niri.conf

echo "Symlinks created:"
echo "  ~/.config/niri -> $REPO/config/niri"
echo "  ~/.config/swaylock -> $REPO/config/swaylock"
echo "  ~/.config/xdg-desktop-portal -> $REPO/config/xdg-desktop-portal"
echo "  ~/.config/omarchy/extensions/menu.sh -> $REPO/extensions/menu.sh"
echo "  ~/.config/environment.d/omarchy-niri.conf (OMARCHY_WM=niri)"
echo ""

# SDDM session configuration
if [[ -f "$SDDM_CONF" ]] && grep -q "Session=" "$SDDM_CONF"; then
  current_session=$(grep "^Session=" "$SDDM_CONF" | head -1 | cut -d= -f2)

  if [[ "$current_session" == "niri" ]]; then
    echo "SDDM autologin already set to Niri."
  else
    echo "SDDM autologin is currently set to: $current_session"
    echo ""
    echo "To boot into Niri, you need to either:"
    echo "  1) Switch autologin to Niri (recommended):"
    echo "     sudo sed -i 's/^Session=.*/Session=niri/' $SDDM_CONF"
    echo ""
    echo "  2) Disable autologin to see the session picker at login:"
    echo "     sudo sed -i 's/^Session=/#Session=/' $SDDM_CONF"
    echo ""
    read -rp "Switch autologin to Niri now? [y/N] " answer
    if [[ "${answer,,}" == "y" ]]; then
      sudo sed -i 's/^Session=.*/Session=niri/' "$SDDM_CONF"
      echo "Done — next boot goes straight into Niri."
      echo "To switch back: sudo sed -i 's/^Session=.*/Session=hyprland-uwsm/' $SDDM_CONF"
    else
      echo "Skipped. You can change it manually later."
    fi
  fi
else
  echo "No SDDM autologin detected — select Niri from the session picker at login."
fi

echo ""
echo "─── Omarchy upgrade compatibility ───"
echo ""
echo "Omarchy updates (omarchy-update) are safe. This repo's bin/ directory"
echo "shadows omarchy originals via PATH, so updated originals are only used"
echo "as fallbacks when not running Niri. If omarchy adds NEW scripts that"
echo "call hyprctl, they won't have wrappers — check after major updates:"
echo "  ./check-upgrade.sh"
echo ""
echo "Log out and log back in (or reboot) to start Niri."
