#!/bin/bash

# Set brightness via xbrightness when redshift status changes

# Set brightness values for each status.
# Range from 1 to 100 is valid
brightness_day=80
brightness_transition=50
brightness_night=10
# Set fps for smooth transition
fps=1000
#fade_time=60000
# Adjust this grep to filter only the backlights you want to adjust
mapfile -t backlights < <(xbacklight -list)
echo "${backlights[@]}"

set_brightness() {
    for backlight in "${backlights[@]}"; do
        xbacklight -set "$1" -fps $fps -ctrl "$backlight" &
        echo xbacklight -set "$1" -fps $fps -ctrl "$backlight"
    done
}

if [ "$1" = period-changed ]; then
    case $3 in
        night)
            set_brightness $brightness_night
            ;;
        transition)
            set_brightness $brightness_transition
            ;;
        daytime)
            set_brightness $brightness_day
            ;;
    esac
fi
