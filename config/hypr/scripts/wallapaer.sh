#!/usr/bin/env sh

# Set variables
wallpaper_dir="${XDG_CONFIG_HOME:-$HOME/.config}/wallpaper"
thumb_dir="${XDG_CONFIG_HOME:-$HOME/.config}/wallpaper/thumb"
dcol_dir="${XDG_CONFIG_HOME:-$HOME/.config}/wallpaper/dcol"

# Ensure directories exist
mkdir -p "$thumb_dir"
mkdir -p "$dcol_dir"

# Function to generate cache files
generate_cache() {
    local wallpaper="$1"
    local hash="wall"

    # Remove existing cache files if they exist
    rm -f "${thumb_dir}/${hash}.thmb"
    rm -f "${thumb_dir}/${hash}.sqre"
    rm -f "${thumb_dir}/${hash}.blur"
    rm -f "${thumb_dir}/${hash}.quad"
    rm -f "${dcol_dir}/${hash}.dcol"

    # Generate thumbnail
    convert -strip -resize 1000x1000^ -gravity center -extent 1000x1000 -quality 90 "$wallpaper" "${thumb_dir}/${hash}.thmb"

    # Generate square thumbnail
    convert -strip "$wallpaper" -thumbnail 500x500^ -gravity center -extent 500x500 "${thumb_dir}/${hash}.sqre"

    # Generate blurred version
    convert -strip -scale 10% -blur 0x3 -resize 100% "$wallpaper" "${thumb_dir}/${hash}.blur"

    # Generate quadrilateral overlay
    convert "${thumb_dir}/${hash}.sqre" \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha Off -compose CopyOpacity -composite "${thumb_dir}/${hash}.quad"

    # Generate color palette
    "${scrDir}/wallbash.sh" --custom "${wallbashCustomCurve}" "${thumb_dir}/${hash}.thmb" "${dcol_dir}/${hash}" &> /dev/null

    echo "Cache generated for ${wallpaper}"
}

# Pick a random wallpaper from wallpaper_dir
random_wallpaper=$(find "$wallpaper_dir" -type f -name "*.jpg" | shuf -n 1)

# Set the picked wallpaper using swww
swww img "$random_wallpaper"

# Generate cache files for the picked wallpaper
generate_cache "$random_wallpaper"

dunstify -I "$random_wallpaper" -a "SWWW" -t 5000 "A New World Awaits" "Your desktop just got a makeover!"
