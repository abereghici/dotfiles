#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")/.."

DOTFILES_DIR="$(pwd)"
TILDE_DIR="$DOTFILES_DIR/tilde"

echo "Tilde dir"
echo $TILDE_DIR

EXCLUDE_FILES=(".DS_Store" "Brewfile.lock.json" "README.md")

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

fail() {
	printf "\r\033[2K  [\033[0;31m✖\033[0m] $1\n"
	echo ''
	exit
}

symlink_file() {
	local src=$1 dst=$2

	local overwrite
	local backup
	local skip
	local action

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
		ln -sf "$1" "$2"
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

install_dotfiles() {
	info 'Installing dotfiles...'

	local overwrite_all=false
	local backup_all=false
	local skip_all=false

	# Create .config directory if it doesn't exist
	mkdir -p ~/.config

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
	symlink_file "$DOTFILES_DIR/lazygit/state.yml" "$HOME/Library/Application Support/lazygit/state.yml"
}

install_custom_bin() {

	cd "$DOTFILES_DIR/bin"

	# Loop through all items in the `bin` directory
	for item in *; do
		src="$PWD/$item"
		dest="$HOME/.local/bin/$item"
		symlink_file "$src" "$dest"
	done

}

install_dotfiles
install_extras
install_custom_bin
echo
echo 'Done!' | indent
