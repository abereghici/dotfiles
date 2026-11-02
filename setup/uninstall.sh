#!/bin/bash
#
# Undo what setup changed in your home directory: the links into this repo and into the
# Bereghici themes, the appearance agent and the herdr plugins linked from here. Lists the
# backups setup made (restore the ones you want by hand), and asks before removing the
# Touch ID sudo file. Homebrew, its packages and the macOS defaults stay.
#
# `setup/uninstall.sh`, or `setup/uninstall.sh -n` to only print what it would remove.
#
# ---

set -euo pipefail

cd "$(dirname "$0")/.."

DOTFILES_DIR="$(pwd)"
THEMES="$HOME/.local/share/bereghici"
dry_run=false
[ "${1:-}" = -n ] && dry_run=true

remove() {
  if $dry_run; then
    echo "  would remove $1"
  else
    command rm -f "$1"
    echo "  removed $1"
  fi
}

echo "Links into $DOTFILES_DIR and the themes:"
targets=("$DOTFILES_DIR/*" "$THEMES/*")
# The themes clone may be a link to a checkout elsewhere: links can point at either path
[ -L "$THEMES" ] && targets+=("$(cd "$THEMES" && pwd -P)/*")
dirs=(
  "$HOME" "$HOME/.config" "$HOME/.local/bin" "$HOME/.claude/themes" "$HOME/.codex/themes"
  "$HOME/.config/eza" "$HOME/.config/yazi/flavors"
  "$HOME/Library/Application Support/lazygit" "$HOME/Library/Application Support/lazydocker"
  "$HOME/Library/Application Support/Code/User" "$HOME/Library/Keyboard Layouts"
)
for dir in "${dirs[@]}"; do
  [ -d "$dir" ] || continue
  for target in "${targets[@]}"; do
    find "$dir" -maxdepth 1 -type l -lname "$target" -print0
  done
done | while IFS= read -r -d '' link; do
  remove "$link"
done

echo "Appearance agent:"
agent="$HOME/Library/LaunchAgents/dotfiles.appearance-sync.plist"
if [ -e "$agent" ]; then
  $dry_run || launchctl bootout "gui/$UID" "$agent" 2> /dev/null || true
  remove "$agent"
fi

if command -v herdr > /dev/null; then
  echo "herdr plugins linked from herdr/plugins:"
  for plugin in herdr/plugins/*/; do
    id=$(awk -F'"' '/^id = /{ print $2; exit }' "$plugin/herdr-plugin.toml") # the plugin's, not its actions
    if $dry_run; then
      echo "  would unlink $id"
    else
      herdr plugin unlink "$id" > /dev/null 2>&1 && echo "  unlinked $id" || true
    fi
  done
fi

echo "Backups setup made (restore with mv, e.g. mv ~/.zshrc.backup ~/.zshrc):"
find "$HOME" "$HOME/.config" -maxdepth 1 -name '*.backup*' 2> /dev/null | sed 's/^/  /'

if [ -f /etc/pam.d/sudo_local ] && ! $dry_run && [ -t 0 ]; then
  read -r -p "Remove /etc/pam.d/sudo_local (Touch ID for sudo)? [y/N] " answer
  [[ $answer == [yY]* ]] && sudo rm /etc/pam.d/sudo_local && echo "  removed /etc/pam.d/sudo_local"
fi

echo
echo "Left in place: Homebrew and its packages (brew uninstall what you don't need), the themes"
echo "clone ($THEMES), the BereghiciSymbols font, the *.local files and the macOS defaults."
