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

@test ".zprofile is symlinked to tilde/.zprofile" {
  [ -L "$HOME/.zprofile" ]
  [ "$(readlink "$HOME/.zprofile")" = "$TILDE_DIR/.zprofile" ]
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

@test ".config/herdr is symlinked to tilde/.config/herdr" {
  [ -L "$HOME/.config/herdr" ]
  [ "$(readlink "$HOME/.config/herdr")" = "$TILDE_DIR/.config/herdr" ]
}

@test ".config/nvim is symlinked to tilde/.config/nvim" {
  [ -L "$HOME/.config/nvim" ]
  [ "$(readlink "$HOME/.config/nvim")" = "$TILDE_DIR/.config/nvim" ]
}

@test ".config/mise is symlinked to tilde/.config/mise" {
  [ -L "$HOME/.config/mise" ]
  [ "$(readlink "$HOME/.config/mise")" = "$TILDE_DIR/.config/mise" ]
}

@test ".config/tmux is symlinked to tilde/.config/tmux" {
  [ -L "$HOME/.config/tmux" ]
  [ "$(readlink "$HOME/.config/tmux")" = "$TILDE_DIR/.config/tmux" ]
}

@test ".config/zsh is symlinked to tilde/.config/zsh" {
  [ -L "$HOME/.config/zsh" ]
  [ "$(readlink "$HOME/.config/zsh")" = "$TILDE_DIR/.config/zsh" ]
}

# ---------------------------------------------------------------------------
# Extras and custom binaries
# ---------------------------------------------------------------------------

@test "lazygit config is symlinked to lazygit/config.yml" {
  f="$HOME/Library/Application Support/lazygit/config.yml"
  [ -L "$f" ]
  [ "$(readlink "$f")" = "$DOTFILES_DIR/lazygit/config.yml" ]
}

@test "lazydocker config is symlinked to lazydocker/config.yml" {
  f="$HOME/Library/Application Support/lazydocker/config.yml"
  [ -L "$f" ]
  [ "$(readlink "$f")" = "$DOTFILES_DIR/lazydocker/config.yml" ]
}

@test "VS Code settings, keybindings and snippets are symlinked to vscode/" {
  dir="$HOME/Library/Application Support/Code/User"
  for f in settings.json keybindings.json snippets; do
    [ -L "$dir/$f" ]
    [ "$(readlink "$dir/$f")" = "$DOTFILES_DIR/vscode/$f" ]
  done
}

@test "ABC – Romanian keyboard layout is symlinked to keyboard/ABC-Romanian.keylayout" {
  f="$HOME/Library/Keyboard Layouts/ABC-Romanian.keylayout"
  [ -L "$f" ]
  [ "$(readlink "$f")" = "$DOTFILES_DIR/keyboard/ABC-Romanian.keylayout" ]
}

@test "every bin/ script is symlinked into ~/.local/bin" {
  for f in "$DOTFILES_DIR"/bin/*; do
    [ "$(readlink "$HOME/.local/bin/$(basename "$f")")" = "$f" ]
  done
}

@test "~/.local/bin has no dangling links into the dotfiles" {
  run find "$HOME/.local/bin" -maxdepth 1 -type l -lname "$DOTFILES_DIR/*" ! -exec test -e {} \; -print
  [ "$output" = "" ]
}
