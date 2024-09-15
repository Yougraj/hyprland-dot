#!/bin/bash

# Set time thresholds in minutes
lock_time=1    # Time to wait before locking the screen (5 minutes)
idle_limit=$((lock_time * 60 * 1000))  # Convert lock_time to milliseconds

# Variable to track how long audio and video have been inactive
inactive_minutes=0

while true; do
    # Check if audio is playing (0 means audio is playing)
    audio_active=$(pulsemixer --get-mute)

    # Check if a video is playing via playerctl (playing returns "Playing")
    video_active=$(playerctl status 2>/dev/null)

    # Check idle time (in milliseconds) since last mouse or keyboard input
    idle_time=$(xprintidle)

    # If audio is playing, video is playing, or there has been recent activity, reset the counter
    if [ "$audio_active" = "0" ] || [ "$video_active" = "Playing" ] || [ "$idle_time" -lt "$idle_limit" ]; then
        inactive_minutes=0
        echo "Activity detected: Resetting inactive time."
    else
        # Increment the counter if no activity is detected
        inactive_minutes=$((inactive_minutes + 1))
        echo "No activity for $inactive_minutes minute(s)."
    fi

    # If no activity or audio/video for lock_time, lock the screen
    if [ "$inactive_minutes" -ge "$lock_time" ]; then
        echo "No activity for $lock_time minutes. Locking screen..."
        # hyprctl dispatch dpms off  # Optionally turn off display
        hyprlock                    # Lock the screen with hyprlock
        inactive_minutes=0          # Reset after locking
    fi

    # Sleep for 1 minute before checking again
    sleep 2
done
