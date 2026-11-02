# Theme and appearance

Every themed tool uses **Bereghici Dark** or **Bereghici Light** from
[abereghici/themes](https://github.com/abereghici/themes), and follows the macOS
appearance: switch it in System Settings or Control Center, or with `⌥⇧⌘D` (an
[AeroSpace](../tilde/.config/aerospace/aerospace.toml) binding that runs
`appearance toggle`).

## Where the themes come from

`setup/misc.sh` clones abereghici/themes into `~/.local/share/bereghici` (or
pulls it when it's already there; a symlink there is treated as your own
checkout and left alone), then runs its `install.sh`. That links each theme
where its tool reads it, builds bat's theme cache and installs the
BereghiciSymbols font that Ghostty uses for the prompt's logo. The configs in
this repo reference those files.

Tools that can't include a file hold a pasted copy of their theme:
[herdr](../tilde/.config/herdr/config.toml),
[Starship](../tilde/.starship.toml), [ripgrep](../tilde/.ripgreprc) and
[lazydocker](../lazydocker/config.yml). `tests/setup.bats` fails when a copy no
longer matches the generated one.

## How each tool follows the appearance

- **On their own**: Ghostty, Neovim, VS Code, herdr and tmux switch live with
  the terminal or macOS; bat, yazi and lazygit pick a side when they start. zsh,
  fzf, eza, ripgrep, Starship and jq use the terminal's ANSI colors, so they
  change with Ghostty.
- **Through `appearance sync`**: tools with a single theme setting.
  [`bin/appearance`](../bin/appearance) points them at the current appearance:
  delta (git and lazygit, through the include
  `~/.local/state/dotfiles/delta.gitconfig`), Claude Code, Codex and reviewr.

`appearance sync` runs when you switch with `appearance toggle|dark|light`, at
the end of setup, and from a launchd agent
([`launchd/dotfiles.appearance-sync.plist`](../launchd/dotfiles.appearance-sync.plist),
installed by `setup/symlinks.sh`) whenever the global preferences change. The
agent runs it with `--if-changed`, so other preference writes cost one check.
Runs are serialized, and a step that fails is retried on the next one.

```shell
appearance        # dark or light
appearance toggle # or: appearance dark, appearance light
appearance sync   # point delta, Claude Code, Codex and reviewr at it now
```

Not verified: whether macOS's **Auto** appearance (switching at sunset) writes
the preferences file the agent watches. If those tools don't follow an automatic
switch, run `appearance sync`.
