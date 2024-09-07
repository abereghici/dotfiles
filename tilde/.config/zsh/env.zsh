#!/usr/bin/env zsh

# Set editor to nvim
export VISUAL=nvim
export EDITOR=$VISUAL

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# ----- Bat (better cat) -----
# https://github.com/sharkdp/bat
export BAT_THEME="base16"

# Cancel those terrible ideas Homebrew had of forcing update every 300 s and
# forcing a 3 s curl on every single run.
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
