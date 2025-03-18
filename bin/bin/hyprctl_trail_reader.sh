#!/bin/bash

TRAIL_FILE="/tmp/hyprland_scroller_trail"

touch "$TRAIL_FILE"

trail_num=$(head -n1 "$TRAIL_FILE")
trail_len=$(tail -n1 < <(head -n2 "$TRAIL_FILE"))
trailed=$(tail -n1 $TRAIL_FILE)

if [[ "$trailed" == "0" ]]; then
    icon="untrailed"
    percent=0
    class="untrailed"
elif [[ "$trailed" == "1" ]]; then
    icon="Column"
    percent=100
    class="trailed"
else
    icon="untrailed"
    percent=0
    class="untrailed"
fi

echo "{\"text\":\"T<sub>$trail_num</sub> → $trail_len\", \"tooltip\":\"Trail: $trail_num\", \"class\":\"$class\", \"percentage\":$percent}" > /tmp/trail
echo "{\"text\":\"T<sub>$trail_num</sub> → $trail_len\", \"tooltip\":\"Trail: $trail_num\", \"class\":\"$class\", \"percentage\":$percent}"
