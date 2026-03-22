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

# Yazi: TUI file manager with shell cd-on-exit
# https://yazi-rs.github.io/docs/quick-start#shell-wrapper
# Usage: y [path]  — opens yazi, cds to directory on exit
if command_exists yazi; then
  y() {
    local tmp
    tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [ -f "$tmp" ]; then
      local cwd
      cwd="$(<"$tmp")"
      rm -f "$tmp"
      if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd "$cwd"
      fi
    fi
  }
fi

# Zoxide: https://github.com/ajeetdsouza/zoxide
# A smarter cd command.
command_exists z && alias cd="z"

# Tmux sessionizer
alias tmuxs="tmux-sessionizer -rp ~/Development/Freelance ~/Development/Learn ~/Development/OOS ~/Development/Work ~/Development/Personal"

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
alias grep="grep --color=auto"
alias mkdir="mkdir -p"

# Shortcuts
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
