#!/bin/sh
(cd ./Hypr-DarkWindow && patch --strip=1 --input=../darkwindow.patch)
(cd ./hyprland-easymotion && patch --strip=1 --input=../easymotion.patch)
