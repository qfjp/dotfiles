#!/bin/sh
exec xautolock -detectsleep -time 10 -locker $HOME/bin/screensaver/lock_screen \
               -notify 30 -notifier "notify-send -u normal -t 30000 -- 'LOCKING screen in 30 seconds'"
