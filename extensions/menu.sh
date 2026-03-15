# Omarchy menu overrides for Niri
# Only active when sourced by omarchy-menu (which loads ~/.config/omarchy/extensions/menu.sh)

# Only apply overrides when running under Niri
if [[ "${OMARCHY_WM:-hyprland}" == "niri" ]]; then

  show_style_menu() {
    case $(menu "Style" "󰸌  Theme\n  Font\n  Background\n  Niri\n󱄄  Screensaver\n  About") in
    *Theme*) show_theme_menu ;;
    *Font*) show_font_menu ;;
    *Background*) show_background_menu ;;
    *Niri*) open_in_editor ~/.config/niri/config.kdl ;;
    *Screensaver*) open_in_editor ~/.config/omarchy/branding/screensaver.txt ;;
    *About*) open_in_editor ~/.config/omarchy/branding/about.txt ;;
    *) show_main_menu ;;
    esac
  }

  show_toggle_menu() {
    case $(menu "Toggle" "󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰍜  Top Bar") in
    *Screensaver*) omarchy-toggle-screensaver ;;
    *Nightlight*) omarchy-toggle-nightlight ;;
    *Idle*) omarchy-toggle-idle ;;
    *Bar*) omarchy-toggle-waybar ;;
    *) back_to show_trigger_menu ;;
    esac
  }

  show_capture_menu() {
    case $(menu "Capture" "  Screenshot\n  Screenrecord\n󰃉  Color") in
    *Screenshot*) omarchy-cmd-screenshot ;;
    *Screenrecord*) show_screenrecord_menu ;;
    *Color*) grim -g "$(slurp -p)" -t ppm - | magick - -format '%[hex:p{0,0}]' info:- | wl-copy ;;
    *) back_to show_trigger_menu ;;
    esac
  }

  show_setup_menu() {
    local options="  Audio\n  Wifi\n󰂯  Bluetooth\n󱐋  Power Profile\n  System Sleep\n󰍹  Monitors"
    options="$options\n  Key Remapping"
    options="$options\n󰱔  DNS\n  Security\n  Config"

    case $(menu "Setup" "$options") in
    *Audio*) omarchy-launch-audio ;;
    *Wifi*) omarchy-launch-wifi ;;
    *Bluetooth*) omarchy-launch-bluetooth ;;
    *Power*) show_setup_power_menu ;;
    *System*) show_setup_system_menu ;;
    *Monitors*) open_in_editor ~/.config/niri/config.kdl ;;
    *Key\ Remapping*) omarchy-setup-makima && open_in_editor "$HOME/.config/makima/AT Translated Set 2 keyboard.toml" && omarchy-restart-makima ;;
    *DNS*) present_terminal omarchy-setup-dns ;;
    *Security*) show_setup_security_menu ;;
    *Config*) show_setup_config_menu ;;
    *) show_main_menu ;;
    esac
  }

  show_setup_config_menu() {
    case $(menu "Setup" "  Defaults\n  Niri\n  Swaylock\n  Swayosd\n󰌧  Walker\n󰍜  Waybar\n󰞅  XCompose") in
    *Defaults*) open_in_editor ~/.config/uwsm/default ;;
    *Niri*) open_in_editor ~/.config/niri/config.kdl ;;
    *Swaylock*) open_in_editor ~/.config/swaylock/config ;;
    *Swayosd*) open_in_editor ~/.config/swayosd/config.toml && omarchy-restart-swayosd ;;
    *Walker*) open_in_editor ~/.config/walker/config.toml && omarchy-restart-walker ;;
    *Waybar*) open_in_editor ~/.config/waybar/config.jsonc && omarchy-restart-waybar ;;
    *XCompose*) open_in_editor ~/.XCompose && omarchy-restart-xcompose ;;
    *) show_setup_menu ;;
    esac
  }

  show_update_process_menu() {
    case $(menu "Restart" "  Swayidle\n  Wlsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
    *Swayidle*)  omarchy-restart-hypridle ;;
    *Wlsunset*)  omarchy-restart-hyprsunset ;;
    *Swayosd*)   omarchy-restart-swayosd ;;
    *Walker*)    omarchy-restart-walker ;;
    *Waybar*)    omarchy-restart-waybar ;;
    *) show_update_menu ;;
    esac
  }

  show_update_config_menu() {
    case $(menu "Use default config" "  Swaylock\n󱣴  Plymouth\n  Swayosd\n  Tmux\n󰌧  Walker\n󰍜  Waybar") in
    *Swaylock*) present_terminal omarchy-refresh-hyprlock ;;
    *Plymouth*) present_terminal omarchy-refresh-plymouth ;;
    *Swayosd*)  present_terminal omarchy-refresh-swayosd ;;
    *Tmux*)     present_terminal omarchy-refresh-tmux ;;
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
