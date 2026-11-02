#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

bold=$(tput bold 2> /dev/null || true)
reset=$(tput sgr0 2> /dev/null || true)

title() {
  echo "${bold}==> $1${reset}"
  echo
}

indent() {
  sed 's/^/  /'
}

# Check for Homebrew and install it if required (NONINTERACTIVE=1, from setup.sh -y, skips its
# prompt)
if ! command -v brew &> /dev/null; then
  title "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  eval "$(/opt/homebrew/bin/brew shellenv 2> /dev/null || /usr/local/bin/brew shellenv)"
fi

# Homebrew's settings from env.zsh (forbidden formulae, no analytics...): setup runs in bash,
# before the zsh config is linked
eval "$(grep '^export HOMEBREW_' tilde/.config/zsh/env.zsh)"

# The latest Homebrew and formulae, then upgrade what's installed. Like `brew bundle` below, a
# failure here (offline, a running app's cask) is reported and setup goes on
brew update || echo "${bold}brew update failed; continuing.${reset}"
brew upgrade || echo "${bold}Some upgrades failed (see above); continuing.${reset}"

# Install the taps, formulae, casks and fonts in the Brewfile. One failed cask (a download
# error, an app that is already installed outside Homebrew) shouldn't stop the rest of setup;
# rerun `brew bundle --file=setup/Brewfile` once it's sorted out.
title "Installing software..."
if ! brew bundle --file=setup/Brewfile | indent; then
  echo "${bold}Some Brewfile entries failed to install (see above); continuing.${reset}"
fi

# Remove outdated versions of formulae and casks from the cellar
# Besides, this will run `brew autoremove` to remove all the hanging, no longer needed packages
brew cleanup
