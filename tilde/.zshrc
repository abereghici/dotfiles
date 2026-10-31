# Homebrew and mise come from .zprofile: login shells run it first, and other shells inherit
# its environment. cached_init caches each tool's generated setup (functions/cached_init).
typeset -U fpath
fpath=("$HOME/.config/zsh/functions" $fpath)
autoload -Uz cached_init

# Load path, env, aliases and keybindings
source $HOME/.config/zsh/path.zsh
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/keybindings.zsh

# Initialize zsh completion system AFTER fpath is fully set. Rebuild the dump when it is
# over a day old so newly installed completions load; otherwise skip the check (-C).
# zstat and EPOCHSECONDS are builtins, so the age check spawns no process.
autoload -Uz compinit
zmodload -F zsh/stat b:zstat
zmodload zsh/datetime
zcompdump_mtime=(0)
zstat -A zcompdump_mtime +mtime ~/.zcompdump 2> /dev/null
if ((EPOCHSECONDS - zcompdump_mtime[1] > 86400)); then
  compinit
else
  compinit -C
fi
unset zcompdump_mtime
# Load the dump compiled (.zwc), rebuilding that whenever compinit rewrote the dump
[[ ~/.zcompdump.zwc -nt ~/.zcompdump ]] || zcompile ~/.zcompdump

# Allow local (private) customizations (not checked in to version control)
[ -f ~/.zsh.local ] && source ~/.zsh.local

# ----- Plugin loading -----

# Direnv: https://github.com/direnv/direnv
cached_init direnv direnv hook zsh

# Zoxide (better cd): https://github.com/ajeetdsouza/zoxide
cached_init zoxide zoxide init zsh

# Fish-like autosuggestions
[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# fzf key bindings and fuzzy completion
[[ -n ${commands[fzf]} ]] && source $HOME/.config/zsh/fzf.zsh

# Starship prompt (wraps any existing zle-keymap-select)
[[ -n ${commands[starship]} ]] && source $HOME/.config/zsh/prompt.zsh

# Fish-like syntax highlighting (last: it must load after every widget is created)
[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# installers append PATH lines here; move them to ~/.config/zsh/path.zsh
