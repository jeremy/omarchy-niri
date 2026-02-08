# omarchy-niri

Niri window manager overlay for [Omarchy](https://omarchy.com). Runs Niri alongside the existing Hyprland setup — switch between them at SDDM login.

## How it works

- `config/` — Niri, swaylock, and portal configs (templates expanded by `install.sh`)
- `bin/` — 15 wrapper scripts that shadow omarchy originals via PATH, translating `hyprctl` calls to `niri msg` equivalents
- `extensions/menu.sh` — omarchy menu overrides for Niri
- `waybar/config.jsonc` — waybar config with `niri/workspaces` module
- `lib.sh` — shared `is_niri` helper sourced by all wrappers
- `$OMARCHY_WM=niri` env var gates behavior; Hyprland sessions fall through to originals

## Install

```bash
sudo pacman -S niri swayidle swaylock-effects wlsunset xwayland-satellite xdg-desktop-portal-gnome wtype
./install.sh
```

Log out and select Niri at the SDDM session picker (or let `install.sh` switch autologin).

## After omarchy upgrades

```bash
./check-upgrade.sh
```

Reports omarchy scripts using Hyprland-specific tools (`hyprctl`, `hypridle`, `hyprlock`, `hyprsunset`, `hyprpicker`, `hyprpaper`) that lack wrappers. See `AGENTS.md` for the IPC mapping and wrapper creation workflow.

## Replacements

| Hyprland | Niri |
|---|---|
| hyprctl | niri msg |
| hypridle | swayidle |
| hyprlock | swaylock-effects |
| hyprsunset | wlsunset |
| hyprpicker | grim + slurp + imagemagick |
| hyprpaper | swaybg |
| xdg-desktop-portal-hyprland | xdg-desktop-portal-gnome |
| sendshortcut | wtype |
