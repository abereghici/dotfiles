# Fd: https://github.com/sharkdp/fd
command -v fd &> /dev/null && alias find="fd"

# Eza: https://eza.rocks/
# Display all clickable entries (incl. hidden files) as a grid with icons
command -v eza &> /dev/null && alias ls="eza -a --hyperlink --icons=auto --group-directories-first --color-scale=age"
# Display a detailed list of clickable entries (incl. hidden files) with a Git status
command -v eza &> /dev/null && alias ll="ls --long --no-user --header -g --git"
# Display clickable directory tree
command -v eza &> /dev/null && alias llt="ls --tree --git-ignore"

# Yazi: TUI file manager with shell cd-on-exit
# https://yazi-rs.github.io/docs/quick-start#shell-wrapper
# Usage: y [path]  — opens yazi, cds to directory on exit
if command -v yazi &> /dev/null; then
  y() {
    local tmp
    tmp="$(mktemp "${TMPDIR:-/tmp}/yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if [ -f "$tmp" ]; then
      local cwd
      cwd="$(< "$tmp")"
      rm -f "$tmp"
      if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd "$cwd"
      fi
    fi
  }
fi

# Project pickers over ~/Development and ~/Code, as in tmux.conf (prefix f, C-M-p) and herdr
alias tmuxs="projects tmux"
alias herdrs="projects herdr"

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
alias dc="docker compose"
alias v="nvim"
alias vim="nvim"
alias where="which"
alias pn="pnpm"
