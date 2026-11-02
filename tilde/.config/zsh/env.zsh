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

# lazygit merges these in order: the dotfiles config, then the Bereghici theme (abereghici/themes,
# installed by setup/misc.sh). It refuses to start on a missing file, so the theme is added
# when installed.
export LG_CONFIG_FILE="$HOME/Library/Application Support/lazygit/config.yml"
lazygit_theme="$HOME/.local/share/bereghici/ports/lazygit/themes/bereghici.yml"
if [ -e "$lazygit_theme" ]; then
  LG_CONFIG_FILE+=",$lazygit_theme"
fi
unset lazygit_theme

# fzf: fd as the file walker (theme.zsh adds the Bereghici colors)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--gutter=' '" # the default ▌ gutter bar would show on every row
