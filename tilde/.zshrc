eval "$(/opt/homebrew/bin/brew shellenv)"

# Initialize zsh completion system (was previously handled by oh-my-zsh)
autoload -Uz compinit && compinit -C

# ----- Direnv  -----
# https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

# ---- Zoxide (better cd) ----
# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# ---- Mise (Polyglot runtime manager) ----
eval "$(mise activate zsh --shims)"

# Fish-like autosuggestions (from Homebrew)
[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Fish-like syntax highlighting (from Homebrew)
[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source $HOME/.config/zsh/path.zsh
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/keybindings.zsh

# Allow local (private) customizations (not checked in to version control)
[ -f ~/.zsh.local ] && source ~/.zsh.local

# Enable fzf: https://github.com/junegunn/fzf
if [ $(command -v "fzf") ]; then
  source $HOME/.config/zsh/fzf.zsh
fi

# Enable ngrok autocompletions
if [ $(command -v "ngrok") ]; then
  eval "$(ngrok completion)"
fi

# Starship prompt (needs to be at the end)
if [ $(command -v "starship") ]; then
  source $HOME/.config/zsh/prompt.zsh
fi

# Load Angular CLI autocompletion.
if [ $(command -v "ng") ]; then
  source <(ng completion script)
fi
