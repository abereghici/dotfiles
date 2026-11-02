# ABC – Romanian keyboard layout

[`ABC-Romanian.keylayout`](ABC-Romanian.keylayout) is the macOS ABC layout with
the Romanian Programmers keys (SR 13392:2004) on Option. `setup/symlinks.sh`
links it into `~/Library/Keyboard Layouts`; after the next login, add **ABC –
Romanian** under **System Settings** → **Keyboard** → **Text Input** → **Edit**
(and remove ABC if you like). Edits to the layout take effect after the next
login.

| Keys          | Types   |
| ------------- | ------- |
| `⌥` `A` / `Q` | ă / â   |
| `⌥` `I`       | î       |
| `⌥` `S` / `T` | ș / ț   |
| add `⇧`       | capital |

Ghostty uses the left Option as Alt
([`macos-option-as-alt`](../tilde/.config/ghostty/config)), so its config types
the same letters on those keys; zsh's Alt bindings on them don't fire there.

On a Mac without these dotfiles, pick the built-in **ABC – Extended**: `⌥` `B`
then `A` for ă, `⌥` `6` then `A`/`I` for â/î, `⌥` `P` then `S`/`T` for ș/ț.
