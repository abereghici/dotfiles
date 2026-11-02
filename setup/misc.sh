#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

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
  git clone --depth 1 https://github.com/tmux-plugins/tpm.git "$HOME/.config/tmux/plugins/tpm"
  echo 'Done!' | indent
fi

# The plugins listed in tmux.conf (what `prefix` `I` does inside tmux)
info 'Installing tmux plugins...'
"$HOME/.config/tmux/plugins/tpm/bin/install_plugins" | indent || echo 'Failed: press prefix I inside tmux to retry' | indent

# herdr plugins kept in this repo (last workspace, nvim back in Editor tabs, nvim-aware
# pane navigation)
info 'Linking herdr plugins...'
for plugin in herdr/plugins/*/; do
  herdr plugin link "$PWD/$plugin" > /dev/null && echo "linked ${plugin%/}" | indent
done

# Community herdr plugins (reviewr: review the agent's diff and send comments back)
if ! herdr plugin list | grep -q '^- persiyanov.reviewr '; then
  info 'Installing herdr-reviewr...'
  herdr plugin install persiyanov/herdr-reviewr --yes | tail -1 | indent
fi
# Its config.toml (from ~/.config/herdr/reviewr.toml and the untracked reviewr.local.toml) is
# written by `appearance sync` below, with the theme for the current appearance

# Runtimes and global npm packages from ~/.config/mise/config.toml
info 'Installing mise tools...'
mise install

# Bereghici Dark/Light for every tool, from github.com/abereghici/themes: cloned on the first
# run and updated after, then its install.sh puts each theme where its tool looks (its ports.yml
# says where) and builds bat's theme cache. After mise: packaging the VS Code theme needs npx.
info 'Installing color schemes...'
themes="$HOME/.local/share/bereghici"
if [ ! -e "$themes" ]; then
  git clone --quiet https://github.com/abereghici/themes "$themes" \
    || info "skipped the color schemes: couldn't clone github.com/abereghici/themes"
elif [ ! -L "$themes" ]; then # a link is a local checkout of the themes: left to you
  git -C "$themes" pull --quiet --ff-only || info "couldn't update $themes"
fi
if [ -x "$themes/install.sh" ]; then
  "$themes/install.sh" | indent || info "the color schemes stopped partway: run $themes/install.sh"
fi
# delta's feature, Claude Code's and Codex's themes and reviewr's config for the current appearance
bin/appearance sync
