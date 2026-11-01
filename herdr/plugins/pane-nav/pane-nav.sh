#!/bin/bash
#
# pane-nav.sh DIRECTION: in a pane running (n)vim, hand the key to nvim, which moves between
# its splits and calls `herdr pane focus` at its edge (nvim/lua/config/keymaps.lua).
# Anywhere else, move herdr's focus.
#
# ---

set -euo pipefail

herdr=${HERDR_BIN_PATH:-herdr}
pane=$HERDR_PANE_ID
case $1 in
  left) key=h ;;
  down) key=j ;;
  up) key=k ;;
  right) key=l ;;
  *) exit 64 ;;
esac

if "$herdr" pane process-info --pane "$pane" | grep -Eq '"name":"n?vim"'; then
  exec "$herdr" pane send-keys "$pane" "ctrl+alt+$key" > /dev/null
fi
exec "$herdr" pane focus --direction "$1" --pane "$pane" > /dev/null
