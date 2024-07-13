#!/usr/bin/env zsh

command_exists() {
  command -v "$@" &> /dev/null
}

# Fd: https://github.com/sharkdp/fd
command_exists fd && alias find="fd"

# Eza: https://eza.rocks/
# Display all clickable entries (incl. hidden files) as a grid with icons
command_exists eza && alias ls="eza -a --hyperlink --icons=auto --group-directories-first --color-scale=age"
# Display a detailed list of clickable entries (incl. hidden files) with a Git status
command_exists eza && alias ll="ls --long --no-user --header -g --git"
# Display clickable directory tree
command_exists eza && alias llt="ls --tree --git-ignore"

command_exists z && alias cd="z"

# Lazydocker
alias ld="lazydocker"

# Lazygit
alias lg="lazygit"

# Typos
alias sl="ls"
alias gut="git"
alias gti="git"
alias mdkir="mkdir"
alias brwe="brew"

# Sane defaults for built-ins (verbose and interactive)
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias grep="grep -i --color=auto"
alias mkdir="mkdir -p"

# Shortcuts
alias ls="ls --color"
alias l="ls -l"
alias -- +x="chmod +x"
alias o="open"
alias oo="open ."
alias g="git"
alias d="docker"
alias dc="docker-compose"
alias v="nvim"
alias vim="nvim"
alias where="which"
alias pn="pnpm"
alias nvm="fnm"
