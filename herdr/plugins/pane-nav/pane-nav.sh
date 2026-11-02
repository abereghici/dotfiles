#!/bin/bash
#
# pane-nav.sh DIRECTION: in a pane running nvim, hand the key to nvim, which moves between
# its splits and calls `herdr pane focus` at its edge (nvim/lua/config/keymaps.lua).
# Anywhere else, move herdr's focus.
#
# ---

set -euo pipefail

herdr=${HERDR_BIN_PATH:-herdr}
case ${1:-} in
  left) key=h ;;
  down) key=j ;;
  up) key=k ;;
  right) key=l ;;
  *)
    echo "usage: pane-nav.sh left|down|up|right" >&2
    exit 2
    ;;
esac
pane=$HERDR_PANE_ID

nvim='.result.process_info.foreground_processes | any(.name | . == "nvim")'
if "$herdr" pane process-info --pane "$pane" | jq -e "$nvim" > /dev/null; then
  exec "$herdr" pane send-keys "$pane" "ctrl+alt+$key" > /dev/null
fi
exec "$herdr" pane focus --direction "$1" --pane "$pane" > /dev/null
