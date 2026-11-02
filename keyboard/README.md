# Keyboard

## ZSA Voyager

My keyboard is a [ZSA Voyager](https://www.zsa.io/voyager) running the **Voyager
v2** layout:
[configure.zsa.io/voyager/layouts/RyaV6](https://configure.zsa.io/voyager/layouts/RyaV6/GGKQXa/0)
(revision GGKQXa, for QMK 25). The keys in these dotfiles are chosen to work
with it, though none of them needs it.

To use it, open the link in Oryx (ZSA's configurator), make your own copy of the
layout to edit, then download the firmware and flash it with
[Keymapp](https://www.zsa.io/flash), which the [Brewfile](../setup/Brewfile)
installs.

| Layer | Hold              | Has                                                                                  |
| ----- | ----------------- | ------------------------------------------------------------------------------------ |
| Main  |                   | QWERTY with home-row mods, Esc where Caps Lock is, Shift on the outer thumbs         |
| Sym   | right inner thumb | every symbol, on the letter keys                                                     |
| Nav   | left inner thumb  | arrows on `H` `J` `K` `L`, Home/PgDn/PgUp/End above them, held mods on the left hand |
| Fn    | both inner thumbs | F1–F12, media, brightness, Mission Control, lock screen, screenshot                  |

- **Home-row mods**, the same on both hands from the outside in: Ctrl (`S`/`L`),
  Alt (`D`/`K`), Cmd (`F`/`J`) and Hyper (`G`/`H`). Both Alts send the left
  Option, which Ghostty treats as Alt (`macos-option-as-alt = left`).
- **Chordal Hold** is on: a home-row mod only counts as a modifier when the next
  key is on the other hand or a thumb. So take the modifiers from the hand that
  isn't pressing the key: `⌃⌥H` with the left hand's `S`+`D`, `⌃⌥A` with the
  right hand's `L`+`K`. Same-hand chords type letters when rolled quickly.
- **`⌥Space`**, the [herdr and tmux](../docs/herdr-and-tmux.md) prefix, is a key
  of its own in both top outer corners, or `D` (or `K`) held with the Space
  thumb.
- **Hyper** includes Shift, which is why
  [Raycast's Hyper Key](../docs/macos.md#raycast) has **Include Shift** on;
  nothing else in these dotfiles binds Hyper.
- `⌃Tab` and `⌃⇧Tab` (next and previous tab in herdr) are on Nav's `,` and `M`.

## ABC – Romanian layout

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
