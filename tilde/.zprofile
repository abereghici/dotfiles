# Login shells run this before .zshrc, and non-interactive ones (`zsh -l -c` in tmux popups)
# never reach .zshrc. Put mise shims first so node and python come from mise, not from the
# Homebrew node/python3 that mermaid-cli and nmap pull in, or /usr/bin/python3.
# Each tool's setup comes from cached_init's cache, not a process per tool on each start.
# Interactive shells inherit this environment, so .zshrc doesn't repeat it.
fpath=("$HOME/.config/zsh/functions" $fpath)
autoload -Uz cached_init
cached_init brew-shellenv /opt/homebrew/bin/brew shellenv || cached_init brew-shellenv /usr/local/bin/brew shellenv
cached_init mise mise activate zsh --shims
# Environment (editor, fzf theme...) for those `zsh -l -c` popups; .zshrc sources it again,
# so a long-running tmux or herdr server never hands them stale values
source "$HOME/.config/zsh/env.zsh"

# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:$HOME/.docker/bin"
# End of Docker Desktop section.
