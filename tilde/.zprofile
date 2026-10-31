# Login shells run this before .zshrc, and non-interactive ones (`zsh -l -c` in tmux popups)
# never reach .zshrc. Put mise shims first so node and python come from mise, not from the
# Homebrew node/python3 that mermaid-cli and nmap pull in, or /usr/bin/python3.
eval "$(/opt/homebrew/bin/brew shellenv)"
command -v mise &> /dev/null && eval "$(mise activate zsh --shims)"

# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:$HOME/.docker/bin"
# End of Docker Desktop section.
