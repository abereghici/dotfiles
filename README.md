# ~abereghici 💻

[![CI](https://github.com/abereghici/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/abereghici/dotfiles/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![macOS](https://img.shields.io/badge/macOS-Apple%20silicon%20%7C%20Intel-black?logo=apple)

My macOS dotfiles: Zsh, Homebrew, Neovim (LazyVim), Ghostty, tmux and herdr for
coding agents, lazygit, mise and AeroSpace, all in Rosé Pine. One script sets up
a new Mac; every config is a symlink back into this repository.

![abereghici terminal](screenshot.webp)

<!-- prettier-ignore -->
> [!WARNING]
> These are my personal settings. Fork the repository and review the code
> before running it, rather than installing it as is.

## Contents

- [What's inside](#whats-inside)
- [Requirements](#requirements)
- [Installation](#installation)
- [Extras](#extras)
- [Local customizations](#local-customizations)
- [Updating](#updating)
- [Contributing](#contributing)
- [License](#license)

## What's inside

| Area     | Tools                                                                                                                                                                                        |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Shell    | [Zsh](tilde/.zshrc) with [aliases](tilde/.config/zsh/aliases.zsh), [fzf](tilde/.config/zsh/fzf.zsh), zoxide, direnv and a [Starship prompt](tilde/.starship.toml) that starts in about 70 ms |
| Terminal | [Ghostty](tilde/.config/ghostty/config), [tmux](tilde/.config/tmux/tmux.conf) and [herdr](tilde/.config/herdr/config.toml), tmux and herdr sharing the same keys                             |
| Editor   | [Neovim](tilde/.config/nvim/) on LazyVim; [VS Code](vscode/) settings and snippets with default keybindings                                                                                  |
| Git      | [Git aliases](tilde/.gitconfig), delta diffs and [lazygit](lazygit/config.yml)                                                                                                               |
| Runtimes | Node, Python, Go, Rust, Java and Bun via [mise](tilde/.config/mise/config.toml)                                                                                                              |
| macOS    | [Sensible defaults](setup/macos.sh), [AeroSpace](tilde/.config/aerospace/aerospace.toml) tiling and a [Romanian keyboard layout](keyboard/ABC-Romanian.keylayout)                            |
| Apps     | Everything in the [Brewfile](setup/Brewfile), VS Code extensions included                                                                                                                    |
| Scripts  | [`bin/`](bin/), including the [`projects`](bin/projects) picker for tmux and herdr and [`keychain`](bin/keychain) for secrets                                                                |

## Requirements

- macOS on Apple silicon or Intel
- Zsh (the default shell on macOS)
- Homebrew (the setup script installs it)

## Installation

1. Enable **Firewall** under **System Settings** → **Network**
1. Point the DNS Servers to [Cloudflare DNS](https://one.one.one.one/dns/)
   - `1.1.1.1`
   - `1.0.0.1`
   - `2606:4700:4700::1111`
   - `2606:4700:4700::1001`
1. Configure Git and GitHub SSH
   1. [Generate SSH key and add it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
   1. [Add your public SSH key to GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
   1. Test your authentication with:

      ```bash
      ssh -T git@github.com
      ```

1. Choose _automatic_ or _manual_ installation below

### Automatically

<!-- prettier-ignore -->
> [!CAUTION]
> Use at your own risk!

```shell
git clone git@github.com:abereghici/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh
```

[`setup.sh`](setup.sh) moves an existing `~/.zshrc` to `~/.zshrc.backup`, lets
Touch ID authorize `sudo`, then runs the three scripts below in order. Pass `-y`
to skip its confirmation prompt.

### Manually

```shell
git clone git@github.com:abereghici/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup/brew.sh
./setup/symlinks.sh
./setup/misc.sh
```

- [`brew.sh`](setup/brew.sh) installs Homebrew and the
  [Brewfile](setup/Brewfile).
- [`symlinks.sh`](setup/symlinks.sh) links `tilde/` into your home directory and
  asks before replacing a file that is already there.
- [`misc.sh`](setup/misc.sh) installs the tmux plugins, links the herdr plugins,
  installs the mise runtimes and builds the bat theme cache. It runs last
  because it reads the linked mise, bat, tmux and herdr configs.

Everything is then configured by editing files in `~/dotfiles`.

## Extras

### Set macOS defaults

```shell
./setup/macos.sh
```

#### Keyboard conflicts

Turn off these Mission Control shortcuts under **System Settings** →
**Keyboard** → **Keyboard Shortcuts…** → **Mission Control**: Neovim uses
`Ctrl` + arrows to resize windows.

- **Mission Control** (`⌃↑`) and **Application windows** (`⌃↓`)
- **Move left a space** (`⌃←`) and **Move right a space** (`⌃→`)

### Raycast

Raycast keeps its hotkeys in an encrypted database, so they are set by hand and
recorded here. Hyper (`⌃⌥⇧⌘`) is reserved for Raycast: nothing else in these
dotfiles binds it.

1. **System Settings** → **Keyboard** → **Keyboard Shortcuts…** → **Modifier
   Keys**: leave Caps Lock as **Caps Lock**, otherwise Raycast can't use it.
1. **Raycast Settings** → **Keyboard** → **Hyper Key**: **Caps Lock**, with
   **Include Shift** on (to match the Voyager's Hyper) and **Quick Press** set
   to **Trigger Escape**.
1. Record each hotkey below under **Raycast Settings** → **Shortcuts**.

| Hotkey      | Command                         |
| ----------- | ------------------------------- |
| `⌘ Space`   | Raycast                         |
| `Hyper` `V` | Clipboard History               |
| `Hyper` `W` | Improve Writing (Claude Writer) |

To move the settings to another Mac, run **Export Settings & Data**, then
**Import Settings & Data** on the new one. Keep the encrypted `.rayconfig` out
of this repository: it can include clipboard history, notes and AI chats.

### Romanian

[`keyboard/ABC-Romanian.keylayout`](keyboard/ABC-Romanian.keylayout) is the
macOS ABC layout with the Romanian Programmers keys (SR 13392:2004) on Option.
`symlinks.sh` links it into `~/Library/Keyboard Layouts` and runs
[`setup/input-source.swift`](setup/input-source.swift), which makes **ABC –
Romanian** the only keyboard layout (ABC is disabled). If it reports that the
layout isn't registered yet, log out and back in and run `setup/symlinks.sh`
again. Edits to the layout take effect after the next login.

| Keys          | Types   |
| ------------- | ------- |
| `⌥` `A` / `Q` | ă / â   |
| `⌥` `I`       | î       |
| `⌥` `S` / `T` | ș / ț   |
| add `⇧`       | capital |

Ghostty uses the left Option as Alt, so its config types the same letters on
those keys; zsh's Alt bindings on them don't fire there.

On a Mac without these dotfiles, pick the built-in **ABC – Extended**: `⌥` `B`
then `A` for ă, `⌥` `6` then `A`/`I` for â/î, `⌥` `P` then `S`/`T` for ș/ț.

### Project pickers

[`projects`](bin/projects) opens a project as a tmux session or a herdr
workspace, from tmux (`prefix` `f`, `⌃⌥P`), herdr (the same keys) or the shell
(`tmuxs`, `herdrs`). Projects are the folders inside each folder of
`~/Development` and `~/Code` (and of their `Work/` folder), so
`~/Development/Personal/dotfiles` is a project and machines with different
folders need no config. `prefix` `g` creates a project folder first. Run
`projects` on its own to list the folders it searches.

### tmux or herdr

[herdr](tilde/.config/herdr/config.toml) is set up as a drop-in for
[tmux](tilde/.config/tmux/tmux.conf): the same `⌥Space` prefix, the same keys
(tmux sessions are herdr workspaces, windows are tabs) and the same Rosé Pine
look. `prefix` `Tab` / `⌃⌥O` (last session) comes from the
[last-workspace plugin](herdr/plugins/last-workspace/), which `misc.sh` links.

On top of tmux:

- `prefix` `a` focuses the agent whose notification is showing.
- `prefix` `/` lists every agent and terminal; type `/` there to search by name,
  branch or path.
- `⌃⌥G` opens [lazygit](lazygit/config.yml) over the current tab, in the repo of
  the pane underneath (`q` closes it; in Neovim it's `<leader>gg`).
- New projects open with nvim already running in their Editor tab.
- After a restart herdr brings back every workspace, tab and directory, and the
  [editor-restore plugin](herdr/plugins/editor-restore/) starts nvim again in
  Editor tabs (tmux-resurrect's job in tmux).

## Local customizations

These optional files extend the dotfiles for one machine. None of them are
checked in.

### `~/.zsh.local`

If this file exists, `.zshrc` sources it after the path, env, aliases,
keybindings and completion setup, and before the plugins and the prompt. Its
content can add to or overwrite the existing aliases, settings, PATH, etc.

```zsh
# Extra binaries for this machine only
[ -d "$HOME/.acme/bin" ] && PATH="$HOME/.acme/bin:$PATH"

# Secrets from the macOS Keychain (stored with `keychain set ACME_API_KEY`)
eval "$(keychain export ACME_API_KEY)"
```

### `~/.gitconfig.local`

If this file exists, it is included at the end of `~/.gitconfig`, so its content
can overwrite or add to the existing `git` configurations.

<!-- prettier-ignore -->
> [!TIP]
> Use `~/.gitconfig.local` to store sensitive information such as the `git` user
> credentials for individual repositories.

```ini
# A different identity for every repository under ~/Code/Work/
[includeIf "gitdir:~/Code/Work/"]
  path = ~/.gitconfig.work
```

with `~/.gitconfig.work`:

```ini
[user]
  email = you@example.com
```

### `~/.config/mise/config.local.toml`

[mise](https://mise.jdx.dev/) loads it alongside `config.toml` (see
`mise config ls`), for runtimes and tools you only need on this machine. Since
`~/.config/mise` links to `tilde/.config/mise`, the file lives there and is
git-ignored.

```toml
[tools]
terraform = "latest"
```

### `~/.macos.local`

[`setup/macos.sh`](setup/macos.sh) sources it for personal settings; each one is
skipped when unset.

```bash
COMPUTERNAME='my-mac'
LOCALHOSTNAME='my-mac'
LANGUAGES=(en)
LOCALE='en_US'
TIMEZONE='Europe/London' # list: sudo systemsetup -listtimezones
```

## Updating

To update an existing install:

```shell
cd ~/dotfiles
git pull
./setup.sh
```

## Contributing

Pull requests that fix bugs or add improvements without breaking changes are
welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the checks to run, and
[SECURITY.md](SECURITY.md) to report a vulnerability privately.

## License

[MIT](LICENSE) © Alexandru Bereghici

## Inspiration

- [nicksp/dotfiles](https://github.com/nicksp/dotfiles)
- [holman/dotfiles](https://github.com/holman/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [sapegin/dotfiles](https://github.com/sapegin/dotfiles)
- <https://remysharp.com/2018/08/23/cli-improved>
- <https://evanhahn.com/a-decade-of-dotfiles>
- <https://cpojer.net/posts/set-up-a-new-mac-fast>
- <https://thevaluable.dev/zsh-install-configure-mouseless/>
