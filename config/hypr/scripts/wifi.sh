#!/usr/bin/env sh

# Set variables
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
roconf="${confDir}/rofi/clipboard.rasi"

# Set rofi scaling
[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"

# Hyprland variables
if printenv HYPRLAND_INSTANCE_SIGNATURE &> /dev/null; then
    hypr_border=$(hyprctl -j getoption decoration:rounding | jq '.int')
    hypr_width=$(hyprctl -j getoption general:border_size | jq '.int')
else
    hypr_border=0
    hypr_width=1
fi

wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)

# Evaluate spawn position
readarray -t curPos < <(hyprctl cursorpos -j | jq -r '.x,.y')
readarray -t monRes < <(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width,.height,.scale,.x,.y')
readarray -t offRes < <(hyprctl -j monitors | jq -r '.[] | select(.focused==true).reserved | map(tostring) | join("\n")')
monRes[2]="$(echo "${monRes[2]}" | sed "s/\.//")"
monRes[0]="$(( ${monRes[0]} * 100 / ${monRes[2]} ))"
monRes[1]="$(( ${monRes[1]} * 100 / ${monRes[2]} ))"
curPos[0]="$(( ${curPos[0]} - ${monRes[3]} ))"
curPos[1]="$(( ${curPos[1]} - ${monRes[4]} ))"

if [ "${curPos[0]}" -ge "$((${monRes[0]} / 2))" ] ; then
    x_pos="east"
    x_off="-$(( ${monRes[0]} - ${curPos[0]} - ${offRes[2]} ))"
else
    x_pos="west"
    x_off="$(( ${curPos[0]} - ${offRes[0]} ))"
fi

if [ "${curPos[1]}" -ge "$((${monRes[1]} / 2))" ] ; then
    y_pos="south"
    y_off="-$(( ${monRes[1]} - ${curPos[1]} - ${offRes[3]} ))"
else
    y_pos="north"
    y_off="$(( ${curPos[1]} - ${offRes[1]} ))"
fi

r_override="window{location:${x_pos} ${y_pos};anchor:${x_pos} ${y_pos};x-offset:${x_off}px;y-offset:${y_off}px;border:${hypr_width}px;border-radius:${wind_border}px;} wallbox{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"

# WiFi selection and connection
bssid=$(nmcli device wifi list | sed -n '1!p' | cut -b 28- | awk '{print substr($0, 1, index($0, "Infra") - 2)}' | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}" -p "Select WiFi: " -l 20 | cut -d' ' -f1)

pass=$(echo "" | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}" -p "Enter Password: ")

nmcli device wifi connect "$bssid" password "$pass"
