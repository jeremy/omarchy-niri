# Omarchy menu overrides for Niri
# Only active when sourced by omarchy-menu (which loads ~/.config/omarchy/extensions/menu.sh)

# Only apply overrides when running under Niri
if [[ "${OMARCHY_WM:-hyprland}" == "niri" ]]; then

  show_style_menu() {
    case $(menu "Style" "  Niri\n󰍜  Waybar\n  Mako\n󰌧  Walker\n  Terminal") in
    *Niri*)     launch_editor ~/.config/niri/config.kdl ;;
    *Waybar*)   launch_editor ~/.config/waybar/config.jsonc ;;
    *Mako*)     launch_editor ~/.config/mako/config ;;
    *Walker*)   launch_editor ~/.config/walker/config.toml ;;
    *Terminal*) show_style_terminal_menu ;;
    *) back_to show_main_menu ;;
    esac
  }

  show_update_process_menu() {
    case $(menu "Restart" "  Swayidle\n  Wlsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
    *Swayidle*)  pkill -x swayidle && omarchy-toggle-idle ;;
    *Wlsunset*)  pkill -x wlsunset ;;
    *Swayosd*)   omarchy-restart-swayosd ;;
    *Walker*)    omarchy-restart-walker ;;
    *Waybar*)    omarchy-restart-waybar ;;
    *) show_update_menu ;;
    esac
  }

  show_update_config_menu() {
    case $(menu "Use default config" "  Swaylock\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
    *Swaylock*) present_terminal "cp ~/.local/share/omarchy/default/swaylock/config ~/.config/swaylock/config 2>/dev/null || echo 'No default swaylock config'" ;;
    *Swayosd*)  present_terminal omarchy-refresh-swayosd ;;
    *Walker*)   present_terminal omarchy-refresh-walker ;;
    *Waybar*)   present_terminal omarchy-refresh-waybar ;;
    *) show_update_menu ;;
    esac
  }

  show_learn_menu() {
    case $(menu "Learn" "  Niri wiki\n  Niri README\n  Omarchy wiki") in
    *wiki*)    xdg-open "https://github.com/YaLTeR/niri/wiki" ;;
    *README*)  xdg-open "https://github.com/YaLTeR/niri" ;;
    *Omarchy*) xdg-open "https://omarchy.com/wiki" ;;
    *) back_to show_main_menu ;;
    esac
  }

fi
