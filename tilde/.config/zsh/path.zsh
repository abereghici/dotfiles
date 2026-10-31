# Prepend PATH by skipping duplicates
declare -U PATH

prepend() {
  [ -d "$1" ] && PATH="$1:$PATH"
}

# User binaries
prepend "/usr/local/bin"
prepend "$HOME/.local/bin"

# Project binaries go last, so a cloned repo's node_modules/.bin cannot shadow system tools.
# Not via prepend: its -d check would resolve this against the shell's startup cwd
PATH="$PATH:./node_modules/.bin"

# Add rustup
prepend "$HOME/.cargo/bin"

# PNPM_HOME is the store root; the global bin dir is the `bin` under it
export PNPM_HOME="$HOME/Library/pnpm"
prepend "$PNPM_HOME/bin"

# Prevent it from being used accidentally elsewhere in the script or by other scripts
unfunction prepend

export PATH
