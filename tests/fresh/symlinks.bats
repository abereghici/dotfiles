#!/usr/bin/env bats

# setup/symlinks.sh on a fresh machine: an empty HOME with a few files already in the way, linked
# without a terminal (as `setup.sh -y` runs it), then again. Changes nothing outside that HOME:
# launchctl is a stub. CI runs it on macOS; locally: `bats tests/fresh`.

setup_file() {
  export REPO="$BATS_TEST_DIRNAME/../.."
  export FAKE="$BATS_FILE_TMPDIR"
  export HOME="$FAKE/home"
  mkdir -p "$HOME/.config/nvim" "$FAKE/stub"
  printf '#!/bin/sh\necho "$*" >> "%s/launchctl.log"\n' "$FAKE" > "$FAKE/stub/launchctl"
  chmod +x "$FAKE/stub/launchctl"

  echo mine > "$HOME/.config/nvim/init.lua"
  echo current > "$HOME/.gitconfig"
  echo earlier > "$HOME/.gitconfig.backup"

  PATH="$FAKE/stub:$PATH" "$REPO/setup/symlinks.sh" < /dev/null > "$FAKE/run1.log" 2>&1
  PATH="$FAKE/stub:$PATH" "$REPO/setup/symlinks.sh" < /dev/null > "$FAKE/run2.log" 2>&1
}

@test "every file in tilde/ is linked into HOME" {
  for item in "$REPO"/tilde/.[!.]* "$REPO"/tilde/.config/*; do
    [ "$(basename "$item")" = .config ] && continue
    [ "$(basename "$item")" = .DS_Store ] && continue
    dest="$HOME/${item#"$REPO"/tilde/}"
    [ -L "$dest" ] && [ "$dest" -ef "$item" ]
  done
}

@test "bin/ scripts are linked into ~/.local/bin" {
  for script in "$REPO"/bin/*; do
    [ "$HOME/.local/bin/$(basename "$script")" -ef "$script" ]
  done
}

@test "a file in the way is backed up, never over an earlier backup" {
  [ "$(cat "$HOME/.gitconfig.backup")" = earlier ]
  [ "$(cat "$HOME"/.gitconfig.backup.*)" = current ]
}

@test "a directory in the way is backed up whole" {
  [ "$(cat "$HOME/.config/nvim.backup/init.lua")" = mine ]
  [ -L "$HOME/.config/nvim" ]
}

@test "the appearance agent is installed with HOME spelled out, and loaded" {
  plist="$HOME/Library/LaunchAgents/dotfiles.appearance-sync.plist"
  grep -q "<string>$HOME/Library/Preferences/.GlobalPreferences.plist</string>" "$plist"
  plutil -lint "$plist"
  grep -q "^bootstrap gui/" "$FAKE/launchctl.log"
}

@test "a second run changes nothing" {
  ! grep -Eq 'linked|moved|removed' "$FAKE/run2.log"
}
