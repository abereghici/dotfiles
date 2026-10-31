# Set editor to nvim
export VISUAL=nvim
export EDITOR=$VISUAL

# Prevent Ctrl+D from closing the shell (and tmux windows/panes) accidentally
setopt IGNOREEOF

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# ripgrep reads a config file only when this points at it
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Skip the automatic `brew update` before install/upgrade/tap and opt out of analytics
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
# Apps that update themselves (Claude, Docker, Ghostty, VS Code...) stay out of `brew upgrade`
export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS=1
export HOMEBREW_NO_ENV_HINTS=1
# Language runtimes come from mise (~/.config/mise/config.toml); Homebrew refuses them and
# any formula that needs them at runtime
export HOMEBREW_FORBIDDEN_FORMULAE="go openjdk openjdk@21 maven rust"
