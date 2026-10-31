#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

bold=$(tput bold)
reset=$(tput sgr0)

title() {
  echo "${bold}==> $1${reset}"
  echo
}

indent() {
  sed 's/^/  /'
}

# Check for Homebrew and install it if required
if ! command -v brew &> /dev/null; then
  title "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Make sure we’re working with the latest version of Homebrew and its formulae
brew update

# Upgrade outdated already-installed formulae
brew upgrade

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
