# Prepend PATH by skipping duplicates
declare -U PATH

prepend() {
  [ -d "$1" ] && PATH="$1:$PATH"
}

# User binaries
prepend "/usr/local/bin"
prepend "$HOME/.local/bin"
prepend "$HOME/bin"

#  the current directory's node_modules/.bin
prepend "./node_modules/.bin"

# Add rustup
prepend "$HOME/.cargo/bin"

# Add fnm
prepend "$HOME/.local/share/fnm"

# Prevent it from being used accidentally elsewhere in the script or by other scripts
unset prepend

export PATH
