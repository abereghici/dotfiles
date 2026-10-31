# Setup Scripts

`setup.sh` runs `brew`, `symlinks`, then `misc`. Run `macos` on its own.

## brew

Installs Homebrew, packages, applications using [Brewfile](./Brewfile).

## macos

Sane macOS defaults. Based on [~/.macos](https://mths.be/macos) by Mathias Bynens.

## symlinks

Creates symlinks to dotfiles by placing them in a home directory.

## misc

Installs the tmux plugin manager, the [mise](../tilde/.config/mise/config.toml) runtimes and global npm packages, and builds bat's theme cache.
