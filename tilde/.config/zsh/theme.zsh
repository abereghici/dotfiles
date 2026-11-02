# Bereghici for the shell and its tools, from abereghici/themes (installed by setup/misc.sh). Each
# is the terminal flavor, in the terminal's ANSI colors, so it switches between Dark and Light
# with Ghostty. Sourced after env.zsh (fzf adds to its options) and before the zsh plugins.

bereghici="$HOME/.local/share/bereghici/ports"

if [ -d "$bereghici" ]; then
  source "$bereghici/fzf/themes/bereghici-terminal.sh"
  source "$bereghici/jq/themes/bereghici-terminal.sh"
  source "$bereghici/ls-colors/themes/bereghici-terminal.sh"
  source "$bereghici/zsh/themes/bereghici-terminal.zsh"
  # gh, glab and glow render Markdown with it
  export GLAMOUR_STYLE="$bereghici/glamour/themes/bereghici-terminal.json"
fi

unset bereghici
