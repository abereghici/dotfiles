#!/usr/bin/env bats

# Tests that required commands are available after setup

@test "homebrew is installed" {
  command -v brew
}

@test "mise is available" {
  command -v mise
}

@test "bat has the rose-pine theme from its cache" {
  bat --list-themes --color=never | grep -qx "rose-pine"
}

@test "dotfiles do not set BAT_THEME (bat's config file picks the theme)" {
  # dotfiles must not set BAT_THEME so the bat config file is used instead
  # -s: $HOME/.zshenv is optional, and bats' `run` captures grep's stderr into $output
  run grep -rs "BAT_THEME" \
    "$HOME/.config/zsh" \
    "$HOME/.zshrc" \
    "$HOME/.zshenv"
  [ "$output" = "" ]
}

@test "node and python3 resolve to mise shims in a login shell" {
  [ "$(zsh -l -c 'whence -p node')" = "$HOME/.local/share/mise/shims/node" ]
  [ "$(zsh -l -c 'whence -p python3')" = "$HOME/.local/share/mise/shims/python3" ]
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
