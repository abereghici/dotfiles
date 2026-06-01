#!/usr/bin/env zsh

bindkey -e # emacs mode (enables ^P, ^N, ^A, ^E, etc.)

bindkey '^I' complete-word        # tab          | complete
bindkey '^[[Z' autosuggest-accept # shift + tab  | autosuggest
