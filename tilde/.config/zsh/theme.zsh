# Bereghici for zsh-syntax-highlighting and zsh-autosuggestions, from abereghici/themes (installed
# by setup/misc.sh), in the terminal's ANSI colors so it switches between Dark and Light with
# Ghostty. Interactive shells only, so sourced by .zshrc before the zsh plugins; the tools that
# read their colors from the environment get theirs in env.zsh.

theme="$HOME/.local/share/bereghici/ports/zsh/themes/bereghici-terminal.zsh"
[ -e "$theme" ] && source "$theme"
unset theme
