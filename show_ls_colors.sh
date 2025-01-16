#!/bin/bash
# A script to show ls colors derived from dircolors

prv_code=""
cur_code=""
ext=""
comment_text=""
type=""
while read -r line; do
    if [[ $line =~ (.*)\ ([0-9]{2}\;[0-9]{2}).* ]]; then
        ext=${BASH_REMATCH[1]}
        cur_code=${BASH_REMATCH[2]}
    elif [[ ${line:0:1} = "#" ]]; then
        comment_text=${line:2}
        continue
    elif [[ "${line% *}" = TERM ]]; then
        continue
    fi
    if [[ "$prv_code" != "$cur_code" ]]; then
        if [[ ${line:0:1} != "." ]]; then
            type=${line%% *}
        else
            type="$comment_text"
        fi
        prv_code=$cur_code
        echo "[${cur_code}m${type}[0m"
    fi
done <./dircolors/.dircolors
