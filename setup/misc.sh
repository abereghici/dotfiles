#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

BLUE=$(tput setaf 4 2> /dev/null || true)
RESET=$(tput sgr0 2> /dev/null || true)

indent() {
  sed 's/^/  /'
}

info() {
  echo
  echo "[ ${BLUE}..${RESET} ] $1" | indent
}

# Runs after symlinks.sh, so ~/.config/mise, ~/.config/bat, ~/.config/tmux and ~/.config/herdr
# point into this repo

# Run on its own (the manual install), Homebrew isn't on PATH yet in a fresh shell
eval "$(/opt/homebrew/bin/brew shellenv 2> /dev/null || /usr/local/bin/brew shellenv)"

# TPM: tmux plugin manager (loaded from ~/.config/tmux/plugins/tpm by tmux.conf)
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  info 'Installing tmux plugin manager (tpm)...'
  GIT_TERMINAL_PROMPT=0 git clone --quiet --depth 1 https://github.com/tmux-plugins/tpm.git "$HOME/.config/tmux/plugins/tpm" \
    || info "couldn't clone tpm: run setup/misc.sh again"
fi

# The plugins listed in tmux.conf (what `prefix` `I` does inside tmux)
if [ -x "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]; then
  info 'Installing tmux plugins...'
  "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" | indent || echo 'Failed: press prefix I inside tmux to retry' | indent
fi

if command -v herdr > /dev/null; then
  # herdr plugins kept in this repo (last workspace, nvim back in Editor tabs, nvim-aware
  # pane navigation)
  info 'Linking herdr plugins...'
  for plugin in herdr/plugins/*/; do
    herdr plugin link "$PWD/$plugin" > /dev/null && echo "linked ${plugin%/}" | indent
  done

  # Community herdr plugins (reviewr: review the agent's diff and send comments back)
  # The list is read whole first: grep -q stops at the match, and herdr writing on would fail the pipe
  if ! grep -q '^- persiyanov.reviewr ' <<< "$(herdr plugin list 2> /dev/null)"; then
    info 'Installing herdr-reviewr...'
    herdr plugin install persiyanov/herdr-reviewr --yes | tail -1 | indent \
      || info "couldn't install herdr-reviewr: run setup/misc.sh again"
  fi
  # Its config.toml (from ~/.config/herdr/reviewr.toml and the untracked reviewr.local.toml) is
  # written by `appearance sync` below, with the theme for the current appearance
else
  info "herdr isn't installed (see brew bundle above): skipped its plugins"
fi

# Runtimes and global npm packages from ~/.config/mise/config.toml
info 'Installing mise tools...'
mise install || info "some mise tools failed to install (see above): run \`mise install\` again"

# Bereghici Dark/Light for every tool, from github.com/abereghici/themes: cloned on the first
# run and updated after, then its install.sh puts each theme where its tool looks (its ports.yml
# says where) and builds bat's theme cache. After mise: packaging the VS Code theme needs npx.
info 'Installing color schemes...'
themes="$HOME/.local/share/bereghici"
if [ ! -e "$themes" ]; then
  GIT_TERMINAL_PROMPT=0 git clone --quiet https://github.com/abereghici/themes "$themes" \
    || info "skipped the color schemes: couldn't clone github.com/abereghici/themes"
elif [ ! -L "$themes" ]; then # a link is a local checkout of the themes: left to you
  GIT_TERMINAL_PROMPT=0 git -C "$themes" pull --quiet --ff-only || info "couldn't update $themes"
fi
if [ -x "$themes/install.sh" ]; then
  "$themes/install.sh" | indent || info "the color schemes stopped partway: run $themes/install.sh"
fi
# delta's feature, Claude Code's and Codex's themes and reviewr's config for the current appearance
bin/appearance sync
