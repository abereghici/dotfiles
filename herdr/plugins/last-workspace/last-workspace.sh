#!/bin/bash
#
# record: on every workspace focus, keep the focused workspace and the one before it
# switch: focus the one before it
#
# ---

set -euo pipefail

herdr=${HERDR_BIN_PATH:-herdr}
history="$HERDR_PLUGIN_STATE_DIR/history" # line 1: current, line 2: previous

current=$(sed -n 1p "$history" 2> /dev/null || true)
previous=$(sed -n 2p "$history" 2> /dev/null || true)

case "${1:-}" in
  record)
    focused=$(jq -r '.data.workspace_id // empty' <<< "${HERDR_PLUGIN_EVENT_JSON:-}")
    if [[ -n $focused && $focused != "$current" ]]; then
      printf '%s\n%s\n' "$focused" "$current" > "$history"
    fi
    ;;
  switch)
    # The previous workspace may have been closed since; then there is nothing to do
    [[ -n $previous ]] && "$herdr" workspace focus "$previous" > /dev/null 2>&1 || true
    ;;
  *)
    echo "usage: last-workspace.sh record|switch" >&2
    exit 2
    ;;
esac
