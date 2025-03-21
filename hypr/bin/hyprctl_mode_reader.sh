#!/bin/bash

. hypr-bin-env

touch "$MODE_FILE"

current_mode=$(cat "$MODE_FILE")

if [[ "$current_mode" == "Row" ]]; then
    icon="Row"
    percent=0
    class="mode-row"
elif [[ "$current_mode" == "Column" ]]; then
    icon="Column"
    percent=100
    class="mode-column"
else
    icon="Row"
    percent=0
    class="Row"
fi

echo "{\"text\":\"$icon\", \"tooltip\":\"Mode:$current_mode\", \"class\":\"$class\",\"percentage\":$percent}"
