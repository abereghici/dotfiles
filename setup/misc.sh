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

# Runs after symlinks.sh, so ~/.config/mise, ~/.config/bat and ~/.config/tmux point into this repo

# TPM: tmux plugin manager (loaded from ~/.config/tmux/plugins/tpm by tmux.conf)
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  info 'Installing tmux plugin manager (tpm)...'
  git clone --depth 1 https://github.com/tmux-plugins/tpm.git "$HOME/.config/tmux/plugins/tpm"
  echo 'Done!' | indent
fi

# The plugins listed in tmux.conf (what `prefix` `I` does inside tmux)
info 'Installing tmux plugins...'
"$HOME/.config/tmux/plugins/tpm/bin/install_plugins" | indent || echo 'Failed: press prefix I inside tmux to retry' | indent

# herdr plugins kept in this repo (prefix Tab: last workspace, as in tmux)
info 'Linking herdr plugins...'
for plugin in herdr/plugins/*/; do
  herdr plugin link "$PWD/$plugin" > /dev/null && echo "linked ${plugin%/}" | indent
done

# Community herdr plugins (reviewr: review the agent's diff and send comments back)
if ! herdr plugin list | grep -q '^- persiyanov.reviewr '; then
  info 'Installing herdr-reviewr...'
  herdr plugin install persiyanov/herdr-reviewr --yes | tail -1 | indent
fi

# Runtimes and global npm packages from ~/.config/mise/config.toml
info 'Installing mise tools...'
mise install

# bat loads custom themes (rose-pine) only from its cache
info 'Building bat theme cache...'
bat cache --build | indent
