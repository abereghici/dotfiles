# ----- Direnv  -----
# https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

# ----- Fnm (node manager) -----
# https://github.com/Schniz/fnm
eval "$(fnm env --use-on-cd)"

# ---- Zoxide (better cd) ----
# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# ----- Homebrew -----
# https://brew.sh
(
  echo
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
) >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# ----- oh-my-zsh  -----
# https://github.com/ohmyzsh/ohmyzsh
# Activate Fish-like autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#homebrew
[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Enable Fish-like syntax highlighting: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

plugins=(git)

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

source $HOME/.config/zsh/path.zsh
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/aliases.zsh

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

