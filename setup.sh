#!/bin/bash
#
# Set up computer environment
#

set -euo pipefail

cd "$(dirname "$0")"

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
light_red=$(tput setaf 9)
bold=$(tput bold)
reset=$(tput sgr0)

title() {
  echo "${bold}==> $1${reset}"
  echo
}

warning() {
  tput setaf 1
  echo "/!\\ $1 /!\\"
  tput sgr0
}

echo -e "
${yellow}
          _ ._  _ , _ ._
        (_ ' ( \`  )_  .__)
      ( (  (    )   \`)  ) _)
     (__ (_   (_ . _) _) ,__)
           ~~\ ' . /~~
         ,::: ;   ; :::,
        ':::::::::::::::'
 ____________/_ __ \____________
|                               |
|          Welcome to           |
|    @abereghici dotfiles       |
|_______________________________|
"
echo
echo -e "${yellow}!!! ${red}WARNING${yellow} !!!"
echo -e "${light_red}This script moves ~/.zshrc to ~/.zshrc.backup and links your dotfiles"
echo -e "${light_red}(symlinks.sh asks before replacing any other existing file)."
echo -e "${light_red}Use it at your own risk."

if [ $# -ne 1 ] || [ "$1" != "-y" ]; then
  echo -e "${yellow}Press Enter key to continue...${reset}\n"
  read key
fi

# Backup an existing zsh file (not our symlink, so re-runs keep the first backup)
if [[ -e "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Use Touch ID to authorize sudo (the line /etc/pam.d/sudo_local.template ships commented out)
if [ ! -f /etc/pam.d/sudo_local ]; then
  title "🔒 Enabling Touch ID to authorize sudo commands..."
  echo "auth       sufficient     pam_tid.so" | sudo tee /etc/pam.d/sudo_local
fi

# Ask for the administrator password upfront
warning "Activate sudo"
sudo echo "Sudo activated!"
echo

# Install Homebrew and packages/apps
title "🫖 Setting up Homebrew..."
./setup/brew.sh
# brew.sh runs in its own process, so a fresh Homebrew install isn't on this PATH yet
eval "$(/opt/homebrew/bin/brew shellenv 2> /dev/null || /usr/local/bin/brew shellenv)"
echo

# Install dotfiles symlinks (misc.sh reads the linked mise, bat and tmux configs)
title "🍤 Setting up symlinks..."
./setup/symlinks.sh
echo

# This machine's private settings: the untracked *.local files (every answer is optional)
title "🔑 Setting up local settings..."
if [ "${1:-}" = "-y" ]; then
  echo "Skipped with -y: run ./setup/local.sh to answer the questions"
else
  ./setup/local.sh
fi
echo

# Install tpm, mise runtimes and global npm packages, and the bat theme cache
title "🚀 Setting up extra tools..."
./setup/misc.sh

echo
echo "🦏 ${green}All done! Open a new terminal for the changes to take effect.${reset}"
