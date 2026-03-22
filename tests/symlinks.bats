#!/usr/bin/env bats

DOTFILES_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
TILDE_DIR="$DOTFILES_DIR/tilde"

# ---------------------------------------------------------------------------
# Sanity check
# ---------------------------------------------------------------------------

@test "tilde directory exists" {
  [ -d "$TILDE_DIR" ]
}

# ---------------------------------------------------------------------------
# Top-level tilde items
# ---------------------------------------------------------------------------

@test ".claude is symlinked to tilde/.claude" {
  [ -L "$HOME/.claude" ]
  [ "$(readlink "$HOME/.claude")" = "$TILDE_DIR/.claude" ]
}

@test ".curlrc is symlinked to tilde/.curlrc" {
  [ -L "$HOME/.curlrc" ]
  [ "$(readlink "$HOME/.curlrc")" = "$TILDE_DIR/.curlrc" ]
}

@test ".gitconfig is symlinked to tilde/.gitconfig" {
  [ -L "$HOME/.gitconfig" ]
  [ "$(readlink "$HOME/.gitconfig")" = "$TILDE_DIR/.gitconfig" ]
}

@test ".gitignore is symlinked to tilde/.gitignore" {
  [ -L "$HOME/.gitignore" ]
  [ "$(readlink "$HOME/.gitignore")" = "$TILDE_DIR/.gitignore" ]
}

@test ".gitmessage is symlinked to tilde/.gitmessage" {
  [ -L "$HOME/.gitmessage" ]
  [ "$(readlink "$HOME/.gitmessage")" = "$TILDE_DIR/.gitmessage" ]
}

@test ".ripgreprc is symlinked to tilde/.ripgreprc" {
  [ -L "$HOME/.ripgreprc" ]
  [ "$(readlink "$HOME/.ripgreprc")" = "$TILDE_DIR/.ripgreprc" ]
}

@test ".starship.toml is symlinked to tilde/.starship.toml" {
  [ -L "$HOME/.starship.toml" ]
  [ "$(readlink "$HOME/.starship.toml")" = "$TILDE_DIR/.starship.toml" ]
}

@test ".themes.gitconfig is symlinked to tilde/.themes.gitconfig" {
  [ -L "$HOME/.themes.gitconfig" ]
  [ "$(readlink "$HOME/.themes.gitconfig")" = "$TILDE_DIR/.themes.gitconfig" ]
}

@test ".zshrc is symlinked to tilde/.zshrc" {
  [ -L "$HOME/.zshrc" ]
  [ "$(readlink "$HOME/.zshrc")" = "$TILDE_DIR/.zshrc" ]
}

# ---------------------------------------------------------------------------
# .config subdirectories
# ---------------------------------------------------------------------------

@test ".config/aerospace is symlinked to tilde/.config/aerospace" {
  [ -L "$HOME/.config/aerospace" ]
  [ "$(readlink "$HOME/.config/aerospace")" = "$TILDE_DIR/.config/aerospace" ]
}

@test ".config/bat is symlinked to tilde/.config/bat" {
  [ -L "$HOME/.config/bat" ]
  [ "$(readlink "$HOME/.config/bat")" = "$TILDE_DIR/.config/bat" ]
}

@test ".config/ghostty is symlinked to tilde/.config/ghostty" {
  [ -L "$HOME/.config/ghostty" ]
  [ "$(readlink "$HOME/.config/ghostty")" = "$TILDE_DIR/.config/ghostty" ]
}

@test ".config/karabiner is symlinked to tilde/.config/karabiner" {
  [ -L "$HOME/.config/karabiner" ]
  [ "$(readlink "$HOME/.config/karabiner")" = "$TILDE_DIR/.config/karabiner" ]
}

@test ".config/nvim is symlinked to tilde/.config/nvim" {
  [ -L "$HOME/.config/nvim" ]
  [ "$(readlink "$HOME/.config/nvim")" = "$TILDE_DIR/.config/nvim" ]
}

@test ".config/opencode is symlinked to tilde/.config/opencode" {
  [ -L "$HOME/.config/opencode" ]
  [ "$(readlink "$HOME/.config/opencode")" = "$TILDE_DIR/.config/opencode" ]
}

@test ".config/tmux is symlinked to tilde/.config/tmux" {
  [ -L "$HOME/.config/tmux" ]
  [ "$(readlink "$HOME/.config/tmux")" = "$TILDE_DIR/.config/tmux" ]
}

@test ".config/zsh is symlinked to tilde/.config/zsh" {
  [ -L "$HOME/.config/zsh" ]
  [ "$(readlink "$HOME/.config/zsh")" = "$TILDE_DIR/.config/zsh" ]
}
