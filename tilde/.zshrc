eval "$(/opt/homebrew/bin/brew shellenv)"

# Load path, env, aliases synchronously (always needed)
source $HOME/.config/zsh/path.zsh
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/keybindings.zsh

# Initialize zsh completion system AFTER fpath is fully set
autoload -Uz compinit && compinit -C

# Allow local (private) customizations (not checked in to version control)
[ -f ~/.zsh.local ] && source ~/.zsh.local

# ----- Plugin loading -----
ZSH_DEFER_PLUGIN="$HOME/.local/share/zsh-defer/zsh-defer.plugin.zsh"

if [ -f "$ZSH_DEFER_PLUGIN" ]; then
  # Fast path: defer slow evals until after first prompt
  source "$ZSH_DEFER_PLUGIN"

  # Direnv: https://github.com/direnv/direnv
  _init_direnv() { eval "$(direnv hook zsh)" }
  zsh-defer _init_direnv

  # Zoxide (better cd): https://github.com/ajeetdsouza/zoxide
  _init_zoxide() { eval "$(zoxide init zsh)" }
  zsh-defer _init_zoxide

  # Mise (Polyglot runtime manager)
  _init_mise() { eval "$(mise activate zsh --shims)" }
  zsh-defer _init_mise

  # Fish-like autosuggestions
  zsh-defer source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  # Fish-like syntax highlighting (must be last of the plugin sources)
  zsh-defer source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

  # fzf key bindings and fuzzy completion
  if command -v fzf &>/dev/null; then
    zsh-defer source $HOME/.config/zsh/fzf.zsh
  fi

  # ngrok autocompletions
  if command -v ngrok &>/dev/null; then
    _init_ngrok() { eval "$(ngrok completion)" }
    zsh-defer _init_ngrok
  fi

  # Angular CLI autocompletion
  if command -v ng &>/dev/null; then
    _init_ng() { eval "$(ng completion script)" }
    zsh-defer _init_ng
  fi

  # Starship prompt (must be last)
  if command -v starship &>/dev/null; then
    zsh-defer source $HOME/.config/zsh/prompt.zsh
  fi
else
  # Slow path fallback: synchronous loading (zsh-defer not installed)
  echo "⚠ zsh-defer not found — run setup/misc.sh to install it" >&2
  eval "$(direnv hook zsh)"
  eval "$(zoxide init zsh)"
  eval "$(mise activate zsh --shims)"
  [ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  command -v fzf &>/dev/null && source $HOME/.config/zsh/fzf.zsh
  command -v ngrok &>/dev/null && eval "$(ngrok completion)"
  command -v ng &>/dev/null && eval "$(ng completion script)"
  command -v starship &>/dev/null && source $HOME/.config/zsh/prompt.zsh
fi
