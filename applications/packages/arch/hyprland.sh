#!/usr/bin/env zsh

DEV_ENV="${DEV_ENV:-${XDG_DATA_HOME:-$HOME/.local/share}/dev-env}"
FILE="$DEV_ENV/.config/hypr/custom-$HOST.conf"
[ ! -f "$FILE" ] && touch "$FILE"

