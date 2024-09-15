#!/usr/bin/env sh

# Set variables
wallpaper_dir="${XDG_CONFIG_HOME:-$HOME/.config}/wallpaper"
thumb_dir="${XDG_CONFIG_HOME:-$HOME/.config}/wallpaper/.thumb"
wallbashColors=4
wallbashFuzz=70
hyprlock_image="${PWD}/hyprlock.jpg"  # Define the path to save the hyprlock image in the current folder

# Ensure directories exist
mkdir -p "$thumb_dir"

# Function to generate cache files
generate_cache() {
    local wallpaper="$1"
    local hash="wall"

    # Generate thumbnail
    magick "$wallpaper" -strip -resize 1000x1000^ -gravity center -extent 1000x1000 -quality 90 "${thumb_dir}/${hash}.thmb"

    # Generate square thumbnail
    magick "$wallpaper" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "${thumb_dir}/${hash}.sqre"

    # Generate blurred version
    magick "$wallpaper" -strip -scale 10% -blur 0x3 -resize 100% "${thumb_dir}/${hash}.blur"

    # Generate quadrilateral overlay
    magick "${thumb_dir}/${hash}.sqre" \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha Off -compose CopyOpacity -composite "${thumb_dir}/${hash}.quad"

    # Quantize raw primary colors and pick the most dominant one
    readarray -t dcolRaw <<< $(magick "${thumb_dir}/${hash}.sqre" -depth 8 -fuzz ${wallbashFuzz}% +dither -kmeans ${wallbashColors} -depth 8 -format "%c" histogram:info: | sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,\2/p' | sort -r -n -k 1 -t ",")

    if [ ${#dcolRaw[*]} -lt ${wallbashColors} ]; then
        echo "RETRYING: distinct colors ${#dcolRaw[*]} is less than ${wallbashColors}..."
        readarray -t dcolRaw <<< $(magick "${thumb_dir}/${hash}.sqre" -depth 8 -fuzz ${wallbashFuzz}% +dither -kmeans $((wallbashColors + 2)) -depth 8 -format "%c" histogram:info: | sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,\2/p' | sort -r -n -k 1 -t ",")
    fi

    # Extract the primary color (the second element of the first item in dcolRaw)
    dcol_wall=$(echo "${dcolRaw[0]}" | cut -d',' -f2)
    echo "Primary color: ${dcol_wall}"

    # Save the color data to wall.dcol in the thumb_dir
    echo "dcol_wall=${dcol_wall}" > "${thumb_dir}/wall.dcol"

    # Set the primary color as wallpaper color (dcol_wall)
    swww img "$wallpaper" --transition-fps 60 --transition-type any --transition-duration 3 --fill-color "#${dcol_wall}"
}

# Pick a random wallpaper from wallpaper_dir
random_wallpaper=$(find "$wallpaper_dir" -type f -name "*.jpg" | shuf -n 1)

# Check if a valid wallpaper was selected
if [ -f "$random_wallpaper" ]; then
    echo "Selected wallpaper: $random_wallpaper"

    # Generate cache files for the picked wallpaper
    generate_cache "$random_wallpaper"

    # Copy the selected wallpaper to the current folder as hyprlock.jpg
    if cp "$random_wallpaper" "$hyprlock_image"; then
        echo "Wallpaper copied to $hyprlock_image"
    else
        echo "Error: Failed to copy wallpaper to $hyprlock_image"
    fi

    # Notify the user
    dunstify -I "$random_wallpaper" -a "SWWW" -t 5000 "A New World Awaits" "Your desktop just got a makeover!"
else
    echo "Error: No wallpaper found!"
fi
