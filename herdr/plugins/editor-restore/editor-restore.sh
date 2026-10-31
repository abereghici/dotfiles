#!/bin/bash
#
# Run nvim in the first pane of every tab labelled Editor that has no nvim yet. Startup hooks
# also run on a live `herdr update --handoff`, where nvim is still running: every pane's
# processes carry HERDR_SOCKET_PATH and HERDR_PANE_ID, so those panes are skipped.
#
# ---

set -euo pipefail

herdr=${HERDR_BIN_PATH:-herdr}
socket=${HERDR_SOCKET_PATH:-}

# Panes of this server that already run nvim. Without the socket path, any herdr nvim's pane
# counts: at worst an Editor tab is left without nvim, never given a second one.
busy=$(
  for pid in $(pgrep -x nvim); do
    env=" $(ps -E -ww -o command= -p "$pid") "
    if [[ -z $socket || $env == *" HERDR_SOCKET_PATH=$socket "* ]]; then
      grep -o 'HERDR_PANE_ID=[^ ]*' <<< "$env" | cut -d = -f 2
    fi
  done | sort -u
)

panes=$("$herdr" pane list)
for workspace in $(jq -r '.result.panes[].workspace_id' <<< "$panes" | sort -u); do
  for tab in $("$herdr" tab list --workspace "$workspace" | jq -r '.result.tabs[] | select(.label == "Editor") | .tab_id'); do
    pane=$(jq -r --arg tab "$tab" 'first(.result.panes[] | select(.tab_id == $tab) | .pane_id) // empty' <<< "$panes")
    if [[ -n $pane ]] && ! grep -qxF "$pane" <<< "$busy"; then
      "$herdr" pane run "$pane" nvim > /dev/null
    fi
  done
done
