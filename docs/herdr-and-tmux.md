# herdr and tmux keys

[herdr](https://herdr.dev) is the workspace for coding agents;
[tmux](https://github.com/tmux/tmux) stays for everything else. Both use the
`⌥Space` prefix, and tmux sessions map to herdr workspaces, windows to tabs.
`prefix` `?` lists every key in either.

## herdr

Configured in
[`tilde/.config/herdr/config.toml`](../tilde/.config/herdr/config.toml), which
lists only the changes from `herdr --default-config`. The keys follow one rule:
`⌃⌥` + a key **moves** you, the letter naming where to; `prefix` + a key
**does** something (create, close, rename, split, open a tool). `⇧` reverses or
goes bigger.

| Keys                          | Moves to                                                                                            |
| ----------------------------- | --------------------------------------------------------------------------------------------------- |
| `⌃⌥H` `J` `K` `L`             | the Neovim split, then the herdr pane, that way                                                     |
| `⌃Tab` / `⌃⇧Tab`              | the next / previous tab                                                                             |
| `⌃⌥1` … `⌃⌥9` / `⌃⌥O`         | that workspace / the other (last) one                                                               |
| `⌃⌥A` / `⌃⌥⇧A`                | the next / previous agent, in any workspace                                                         |
| `⌥1` … `⌥9`                   | the agent in that row of the Agents list                                                            |
| `prefix` `a`                  | the agent whose notification is showing                                                             |
| `prefix` `/`                  | a picker of every agent and terminal (`/` search)                                                   |
| `⌃⌥P` or `prefix` `f`         | a project ([`projects`](../bin/projects))                                                           |
| `⌃⌥G` or `prefix` `g`         | [lazygit](../lazygit/config.yml), in the pane's repo                                                |
| `⌃⌥R` or `prefix` `r`         | [reviewr](https://github.com/persiyanov/herdr-reviewr): review the diff, comment, send to the agent |
| `prefix` `⇧G` / `prefix` `⇧F` | a new / an existing Git worktree                                                                    |

`prefix` `=` enters resize mode, and `prefix` `⇧N` creates a project folder
before opening it.

- **Neovim-aware panes.** `⌃⌥H` `J` `K` `L` come from the
  [pane-nav plugin](../herdr/plugins/pane-nav/): in a pane running Neovim it
  hands the key to Neovim, which moves between its splits and on to the next
  herdr pane at its edge
  ([keymaps.lua](../tilde/.config/nvim/lua/config/keymaps.lua)). Other programs
  never see these keys, so `⌃L`, `⌃K`, `⌃J` keep working in zsh, Claude Code,
  lazygit and fzf.
- **Plugins.** `setup/misc.sh` links every plugin in
  [`herdr/plugins`](../herdr/plugins/): pane-nav, last-workspace (`⌃⌥O`) and
  editor-restore. herdr brings back every workspace, tab and directory after a
  restart, and editor-restore starts Neovim again in Editor tabs (what
  tmux-resurrect does for tmux). New projects open with Neovim already running
  in their Editor tab.
- **reviewr.** `misc.sh` installs it from GitHub;
  [`herdr-reviewr-config`](../bin/herdr-reviewr-config) writes its config from
  [`reviewr.toml`](../tilde/.config/herdr/reviewr.toml), the untracked
  `reviewr.local.toml` and a theme for the current appearance (everforest when
  dark, github-light when light, unless either file sets one). It also opens on
  its own in new worktree workspaces.
- **Ghostty** leaves `⌃Tab` to herdr; `⌘⇧[` `]` still switch Ghostty tabs.

## tmux

Configured in [`tilde/.config/tmux/tmux.conf`](../tilde/.config/tmux/tmux.conf).

| Keys                     | Does                                          |
| ------------------------ | --------------------------------------------- |
| `⌃⌥H` `J` `K` `L`        | the pane that way (no Neovim hand-off)        |
| `⌃⌥P` or `prefix` `f`    | a project ([`projects`](../bin/projects))     |
| `⌃⌥O` or `prefix` `Tab`  | the last session                              |
| `prefix` `g`             | lazygit in a popup, in the pane's directory   |
| `prefix` `⇧N`            | a new project folder, then its session        |
| `prefix` `S`             | a session picker                              |
| `prefix` `c`             | a new window, asking for its name             |
| `prefix` `s` / `v`       | split below / right                           |
| `prefix` `h` `j` `k` `l` | the pane that way; `⇧` swaps with it          |
| `prefix` `r`             | resize mode: `h` `j` `k` `l`, `Esc` to finish |

## Conflicts to know about

- **Claude desktop** opens its Quick Entry on a double tap of `⌥`, which two
  quick prefix presses also are: set its shortcut to something else in its
  Settings.
- **Home-row mods.** Hold the modifiers with the hand that isn't pressing the
  key (`⌃⌥H` with the left hand's mods, `⌃⌥A` with the right's).
- **macOS** keeps `⌃Space` and `⌃⌥Space` for input sources, and
  [AeroSpace](../tilde/.config/aerospace/aerospace.toml) owns `⌥⌘` chords, which
  is why neither multiplexer uses them.
