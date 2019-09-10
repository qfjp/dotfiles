#!/bin/sh
commands="$OS_PREFIX/share/man/man1/*"
# shellcheck disable=SC2086
commands="$(basename -a $commands | sed 's/\.1[a-z]*\.gz//')"

games="$OS_PREFIX/share/man/man6/*"
# shellcheck disable=SC2086
games="$(basename -a $games | sed 's/\.6[a-z]*\.gz//')"

sys="$OS_PREFIX/share/man/man7/*"
# shellcheck disable=SC2086
sys="$(basename -a $sys | sed 's/\.7[a-z]*\.gz//')"

"$OS_PREFIX/bin/whatis" "$(printf "%s\\n%s\\n%s" "$commands" "$games" "$sys" | shuf -n 1)"
