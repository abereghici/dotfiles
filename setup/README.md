# Setup scripts

[`setup.sh`](../setup.sh) runs `brew.sh`, `symlinks.sh`, `local.sh` (skipped
with `-y`) and `misc.sh`, in that order. Each script can also run on its own, is
safe to run again, and reports a failed step instead of stopping the ones after
it. `macos.sh` and `uninstall.sh` only run when you run them.

## `setup.sh [-y]`

Moves a real `~/.zshrc` aside (`~/.zshrc.backup`, timestamped when that exists),
creates `/etc/pam.d/sudo_local` for Touch ID, asks for `sudo` once and keeps it
alive, then runs the scripts below. `-y` sets `DOTFILES_YES=1` and
`NONINTERACTIVE=1`: no prompt from setup, Homebrew's installer or `symlinks.sh`,
and `local.sh` is skipped. Without `-y` it needs a terminal to ask in.

## `brew.sh`

Installs Homebrew if `brew` isn't found, loads the `HOMEBREW_*` settings from
[`env.zsh`](../tilde/.config/zsh/env.zsh), runs `brew update` and
`brew upgrade`, installs the [Brewfile](Brewfile) with `brew bundle` and runs
`brew cleanup`.

## `symlinks.sh`

- Links each item of [`tilde/`](../tilde/) into `~` and each item of
  `tilde/.config` into `~/.config`.
- Links the [lazygit](../lazygit/config.yml) and
  [lazydocker](../lazydocker/config.yml) configs and the [VS Code](../vscode/)
  settings and snippets into `~/Library/Application Support`, the
  [keyboard layout](../keyboard/README.md) into `~/Library/Keyboard Layouts`,
  and [`bin/`](../bin/) into `~/.local/bin`.
- Asks what to do with a file already in the way: skip, overwrite or back up,
  once or for all. Without a terminal (or with `-y`) it backs up every one. A
  backup never replaces an earlier one, and a real directory is never linked
  into.
- Deletes links in `~`, `~/.config` and `~/.local/bin` that point into this
  repository at files that no longer exist.
- Installs the [appearance agent](../docs/appearance.md) in
  `~/Library/LaunchAgents` and loads it with `launchctl`.

## `local.sh`

Asks for this machine's private settings and writes the untracked files
described in [Local customizations](../README.md#local-customizations), mode
600: `~/.gitconfig.local` (and `~/.gitconfig.work`), `~/.zsh.local` (storing
secrets in the Keychain), `~/.macos.local`, `reviewr.local.toml` and mise's
`config.local.toml`. Every answer may be empty; existing files are kept. Without
a terminal it does nothing.

## `misc.sh`

1. Clones tpm and installs the tmux plugins.
1. Links the [herdr plugins](../herdr/plugins/) and installs
   [herdr-reviewr](https://github.com/persiyanov/herdr-reviewr) (skipped when
   herdr isn't installed).
1. Installs the [mise](../tilde/.config/mise/config.toml) runtimes and npm
   packages.
1. Clones [abereghici/themes](https://github.com/abereghici/themes) into
   `~/.local/share/bereghici`, or pulls it (a symlink there is left alone), and
   runs its `install.sh`.
1. Runs [`appearance sync`](../docs/appearance.md).

## `macos.sh`

macOS defaults, based on [mths.be/macos](https://mths.be/macos); see
[docs/macos.md](../docs/macos.md) for what it changes.

## `uninstall.sh [-n]`

Removes the links into this repository and into the themes, the appearance agent
and the herdr plugins linked from here; lists the backups to restore and asks
before removing `/etc/pam.d/sudo_local`. `-n` only prints what it would remove.

## Tests

[`tests/`](../tests/) checks an installed machine (`npm test`; nothing is
changed). [`tests/fresh/`](../tests/fresh/) runs `symlinks.sh` and
`uninstall.sh` against an empty temporary `HOME` (`bats tests/fresh`); CI runs
it on macOS.
