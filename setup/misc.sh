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

# herdr plugins kept in this repo (last workspace on prefix Tab, nvim back in Editor tabs)
info 'Linking herdr plugins...'
for plugin in herdr/plugins/*/; do
  herdr plugin link "$PWD/$plugin" > /dev/null && echo "linked ${plugin%/}" | indent
done

# Runtimes and global npm packages from ~/.config/mise/config.toml
info 'Installing mise tools...'
mise install

# bat loads custom themes (rose-pine) only from its cache
info 'Building bat theme cache...'
bat cache --build | indent
