#!/usr/bin/env sh

# Set variables
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
roconf="${confDir}/rofi/config.rasi"

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10

# Set Hyprland variables if running on Hyprland
if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null; then
    hypr_border="$(hyprctl -j getoption decoration:rounding | jq '.int')"
    hypr_width="$(hyprctl -j getoption general:border_size | jq '.int')"
fi


# Set Rofi overrides
wind_border=$(( hypr_border * 3 ))
[ "${hypr_border}" -eq 0 ] && elem_border="10" || elem_border=$(( hypr_border * 2 ))
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} element {border-radius: ${elem_border}px;}"
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
i_override="$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")"
i_override="configuration {icon-theme: \"${i_override}\";}"

# Rofi action
case "${1}" in
    d|--drun) r_mode="drun" ;;
    w|--window) r_mode="window" ;;
    f|--filebrowser) r_mode="filebrowser" ;;
    h|--help) echo -e "$(basename "${0}") [action]"
        echo "d :  drun mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode,"
        exit 0 ;;
    *) r_mode="drun" ;;
esac

# Launch Rofi
rofi -show "${r_mode}" -theme-str "${r_scale}" -theme-str "${r_override}" -theme-str "${i_override}" -config "${roconf}"
