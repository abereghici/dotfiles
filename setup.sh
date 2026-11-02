#!/bin/bash
#
# Set up computer environment
#

set -euo pipefail

cd "$(dirname "$0")"

# Colors only when tput knows the terminal (no TERM in CI, cron or ssh -T)
color() { tput "$@" 2> /dev/null || true; }
red=$(color setaf 1)
green=$(color setaf 2)
yellow=$(color setaf 3)
light_red=$(color setaf 9)
bold=$(color bold)
reset=$(color sgr0)

title() {
  echo "${bold}==> $1${reset}"
  echo
}

warning() {
  echo "${red}/!\\ $1 /!\\${reset}"
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
echo -e "${light_red}This script moves ~/.zshrc aside, links your dotfiles (asking before replacing"
echo -e "${light_red}any other file), installs Homebrew packages and changes /etc/pam.d/sudo_local."
echo -e "${light_red}Use it at your own risk."

# -y: no questions. Homebrew's installer, symlinks.sh (backs up every conflict) and local.sh
# (skipped) all follow it
case "$*" in
  "") ;;
  -y) export DOTFILES_YES=1 NONINTERACTIVE=1 ;;
  *)
    echo "Usage: $0 [-y]"
    exit 64
    ;;
esac
if [ -z "${DOTFILES_YES:-}" ]; then
  if [ ! -t 0 ]; then
    echo "${red}No terminal to ask in: run it with -y${reset}"
    exit 1
  fi
  echo -e "${yellow}Press Enter key to continue...${reset}\n"
  read -r
fi

# Move an existing zsh file aside (not our symlink, so re-runs never touch the backup); an
# earlier backup is kept, the new one gets a timestamp
if [[ -e "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  backup="$HOME/.zshrc.backup"
  [ -e "$backup" ] && backup="$backup.$(date +%Y%m%d%H%M%S)"
  mv "$HOME/.zshrc" "$backup"
  echo "Moved ~/.zshrc to $backup"
fi

# Use Touch ID to authorize sudo (the line /etc/pam.d/sudo_local.template ships commented out)
if [ ! -f /etc/pam.d/sudo_local ]; then
  title "🔒 Enabling Touch ID to authorize sudo commands..."
  echo "auth       sufficient     pam_tid.so" | sudo tee /etc/pam.d/sudo_local
fi

# Ask for the administrator password upfront, and keep sudo alive until setup finishes: casks
# that need it would otherwise stop a long `brew bundle` for the password
warning "Activate sudo"
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2> /dev/null &
echo "Sudo activated!"
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
if [ -n "${DOTFILES_YES:-}" ]; then
  echo "Skipped with -y: run ./setup/local.sh to answer the questions"
else
  ./setup/local.sh
fi
echo

# tmux and herdr plugins, mise runtimes, the Bereghici themes and `appearance sync`
title "🚀 Setting up extra tools..."
./setup/misc.sh

echo
echo "🦏 ${green}All done! Open a new terminal for the changes to take effect.${reset}"
