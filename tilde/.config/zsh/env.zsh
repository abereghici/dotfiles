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

# fzf: fd as the file walker, Rosé Pine (main) theme
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:-1,hl:#ebbcba
	--color=fg+:#e0def4,bg+:-1,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:-1
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
	--color=label:#908caa
	--gutter=' '" # gutter:-1 would draw its ▌ bar in the default text color on every row
