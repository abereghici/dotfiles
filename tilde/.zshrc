eval "$(/opt/homebrew/bin/brew shellenv 2> /dev/null || /usr/local/bin/brew shellenv)"

# Load path, env, aliases and keybindings
source $HOME/.config/zsh/path.zsh
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/keybindings.zsh

# Initialize zsh completion system AFTER fpath is fully set. Rebuild the dump when it is
# over a day old so newly installed completions load; otherwise skip the check (-C).
autoload -Uz compinit
if [[ -n "$(find ~/.zcompdump -mtime +0 2> /dev/null)" ]]; then
  compinit
else
  compinit -C
fi

# Allow local (private) customizations (not checked in to version control)
[ -f ~/.zsh.local ] && source ~/.zsh.local

# ----- Plugin loading -----

# Direnv: https://github.com/direnv/direnv
command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

# Zoxide (better cd): https://github.com/ajeetdsouza/zoxide
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"

# Mise (Polyglot runtime manager)
command -v mise &> /dev/null && eval "$(mise activate zsh --shims)"

# Fish-like autosuggestions
[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# fzf key bindings and fuzzy completion
command -v fzf &> /dev/null && source $HOME/.config/zsh/fzf.zsh

# Starship prompt (wraps any existing zle-keymap-select)
command -v starship &> /dev/null && source $HOME/.config/zsh/prompt.zsh

# Fish-like syntax highlighting (last: it must load after every widget is created)
[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# installers append PATH lines here; move them to ~/.config/zsh/path.zsh
