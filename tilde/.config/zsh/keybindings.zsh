bindkey -e # emacs keybindings (zsh would pick vi because EDITOR is nvim)

bindkey '^I' complete-word        # tab          | complete (fzf.zsh rebinds it; this stays as fzf's fallback)
bindkey '^[[Z' autosuggest-accept # shift + tab  | autosuggest

# Edit current command line in $EDITOR (zsh has no default binding for this)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line # ctrl-x ctrl-e
