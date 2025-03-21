#!/usr/bin/env bash

. hypr-bin-env

function handle {
    line="$1"
    trail_num=0
    trail_len=0
    trailed=0
    if [[ -e "$TRAIL_FILE" ]]; then
        trail_num=$(head -n1 "$TRAIL_FILE")
        trail_len=$(tail -n1 < <(head -n2 "$TRAIL_FILE"))
        trailed=$(tail -n1 $TRAIL_FILE)
    fi
    if [[ ${line:0:8} == "scroller" ]]; then
        if [[ ${line:10:11} == "overview, 0" ]]; then
            false  # Just keep some filler
        elif [[ ${line:10:11} == "overview, 1" ]]; then
            false
        elif [[ ${line:10:11} == "admitwindow" ]]; then
            false
        elif [[ ${line:10:11} == "expelwindow" ]]; then
            false
        # Waybar module notifications below
        elif [[ ${line:10:9} == "mode, row" ]]; then
            echo "Row" > "$MODE_FILE"
        elif [[ ${line:10:12} == "mode, column" ]]; then
            echo "Column" > "$MODE_FILE"
        elif [[ ${line:10:9} == "trailmark" ]]; then
            trailed="${line:21}" # 1 for in trail, 0 for not
        elif [[ ${line:10:5} == "trail" ]]; then
            rest="${line:17}"
            trail_num="${rest%,*}"
            trail_len="${rest#*, }"
        fi
        echo -e "$trail_num\n$trail_len\n$trailed" > "$TRAIL_FILE"
        hyprctl dispatch submap reset && pkill -SIGRTMIN+8 waybar # update the widget on waybar
    fi
}

# Initialize the mode file
echo "" > "$MODE_FILE"

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
