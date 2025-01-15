#!/usr/bin/env bash

MODE_FILE="/tmp/hyprland_scroller_mode"

function handle {
  if [[ ${1:0:8} == "scroller" ]]; then
    if [[ ${1:10:11} == "overview, 0" ]]; then
        #hyprctl notify -1 3000 "rgb(ff1ea3)" "Normal mode"
        hyprctl notify -1 3000 "rgb(f11ea3)" "Normal mode"
    elif [[ ${1:10:11} == "overview, 1" ]]; then
        hyprctl notify -1 3000 "rgb(f11ea3)" "Overview mode"
    elif [[ ${1:10:11} == "admitwindow" ]]; then
        hyprctl notify -1 3000 "rgb(f11ea3)" "Admit Window"
    elif [[ ${1:10:11} == "expelwindow" ]]; then
        hyprctl notify -1 3000 "rgb(f11ea3)" "Expel Window"
    # Waybar notifications below
    elif [[ ${1:10:9} == "mode, row" ]]; then
        echo "Row" > "$MODE_FILE"
        hyprctl notify -1 3000 "rgb(f11ea3)" "Row mode"
    elif [[ ${1:10:12} == "mode, column" ]]; then
        echo "Column" > "$MODE_FILE"
        hyprctl notify -1 3000 "rgb(f11ea3)" "Column mode"
    #else
        #echo "" > "$MODE_FILE"
    fi
    hyprctl dispatch submap reset && pkill -SIGRTMIN+8 waybar # update the widget on waybar
  fi
}

# Initialize the mode file
echo "" > "$MODE_FILE"

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
