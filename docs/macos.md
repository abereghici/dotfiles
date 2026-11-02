# macOS

## Defaults (`setup/macos.sh`)

[`setup/macos.sh`](../setup/macos.sh) is optional and separate from `setup.sh`.
It is based on [mths.be/macos](https://mths.be/macos) and writes `defaults`,
`pmset` and `scutil` settings, then restarts Finder, the Dock and the other apps
it changed. Most keys are undocumented, so check them again after a major macOS
upgrade. It records nothing to undo: read the script before running it.

```shell
./setup/macos.sh
```

Grouped as in the script: general UI, keyboard and language, screen, Finder,
Dock, spell checking, WebKit, Terminal, Time Machine, TextEdit and power. The
names, languages, locale and time zone come from
[`~/.macos.local`](../README.md#macoslocal); each is skipped when unset.

Two settings trade a safety check for convenience. Remove them from the script
if you don't want that:

- `LSQuarantine false` turns off the "are you sure you want to open this app?"
  dialog for downloaded apps.
- `skip-verify` turns off the checksum verification of disk images.

## Keyboard shortcut conflicts

Neovim (LazyVim) resizes windows with `⌃` + arrows. Turn off these shortcuts
under **System Settings** → **Keyboard** → **Keyboard Shortcuts…** → **Mission
Control**:

- **Mission Control** (`⌃↑`) and **Application windows** (`⌃↓`)
- **Move left a space** (`⌃←`) and **Move right a space** (`⌃→`)

## Raycast

Raycast keeps its hotkeys in an encrypted database, so they are set by hand and
recorded here. Hyper (`⌃⌥⇧⌘`) is reserved for Raycast: nothing else in these
dotfiles binds it.

1. **System Settings** → **Keyboard** → **Keyboard Shortcuts…** → **Modifier
   Keys**: leave Caps Lock as **Caps Lock**, otherwise Raycast can't use it.
1. **Raycast Settings** → **Keyboard** → **Hyper Key**: **Caps Lock**, with
   **Include Shift** on (to match the
   [ZSA Voyager](../keyboard/README.md#zsa-voyager)'s Hyper) and **Quick Press**
   set to **Trigger Escape**.
1. Record each hotkey below under **Raycast Settings** → **Shortcuts**.

| Hotkey      | Command                         |
| ----------- | ------------------------------- |
| `⌘ Space`   | Raycast                         |
| `Hyper` `V` | Clipboard History               |
| `Hyper` `W` | Improve Writing (Claude Writer) |

To move the settings to another Mac, run **Export Settings & Data**, then
**Import Settings & Data** on the new one. Keep the encrypted `.rayconfig` out
of this repository: it can include clipboard history, notes and AI chats.
