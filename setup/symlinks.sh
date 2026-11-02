#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

DOTFILES_DIR="$(pwd)"
TILDE_DIR="$DOTFILES_DIR/tilde"

EXCLUDE_FILES=(".DS_Store")

# Shared by every symlink_file call; set by the [O]verwrite/[B]ackup/[S]kip all answers
overwrite_all=false
backup_all=false
skip_all=false

indent() {
  sed 's/^/  /'
}

info() {
  printf "[ \033[00;34m..\033[0m ] $1" | indent
  echo
}

user() {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success() {
  printf "\r\033[2K  [ \033[00;32m✔\033[0m ] $1\n"
}

symlink_file() {
  local src=$1 dst=$2

  # Set by handle_existing_file; empty (not unset) so `set -u` allows reading them
  local overwrite="" backup="" skip="" action=""

  if [ ! -d "$(dirname "$dst")" ]; then
    mkdir -p "$(dirname "$dst")"
  fi

  # First, check if the destination file or folder exists
  if [ -e "$dst" ]; then

    # Check if the destination is a symlink
    if [ -L "$dst" ]; then

      # Check if the destination is already a symlink to the dotfiles
      readlink_out=$(readlink "$dst")
      local current_src="$readlink_out"

      if [ "$current_src" == "$src" ]; then
        # Skip overwriting
        skip=true
      else
        # If the destination is a symlink to something else, ask to overwrite
        handle_existing_file
      fi

    else

      # If the destination is a regular file or directory, ask to overwrite
      handle_existing_file

    fi

  fi

  # "false" or empty
  if [ "$skip" != "true" ]; then
    ln -sfn "$1" "$2"
    success "linked $1 to $2"
  else
    success "skipped $src"
  fi
}

handle_existing_file() {
  if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
    user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
    [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
    read -n 1 action

    case "$action" in
      o)
        overwrite=true
        ;;
      O)
        overwrite_all=true
        ;;
      b)
        backup=true
        ;;
      B)
        backup_all=true
        ;;
      s)
        skip=true
        ;;
      S)
        skip_all=true
        ;;
      *) ;;

    esac
  fi

  overwrite=${overwrite:-$overwrite_all}
  backup=${backup:-$backup_all}
  skip=${skip:-$skip_all}

  if [ "$overwrite" == "true" ]; then
    rm -rf "$dst"
    success "removed $dst"
  fi

  if [ "$backup" == "true" ]; then
    mv "$dst" "${dst}.backup"
    success "moved $dst to ${dst}.backup"
  fi
}

# Delete the links in each directory that point into this repo but whose target is gone
remove_dangling_links() {
  find "$@" -maxdepth 1 -type l -lname "$DOTFILES_DIR/*" ! -exec test -e {} \; -print -delete 2> /dev/null | sed 's/^/removed dangling link /' | indent || true
}

install_dotfiles() {
  info 'Installing dotfiles...'

  # Create .config directory if it doesn't exist
  mkdir -p ~/.config

  # Remove links to dotfiles that no longer exist in tilde/
  remove_dangling_links "$HOME" "$HOME/.config"

  cd "$TILDE_DIR"

  # Loop through all items in the `tilde` directory
  for item in .* *; do
    # Skip the current and parent directory entries
    if [ "$item" == "." ] || [ "$item" == ".." ]; then
      continue
    fi

    # Ignore exclude files
    for excluded in "${EXCLUDE_FILES[@]}"; do
      if [[ "$item" == "$excluded" ]]; then
        # Skip to the next iteration of the outer loop
        continue 2
      fi
    done

    # is a dotfile
    if [ -f "$item" ]; then
      src="$PWD/$item"
      dest="$HOME/$item"
      symlink_file "$src" "$dest"
    # is a dir with dotfiles
    elif [ -d "$item" ]; then
      if [ "$item" != ".config" ]; then
        src="$PWD/$item"
        dest="$HOME/$item"
        symlink_file "$src" "$dest"
      else
        # Handle the `.config` dir separately
        for config_item in "$item"/*; do
          src="$PWD/$config_item"
          dest="$HOME/$config_item"
          symlink_file "$src" "$dest"
        done
      fi
    fi
  done
}

install_extras() {
  # Lazydocker
  symlink_file "$DOTFILES_DIR/lazydocker/config.yml" "$HOME/Library/Application Support/lazydocker/config.yml"

  # Lazygit
  symlink_file "$DOTFILES_DIR/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"

  # VS Code (extensions are the vscode entries in setup/Brewfile)
  local vscode_user="$HOME/Library/Application Support/Code/User"
  symlink_file "$DOTFILES_DIR/vscode/settings.json" "$vscode_user/settings.json"
  symlink_file "$DOTFILES_DIR/vscode/snippets" "$vscode_user/snippets"

  # Keyboard layout
  symlink_file "$DOTFILES_DIR/keyboard/ABC-Romanian.keylayout" "$HOME/Library/Keyboard Layouts/ABC-Romanian.keylayout"
}

install_custom_bin() {

  cd "$DOTFILES_DIR/bin"

  # Remove links to scripts that no longer exist in bin/
  remove_dangling_links "$HOME/.local/bin"

  # Loop through all items in the `bin` directory
  for item in *; do
    src="$PWD/$item"
    dest="$HOME/.local/bin/$item"
    symlink_file "$src" "$dest"
  done

}

# Runs `appearance sync` whenever macOS changes appearance by itself (Auto at sunset, Control
# Center), for the tools with one theme setting. A copy with ~ spelled out, not a link: launchd
# wants a real file and full paths
install_appearance_agent() {
  local plist="$HOME/Library/LaunchAgents/dotfiles.appearance-sync.plist"
  local agent

  agent=$(sed "s|~/|$HOME/|" "$DOTFILES_DIR/launchd/dotfiles.appearance-sync.plist")
  [ "$agent" = "$(cat "$plist" 2> /dev/null)" ] && return
  mkdir -p "$(dirname "$plist")"
  echo "$agent" > "$plist"
  launchctl bootout "gui/$UID" "$plist" 2> /dev/null || true
  launchctl bootstrap "gui/$UID" "$plist"
  echo "loaded $plist" | indent
}

install_dotfiles
install_extras
install_custom_bin
install_appearance_agent
echo
echo 'Done!' | indent
