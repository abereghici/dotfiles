#!/usr/bin/env bats

# Tests that required commands are available after setup

@test "homebrew is installed" {
  command -v brew
}

@test "mise is available" {
  command -v mise
}

# abereghici/themes, installed by setup/misc.sh
themes="$HOME/.local/share/bereghici"
bereghici="$themes/ports"

@test "bat has the Bereghici themes from its cache" {
  run bat --list-themes --color=never
  [[ $'\n'"$output"$'\n' == *$'\n'bereghici-dark$'\n'* && $'\n'"$output"$'\n' == *$'\n'bereghici-light$'\n'* ]]
}

@test "abereghici/themes' install.sh put the Bereghici themes in place (misc.sh)" {
  [ -x "$themes/install.sh" ]
  [ "$(readlink "$HOME/.config/ghostty/themes")" -ef "$bereghici/ghostty/themes" ]
  [ "$(readlink "$HOME/.config/bat/themes")" -ef "$bereghici/bat/themes" ]
  [ "$(readlink "$HOME/.config/yazi/flavors/bereghici-light.yazi")" -ef "$bereghici/yazi/themes/bereghici-light.yazi" ]
  [ "$(readlink "$HOME/.config/eza/theme.yml")" -ef "$bereghici/eza/themes/bereghici-terminal.yml" ]
  [ "$(readlink "$HOME/.claude/themes/bereghici.json")" -ef "$bereghici/claude-code/themes/bereghici-$(appearance).json" ]
  [ "$(readlink "$HOME/.codex/themes/bereghici.tmTheme")" -ef "$bereghici/codex/themes/bereghici-$(appearance).tmTheme" ]
  cmp -s "$HOME/Library/Fonts/BereghiciSymbols.otf" "$bereghici/font/themes/BereghiciSymbols.otf"
}

@test "the appearance agent is loaded" {
  launchctl print "gui/$UID/dotfiles.appearance-sync" > /dev/null
}

@test "delta gets the Bereghici feature for the current appearance" {
  [ "$(git config delta.features)" = "bereghici-$(appearance)" ]
}

# Tools that can't include a file hold a pasted copy of their Bereghici theme. The checks skip
# comment lines: a reworded header in the generated file isn't a color change
uncommented() { grep -v '^#' "$@"; }

@test "herdr's theme matches the generated Bereghici block (paste it again when it differs)" {
  # From [theme] to the end marker
  diff <(sed -n '/^\[theme\]$/,$p' "$bereghici/herdr/themes/bereghici.toml" | uncommented) \
    <(sed -n '/^\[theme\]$/,/^# End of the pasted Bereghici theme$/p' "$HOME/.config/herdr/config.toml" | uncommented)
}

@test "starship's palette matches the generated Bereghici one (paste it again when it differs)" {
  [[ "$(uncommented "$HOME/.starship.toml")" == *"$(uncommented "$bereghici/starship/themes/bereghici-terminal.toml")"* ]]
}

@test "ripgrep's colors match the generated Bereghici ones (paste them again when they differ)" {
  [[ "$(uncommented "$HOME/.ripgreprc")" == *"$(uncommented "$bereghici/ripgrep/themes/bereghici-terminal.ripgreprc")"* ]]
}

@test "lazydocker's theme matches the generated Bereghici one (paste it again when it differs)" {
  ruby -ryaml -e 'exit YAML.load_file(ARGV[0])["gui"]["theme"] == YAML.load_file(ARGV[1])["gui"]["theme"]' \
    "$bereghici/lazydocker/themes/bereghici-terminal.yml" "$HOME/Library/Application Support/lazydocker/config.yml"
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

@test "an interactive shell expands the starship prompt" {
  # Options the cached tool setup turns on (starship's promptsubst) must outlive cached_init
  # No terminal here, so zsh warns that it can't enable zle; drop that stderr
  run zsh -il -c '[[ -o promptsubst ]] && print -rP -- "$PROMPT"' 2> /dev/null < /dev/null
  [ "$status" -eq 0 ]
  [[ $output != *'$(/'* ]]
}

@test "node and python3 resolve to mise shims in a login shell" {
  [ "$(zsh -l -c 'whence -p node')" = "$HOME/.local/share/mise/shims/node" ]
  [ "$(zsh -l -c 'whence -p python3')" = "$HOME/.local/share/mise/shims/python3" ]
}

@test "herdr links every plugin in herdr/plugins" {
  list=$(herdr plugin list)
  for dir in "$(cd "$BATS_TEST_DIRNAME/.." && pwd)"/herdr/plugins/*; do
    grep -qF "enabled [local:$dir]" <<< "$list"
  done
}

@test "herdr has the reviewr plugin" {
  herdr plugin list | grep -q '^- persiyanov.reviewr (reviewr) enabled'
}

@test "bat is available" { command -v bat; }
@test "herdr is available" { command -v herdr; }
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
