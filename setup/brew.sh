#!/bin/bash

set -euo pipefail

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

# Install fonts, tools, apps & vscode extensions
title "Installing software..."
brew bundle --file="$(pwd)/setup/Brewfile" | indent

# Extra CLI apps (non brew)

# Oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Extra apps
# echo ""
# title "☕️ Install more apps if you need them:"
# echo "brew install --cask tradingview"

# App Store apps
# echo ""
# title "🍏 Install additional apps from App Store:"
# echo "https://apps.apple.com/us/app/ia-writer/id775737590?mt=12"

# Remove outdated versions of formulae and casks from the cellar
# Besides, this will run `brew autoremove` to remove all the hanging, no longer needed packages
brew cleanup
