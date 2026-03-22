#!/usr/bin/env bats

# Tests that required commands are available after setup

@test "homebrew is installed" {
  command -v brew
}

@test "mise is available" {
  command -v mise
}

@test "bat uses rose-pine-moon theme (no BAT_THEME in dotfiles)" {
  # dotfiles must not set BAT_THEME so the bat config file is used instead
  run grep -r "BAT_THEME" \
    "$HOME/.config/zsh" \
    "$HOME/.zshrc" \
    "$HOME/.zshenv" \
    2>/dev/null
  [ "$output" = "" ]
}

@test "bat is available" { command -v bat; }
@test "curl is available" { command -v curl; }
@test "direnv is available" { command -v direnv; }
@test "eza is available" { command -v eza; }
@test "fd is available" { command -v fd; }
@test "fzf is available" { command -v fzf; }
@test "gh is available" { command -v gh; }
@test "git is available" { command -v git; }
@test "jq is available" { command -v jq; }
@test "lazydocker is available" { command -v lazydocker; }
@test "lazygit is available" { command -v lazygit; }
@test "nvim is available" { command -v nvim; }
@test "pnpm is available" { command -v pnpm; }
@test "rg is available" { command -v rg; }
@test "starship is available" { command -v starship; }
@test "tmux is available" { command -v tmux; }
@test "wget is available" { command -v wget; }
@test "yazi is available" { command -v yazi; }
@test "zoxide is available" { command -v zoxide; }
