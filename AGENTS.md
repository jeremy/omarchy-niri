# omarchy-niri

Niri window manager overlay for Omarchy. Wrapper scripts in `bin/` shadow omarchy originals via PATH. Each wrapper sources `lib.sh`, checks `is_niri`, and falls through to the original when running under Hyprland.

## After omarchy upgrades

Run `./check-upgrade.sh` to detect drift. It scans for all Hyprland-specific tools (`hyprctl`, `hypridle`, `hyprlock`, `hyprsunset`, `hyprpicker`, `hyprpaper`). When it reports missing wrappers:

1. Read the original omarchy script (`~/.local/share/omarchy/bin/<name>`)
2. Identify the Hyprland calls and their niri equivalents:
   - `hyprctl clients -j` → `niri msg -j windows`
   - `hyprctl activewindow -j` → `niri msg -j focused-window`
   - `hyprctl monitors -j` → `niri msg -j outputs` or `niri msg -j focused-output`
   - `hyprctl dispatch focuswindow` → `niri msg action focus-window --id`
   - `hyprctl dispatch closewindow` → `niri msg action close-window --id`
   - `hyprctl dispatch workspace N` → `niri msg action focus-workspace N`
   - `hyprctl dispatch dpms off/on` → `niri msg action power-off-monitors` / `power-on-monitors`
   - `hyprctl reload` → restart swaybg/waybar (niri has no reload)
   - `hyprctl keyword` → no equivalent (config is static in niri)
3. Create a wrapper in `bin/` following the existing pattern (source lib.sh, is_niri guard, exec fallback)
4. `chmod +x` the new wrapper
5. Run `niri validate` to confirm config still passes
6. Commit the new wrapper

Scripts that use Hyprland-only features (window pop, toggle gaps, scratchpad) don't need wrappers — those features don't exist in Niri.

## Key mappings reference

| Hyprland IPC | Niri IPC |
|---|---|
| `hyprctl clients -j` → `.[].address` | `niri msg -j windows` → `.[].id` |
| `hyprctl activewindow -j` → `.pid`, `.class` | `niri msg -j focused-window` → `.pid`, `.app_id` |
| `hyprctl monitors -j` → `.[] | select(.focused)` | `niri msg -j focused-output` (direct) |
| `.name`, `.scale`, `.width`, `.height` | `.name`, `.scale`, `.logical.width`, `.logical.height` |
| `hyprctl dispatch focuswindow address:X` | `niri msg action focus-window --id X` |
| `hyprctl dispatch closewindow address:X` | `niri msg action close-window --id X` |
| `hyprctl dispatch workspace N` | `niri msg action focus-workspace N` |
| hypridle / hyprlock / hyprsunset | swayidle / swaylock / wlsunset |
| hyprpicker | grim + slurp + imagemagick (see color picker binding) |
| hyprpaper | swaybg |
