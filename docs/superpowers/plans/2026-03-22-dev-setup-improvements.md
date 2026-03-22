# Dev Setup Improvements (Approach B) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use
> superpowers:subagent-driven-development (recommended) or
> superpowers:executing-plans to implement this plan task-by-task. Steps use
> checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce shell startup from ~768ms to <300ms, fix all known bugs/dead
code, add test infrastructure, replace slow shell plugins with faster
alternatives, wire up yazi, and fully commit to mise.

**Architecture:** Work top-down from the most impactful changes first (shell
startup, then bug fixes, then new features, then automation). Each task is
independently committable. All changes are in `tilde/` (symlinked to `$HOME`) or
repo tooling files (`package.json`, `.husky/`).

**Tech Stack:** zsh, zsh-defer, fast-syntax-highlighting, zsh-autocomplete,
mise, bats (testing), husky, yazi, Neovim/Lua

---

## File Map

| File                                          | Action    | Purpose                                                                            |
| --------------------------------------------- | --------- | ---------------------------------------------------------------------------------- |
| `tilde/.zshrc`                                | Modify    | Remove oh-my-zsh, add zsh-defer, fix `$(brew --prefix)` subshells                  |
| `tilde/.config/zsh/path.zsh`                  | Modify    | Remove fnm entry                                                                   |
| `tilde/.config/zsh/env.zsh`                   | Modify    | Remove `BAT_THEME=base16`, remove `ZSH=` export                                    |
| `tilde/.config/zsh/aliases.zsh`               | Modify    | Remove `nvm="fnm"` alias, add yazi `y()` function                                  |
| `tilde/.config/zsh/keybindings.zsh`           | Modify    | Remove `autosuggest-accept` binding (plugin gone)                                  |
| `tilde/.config/zsh/fzf.zsh`                   | No change | Already correct                                                                    |
| `tilde/.gitconfig`                            | Modify    | Fix `publish` alias (`branch-name` → `branchname`), fix `undopush`                 |
| `tilde/.config/nvim/lua/plugins/neo-git.lua`  | Modify    | Remove telescope dependency, switch to fzf-lua integration                         |
| `tilde/.config/nvim/lua/plugins/disabled.lua` | No change | Already correct                                                                    |
| `tilde/.config/nvim/lua/config/keymaps.lua`   | Modify    | Remove duplicate `gldf` keymap                                                     |
| `tilde/.config/tmux/tmux.conf`                | Modify    | Remove dead `default-terminal` line, declare orphaned plugins or remove            |
| `tilde/.config/bat/config`                    | No change | Already correct (`rose-pine-moon`)                                                 |
| `setup/Brewfile`                              | Modify    | Add `zsh-defer`, `fast-syntax-highlighting`, `zsh-autocomplete`, `bats`            |
| `setup/misc.sh`                               | Modify    | Add `mise` `.nvmrc` config note; pin npm global package versions                   |
| `.mise.toml`                                  | Create    | Declare Node 24 for dotfiles repo itself                                           |
| `package.json`                                | Modify    | Add `format` and `format:check` scripts; fix `private: "true"` → `true`; add husky |
| `.husky/pre-commit`                           | Create    | Run `prettier --check` on staged shell files                                       |
| `tests/symlinks.bats`                         | Create    | Test that all tilde/ entries are correctly symlinked                               |
| `tests/setup.bats`                            | Create    | Test that required commands are available after setup                              |

---

## Task 1: Cache `$(brew --prefix)` and remove oh-my-zsh

**Files:**

- Modify: `tilde/.zshrc`
- Modify: `tilde/.config/zsh/env.zsh`

**Context:**  
`$(brew --prefix)` spawns a subshell twice in `.zshrc` (lines 3, 19–21). Caching
it in a variable eliminates that overhead. `oh-my-zsh` is sourced on line 24 but
provides zero functionality — autosuggestions and syntax-highlighting are
sourced directly from Homebrew, and Starship handles the prompt. Removing it
saves ~100–150ms.

The `ZSH` export in `env.zsh` was only needed for oh-my-zsh; remove it too.

- [ ] **Step 1.1: Update `.zshrc` to cache brew prefix and remove oh-my-zsh**

Replace the entire content of `tilde/.zshrc` with:

```zsh
# Cache brew prefix to avoid repeated subshell calls
export HOMEBREW_PREFIX="$(/opt/homebrew/bin/brew shellenv | grep 'HOMEBREW_PREFIX' | cut -d= -f2 | tr -d "'")"
eval "$(/opt/homebrew/bin/brew shellenv)"

# ----- Direnv  -----
# https://github.com/direnv/direnv
eval "$(direnv hook zsh)"

# ---- Zoxide (better cd) ----
# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# ---- Mise (Polyglot runtime manager) ----
eval "$(mise activate zsh --shims)"

# Fish-like autosuggestions (from Homebrew)
[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Fish-like syntax highlighting (from Homebrew)
[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source $HOME/.config/zsh/path.zsh
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/keybindings.zsh

# Allow local (private) customizations (not checked in to version control)
[ -f ~/.zsh.local ] && source ~/.zsh.local

# Enable fzf: https://github.com/junegunn/fzf
if [ $(command -v "fzf") ]; then
  source $HOME/.config/zsh/fzf.zsh
fi

# Enable ngrok autocompletions
if [ $(command -v "ngrok") ]; then
  eval "$(ngrok completion)"
fi

# Starship prompt (needs to be at the end)
if [ $(command -v "starship") ]; then
  source $HOME/.config/zsh/prompt.zsh
fi

# Load Angular CLI autocompletion.
if [ $(command -v "ng") ]; then
  source <(ng completion script)
fi
```

- [ ] **Step 1.2: Remove `ZSH` export from `env.zsh`**

In `tilde/.config/zsh/env.zsh`, remove this line:

```zsh
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"
```

- [ ] **Step 1.3: Measure startup time**

```bash
time zsh -i -c exit
```

Expected: noticeably less than 768ms baseline.

- [ ] **Step 1.4: Commit**

```bash
git add tilde/.zshrc tilde/.config/zsh/env.zsh
git commit -m "perf(zsh): remove oh-my-zsh overhead and cache brew prefix"
```

---

## Task 2: Replace slow plugins with zsh-defer lazy loading

**Files:**

- Modify: `tilde/.zshrc`
- Modify: `setup/Brewfile`

**Context:**  
`zsh-defer` (by romkatv, the Powerlevel10k author) defers execution of slow
`eval` calls until after the first prompt is drawn. This makes the shell feel
instant while still initializing everything. It is available via Homebrew.

The heavy `eval` calls are: `direnv hook`, `zoxide init`, `mise activate`,
`fzf --zsh`, `starship init`, `ngrok completion`, `ng completion`. Deferring
these gives the biggest startup win — these `eval` calls together account for
~300–400ms.

**Important:** `path.zsh`, `env.zsh`, `aliases.zsh` must NOT be deferred — they
need to be available immediately. Only `eval`-based initializations can be
deferred.

- [ ] **Step 2.1: Add `zsh-defer` to Brewfile**

In `setup/Brewfile`, under `## Core System Utilities`, add:

```
brew "romkatv/zsh-defer/zsh-defer" # Defers zsh plugin loading until prompt is ready
```

Also add the tap:

```
tap "romkatv/zsh-defer"
```

- [ ] **Step 2.2: Install zsh-defer**

```bash
brew tap romkatv/zsh-defer && brew install zsh-defer
```

- [ ] **Step 2.3: Update `.zshrc` to use zsh-defer for all eval calls**

Replace the content of `tilde/.zshrc` with the deferred version:

```zsh
# Cache brew prefix (must happen before everything — no defer)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load zsh-defer (must be sourced before using zsh-defer)
source "${HOMEBREW_PREFIX}/share/zsh-defer/zsh-defer.plugin.zsh"

# Load path, env, aliases synchronously (needed immediately)
source $HOME/.config/zsh/path.zsh
source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/keybindings.zsh

# Allow local (private) customizations (not checked in to version control)
[ -f ~/.zsh.local ] && source ~/.zsh.local

# ----- Defer slow eval initializations -----
# These are deferred until after the first prompt is drawn.
# IMPORTANT: zsh-defer runs commands after the prompt, so we must NOT use
# $(command substitution) inline — that would evaluate eagerly at source time.
# Instead, wrap each eval in a function and defer the function call.

# Direnv: https://github.com/direnv/direnv
_init_direnv() { eval "$(direnv hook zsh)" }
zsh-defer _init_direnv

# Zoxide (better cd): https://github.com/ajeetdsouza/zoxide
_init_zoxide() { eval "$(zoxide init zsh)" }
zsh-defer _init_zoxide

# Mise (Polyglot runtime manager)
_init_mise() { eval "$(mise activate zsh --shims)" }
zsh-defer _init_mise

# Fish-like autosuggestions
zsh-defer source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Fish-like syntax highlighting (must be last of the plugin sources)
zsh-defer source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# fzf key bindings and fuzzy completion
if command -v fzf &>/dev/null; then
  zsh-defer source $HOME/.config/zsh/fzf.zsh
fi

# ngrok autocompletions
if command -v ngrok &>/dev/null; then
  _init_ngrok() { eval "$(ngrok completion)" }
  zsh-defer _init_ngrok
fi

# Angular CLI autocompletion
if command -v ng &>/dev/null; then
  _init_ng() { eval "$(ng completion script)" }
  zsh-defer _init_ng
fi

# Starship prompt (must be last — defer-safe since it sets up the prompt hook)
if command -v starship &>/dev/null; then
  zsh-defer source $HOME/.config/zsh/prompt.zsh
fi
```

**Note on `HOMEBREW_PREFIX`:** After `eval "$(brew shellenv)"`, the variable
`HOMEBREW_PREFIX` is already exported by brew's shellenv output. No manual
caching needed.

**Note on `zsh-defer` eval syntax:** `zsh-defer eval "$(cmd)"` evaluates the
command substitution at source time (eager), defeating the purpose. Always wrap
evals in named functions and defer the function — this is the correct pattern.

- [ ] **Step 2.4: Test that deferred plugins work**

Open a new terminal and verify:

- Autosuggestions appear as you type
- Syntax highlighting works
- `cd` uses zoxide
- `mise` is active (`mise current`)
- `fzf` Ctrl-T works

- [ ] **Step 2.5: Measure startup time**

```bash
time zsh -i -c exit
```

Expected: <300ms (target: ~150–200ms with all evals deferred).

- [ ] **Step 2.6: Commit**

```bash
git add tilde/.zshrc setup/Brewfile
git commit -m "perf(zsh): defer slow eval calls with zsh-defer for faster startup"
```

---

## Task 3: Remove fnm — fully commit to mise

**Files:**

- Modify: `tilde/.config/zsh/path.zsh`
- Modify: `tilde/.config/zsh/aliases.zsh`
- Create: `.mise.toml`

**Context:**  
`path.zsh` adds `$HOME/.local/share/fnm` to PATH, and `aliases.zsh` has
`alias nvm="fnm"`. Both are dead code since mise is the active runtime manager.
Mise reads `.nvmrc` natively.

A `.mise.toml` at the repo root tells mise which Node version to use for this
repo itself (replacing the `.nvmrc`).

- [ ] **Step 3.1: Remove fnm from `path.zsh`**

In `tilde/.config/zsh/path.zsh`, remove:

```zsh
# Add fnm
prepend "$HOME/.local/share/fnm"
```

- [ ] **Step 3.2: Remove `nvm` alias from `aliases.zsh`**

In `tilde/.config/zsh/aliases.zsh`, remove:

```zsh
alias nvm="fnm"
```

- [ ] **Step 3.3: Create `.mise.toml` at repo root**

Create `/Users/abereghici/Development/Personal/dotfiles/.mise.toml`:

```toml
[tools]
node = "24"
```

- [ ] **Step 3.4: Verify mise auto-switches Node**

```bash
cd /Users/abereghici/Development/Personal/dotfiles
mise current
```

Expected: output shows `node 24.x.x`

- [ ] **Step 3.5: Remove `.nvmrc` from repo root (optional)**

The `.nvmrc` is superseded by `.mise.toml`. Mise reads both, but `.mise.toml` is
the canonical mise format.

```bash
rm /Users/abereghici/Development/Personal/dotfiles/.nvmrc
```

- [ ] **Step 3.6: Commit**

```bash
git add tilde/.config/zsh/path.zsh tilde/.config/zsh/aliases.zsh .mise.toml
git rm .nvmrc
git commit -m "chore(tools): remove fnm, commit to mise as single runtime manager"
```

---

## Task 4: Fix BAT_THEME conflict and shell aliases bugs

**Files:**

- Modify: `tilde/.config/zsh/env.zsh`
- Modify: `tilde/.gitconfig`
- Modify: `tilde/.config/zsh/aliases.zsh`

**Context:**

- `BAT_THEME=base16` in `env.zsh` overrides the `bat/config` file which
  correctly sets `rose-pine-moon`. Remove the env var; the config file is the
  right place.
- `git publish` alias: references `$(git branch-name)` but the defined alias is
  `branchname` — broken at runtime.
- `git undopush` alias: hardcodes `master` — broken on `main`-first repos.
- `grep -i` alias: case-insensitive by default breaks scripts that expect
  case-sensitive grep. Preserve the color but drop `-i`.

- [ ] **Step 4.1: Remove `BAT_THEME` from `env.zsh`**

In `tilde/.config/zsh/env.zsh`, remove:

```zsh
# ----- Bat (better cat) -----
# https://github.com/sharkdp/bat
export BAT_THEME="base16"
```

- [ ] **Step 4.2: Verify bat uses rose-pine-moon theme**

```bash
bat --version # check it runs
echo "hello world" | bat --language=zsh
```

Expected: output uses Rose Pine Moon colors.

- [ ] **Step 4.3: Fix `git publish` alias in `.gitconfig`**

Find:

```
publish = "!git push -u origin $(git branch-name)"
```

Replace with:

```
publish = "!git push -u origin $(git branchname)"
```

- [ ] **Step 4.4: Fix `git undopush` alias in `.gitconfig`**

Find:

```
undopush = push -f origin HEAD^:master
```

Replace with:

```
undopush = "!git push -f origin HEAD^:$(git branchname)"
```

- [ ] **Step 4.5: Fix `grep` alias to be smart-case instead of
      always-case-insensitive**

In `tilde/.config/zsh/aliases.zsh`, find:

```zsh
alias grep="grep -i --color=auto"
```

Replace with:

```zsh
alias grep="grep --color=auto"
```

(Ripgrep with `--smart-case` is already available via `.ripgreprc` for real
searching; `grep` should remain faithful to its default behavior.)

- [ ] **Step 4.6: Commit**

```bash
git add tilde/.config/zsh/env.zsh tilde/.gitconfig tilde/.config/zsh/aliases.zsh
git commit -m "fix: correct BAT_THEME conflict, broken git aliases, and grep flags"
```

---

## Task 5: Fix Neovim — remove duplicate keymap and fix neogit telescope dependency

**Files:**

- Modify: `tilde/.config/nvim/lua/config/keymaps.lua`
- Modify: `tilde/.config/nvim/lua/plugins/neo-git.lua`

**Context:**

- `gldf` and `gldv` in `keymaps.lua` are identical — both open definition in a
  vertical split. `gldf` was likely meant to be "goto def fullscreen" (a
  single-window replacement, not a split). Remove `gldf` to avoid the confusing
  duplicate, or repurpose it as a true fullscreen goto-def.
- `neo-git.lua` declares `telescope.nvim` as a dependency and sets
  `integrations.telescope = true`. But telescope is disabled in `disabled.lua`.
  This forces lazy.nvim to pull in telescope even though it's disabled. Switch
  neogit to use its built-in picker (set `telescope = nil`) so the telescope
  dependency is dropped cleanly.

- [ ] **Step 5.1: Remove duplicate `gldf` keymap**

In `tilde/.config/nvim/lua/config/keymaps.lua`, remove:

```lua
-- Open definition fullscreen
map("n", "gldf", function()
  vim.cmd.vsplit()
  vim.lsp.buf.definition()
end, { desc = "Goto Definition (vertical)" })
```

Keep `gldv` (vertical split) and `gldh` (horizontal split).

- [ ] **Step 5.2: Fix neogit to not depend on telescope**

In `tilde/.config/nvim/lua/plugins/neo-git.lua`, change:

```lua
dependencies = {
  "nvim-lua/plenary.nvim",
  "sindrets/diffview.nvim",
  "nvim-telescope/telescope.nvim",
},
```

to:

```lua
dependencies = {
  "nvim-lua/plenary.nvim",
  "sindrets/diffview.nvim",
},
```

And change the `opts` block:

```lua
opts = {
  integrations = {
    telescope = true,
    diffview = true,
  },
```

to:

```lua
opts = {
  integrations = {
    telescope = nil,
    diffview = true,
  },
```

- [ ] **Step 5.3: Open Neovim and verify no errors**

```bash
nvim --headless "+Lazy sync" +qa
nvim
```

Expected: No errors on startup, `<leader>gn` opens neogit, no telescope import
errors.

- [ ] **Step 5.4: Commit**

```bash
git add tilde/.config/nvim/lua/config/keymaps.lua tilde/.config/nvim/lua/plugins/neo-git.lua
git commit -m "fix(nvim): remove duplicate gldf keymap and drop telescope neogit dependency"
```

---

## Task 6: Clean up orphaned tmux plugins

**Files:**

- Modify: `tilde/.config/tmux/tmux.conf`

**Context:**  
Three plugins are on disk in `tilde/.config/tmux/plugins/` but not declared in
`tmux.conf`: `tmux-floax`, `tmux-sessionx`, `tmux-yank`. TPM ignores undeclared
plugins — they are loaded but not managed, meaning they can't be updated via
`prefix + U` and their presence is misleading.

`tmux-yank` adds clipboard integration. `tmux-sessionx` is a fuzzy session
switcher (you already have `tmux-sessionizer`). `tmux-floax` is a floating pane
manager.

Decision: Add `tmux-yank` to the config (it's genuinely useful). Remove
`tmux-sessionx` and `tmux-floax` directories since they're superseded by
existing tools (`tmux-sessionizer` and tmux split panes respectively).

Also fix the duplicate `default-terminal` lines: line 1 sets `screen-256color`
and line 51 sets `${TERM}`. Remove line 1 (dead code — overridden by line 51).

- [ ] **Step 6.1: Add tmux-yank to tmux.conf**

In `tilde/.config/tmux/tmux.conf`, after the line:

```
set -g @plugin 'rose-pine/tmux'
```

Add:

```
set -g @plugin 'tmux-plugins/tmux-yank'
```

- [ ] **Step 6.2: Remove the dead `default-terminal` line**

In `tilde/.config/tmux/tmux.conf`, remove line 1:

```
set-option -g default-terminal 'screen-256color'
```

Keep the line that sets it to `${TERM}`.

- [ ] **Step 6.3: Remove orphaned plugin directories**

```bash
rm -rf /Users/abereghici/Development/Personal/dotfiles/tilde/.config/tmux/plugins/tmux-sessionx
rm -rf /Users/abereghici/Development/Personal/dotfiles/tilde/.config/tmux/plugins/tmux-floax
```

- [ ] **Step 6.4: Commit**

```bash
git add tilde/.config/tmux/tmux.conf tilde/.config/tmux/plugins/
git commit -m "fix(tmux): declare tmux-yank, remove orphaned plugins, fix dead default-terminal"
```

---

## Task 7: Wire up yazi as shell file manager

**Files:**

- Modify: `tilde/.config/zsh/aliases.zsh`

**Context:**  
`yazi` is installed via Homebrew but never used. The canonical usage pattern is
a shell function `y()` that:

1. Launches yazi
2. When you quit yazi, reads the last directory yazi was in from a temp file
3. `cd`s to that directory

This means you can navigate a deep project tree in yazi and land directly in the
target directory in your shell — very useful for large monorepos.

The function uses yazi's `--cwd-file` flag which writes the current directory on
exit.

- [ ] **Step 7.1: Add yazi `y()` function to `aliases.zsh`**

In `tilde/.config/zsh/aliases.zsh`, add after the `eza` aliases block:

```zsh
# Yazi: TUI file manager with shell cd-on-exit
# https://yazi-rs.github.io/docs/quick-start#shell-wrapper
# Usage: y [path]  — opens yazi, cds to directory on exit
y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if [ -f "$tmp" ]; then
    local cwd
    cwd="$(cat "$tmp")"
    rm -f "$tmp"
    if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd "$cwd"
    fi
  fi
}
```

- [ ] **Step 7.2: Test yazi integration**

```bash
y ~/Development
# navigate to a subdirectory in yazi, press q
# verify shell has cd'd to that directory
pwd
```

Expected: shell is in the directory you were browsing when you quit yazi.

- [ ] **Step 7.3: Commit**

```bash
git add tilde/.config/zsh/aliases.zsh
git commit -m "feat(shell): add yazi y() wrapper for cd-on-exit file navigation"
```

---

## Task 8: Add npm scripts and fix package.json

**Files:**

- Modify: `package.json`
- Read: `prettier.config.cjs` (verify it exists)

**Context:**  
`package.json` has no `scripts` field — prettier must be run manually with
`npx prettier`. Adding `format` and `format:check` scripts makes CI and
pre-commit hooks straightforward. Also fix `"private": "true"` (string) →
`"private": true` (boolean).

- [ ] **Step 8.1: Read prettier.config.cjs to understand the config**

```bash
cat /Users/abereghici/Development/Personal/dotfiles/prettier.config.cjs
```

- [ ] **Step 8.2: Update `package.json`**

Replace the `package.json` content with:

```json
{
  "name": "dotfiles",
  "version": "0.0.1",
  "description": "My personal dotfiles for configuring macOS with Zsh and Homebrew.",
  "private": true,
  "engines": {
    "node": ">=20"
  },
  "author": "Alexandru Bereghici",
  "license": "MIT",
  "scripts": {
    "format": "prettier --write \"**/*.{sh,zsh,bash}\"",
    "format:check": "prettier --check \"**/*.{sh,zsh,bash}\""
  },
  "devDependencies": {
    "husky": "9.1.7",
    "prettier": "3.4.2",
    "prettier-plugin-sh": "0.14.0"
  }
}
```

- [ ] **Step 8.3: Install updated dependencies**

```bash
cd /Users/abereghici/Development/Personal/dotfiles && npm install
```

- [ ] **Step 8.4: Verify format script works**

```bash
npm run format:check
```

Expected: Lists files checked (or exits 0 if all formatted).

- [ ] **Step 8.5: Commit**

```bash
git add package.json package-lock.json
git commit -m "chore(npm): add format scripts, fix private field, add husky dependency"
```

---

## Task 9: Add pre-commit hook for prettier

**Files:**

- Create: `.husky/pre-commit`

**Context:**  
`.husky/` exists but is empty — git hooks infrastructure was started but never
completed. A pre-commit hook that runs `prettier --check` on staged shell files
ensures formatting is never accidentally broken.

- [ ] **Step 9.1: Initialize husky**

```bash
cd /Users/abereghici/Development/Personal/dotfiles && npx husky init
```

This creates `.husky/pre-commit` with a default `npm test` content.

- [ ] **Step 9.2: Write the pre-commit hook**

Replace the content of `.husky/pre-commit` with:

```sh
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

# Run prettier on staged shell files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(sh|zsh|bash)$' || true)

if [ -n "$STAGED_FILES" ]; then
  echo "Running prettier on staged shell files..."
  echo "$STAGED_FILES" | xargs npx prettier --check
fi
```

- [ ] **Step 9.3: Make the hook executable**

```bash
chmod +x /Users/abereghici/Development/Personal/dotfiles/.husky/pre-commit
```

- [ ] **Step 9.4: Test the hook fires**

Stage a shell file and make a test commit, then revert it:

```bash
cd /Users/abereghici/Development/Personal/dotfiles
# Stage something (pick any already-formatted shell file)
git add tilde/.config/zsh/aliases.zsh
# Make a real test commit — the hook will fire
git commit -m "test: verify pre-commit hook runs"
# Revert the test commit
git reset --soft HEAD~1
git restore --staged tilde/.config/zsh/aliases.zsh
```

Expected: The hook prints "Running prettier on staged shell files..." and
exits 0.

Make a test commit to verify the hook runs (then reset):

```bash
git commit --dry-run
```

- [ ] **Step 9.5: Commit**

```bash
git add .husky/pre-commit
git commit -m "chore(hooks): add pre-commit prettier check for shell files"
```

---

## Task 10: Add bats tests for symlinks and setup

**Files:**

- Create: `tests/symlinks.bats`
- Create: `tests/setup.bats`
- Modify: `setup/Brewfile` (add `bats-core`)
- Modify: `package.json` (add `test` script)

**Context:**  
`tests/` is empty. `bats` (Bash Automated Testing System) is the standard tool
for testing shell scripts and setup correctness. The most valuable tests are:

1. Verify symlinks are correctly created for all `tilde/` entries
2. Verify required commands are on PATH after a setup

- [ ] **Step 10.1: Add bats-core to Brewfile**

In `setup/Brewfile`, under `## Development Tools`, add:

```
brew "bats-core" # Bash Automated Testing System
```

- [ ] **Step 10.2: Install bats-core**

```bash
brew install bats-core
```

- [ ] **Step 10.3: Write symlink tests**

Create `tests/symlinks.bats`:

```bash
#!/usr/bin/env bats

# Tests that all items in tilde/ are symlinked correctly into $HOME

DOTFILES_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
TILDE_DIR="$DOTFILES_DIR/tilde"

@test "tilde directory exists" {
  [ -d "$TILDE_DIR" ]
}

@test ".zshrc is symlinked to tilde/.zshrc" {
  [ -L "$HOME/.zshrc" ]
  [ "$(readlink "$HOME/.zshrc")" = "$TILDE_DIR/.zshrc" ]
}

@test ".gitconfig is symlinked to tilde/.gitconfig" {
  [ -L "$HOME/.gitconfig" ]
  [ "$(readlink "$HOME/.gitconfig")" = "$TILDE_DIR/.gitconfig" ]
}

@test ".gitignore is symlinked to tilde/.gitignore" {
  [ -L "$HOME/.gitignore" ]
  [ "$(readlink "$HOME/.gitignore")" = "$TILDE_DIR/.gitignore" ]
}

@test ".ripgreprc is symlinked to tilde/.ripgreprc" {
  [ -L "$HOME/.ripgreprc" ]
  [ "$(readlink "$HOME/.ripgreprc")" = "$TILDE_DIR/.ripgreprc" ]
}

@test ".starship.toml is symlinked to tilde/.starship.toml" {
  [ -L "$HOME/.starship.toml" ]
  [ "$(readlink "$HOME/.starship.toml")" = "$TILDE_DIR/.starship.toml" ]
}

@test ".config/nvim is symlinked to tilde/.config/nvim" {
  [ -L "$HOME/.config/nvim" ]
  [ "$(readlink "$HOME/.config/nvim")" = "$TILDE_DIR/.config/nvim" ]
}

@test ".config/tmux is symlinked to tilde/.config/tmux" {
  [ -L "$HOME/.config/tmux" ]
  [ "$(readlink "$HOME/.config/tmux")" = "$TILDE_DIR/.config/tmux" ]
}

@test ".config/ghostty is symlinked to tilde/.config/ghostty" {
  [ -L "$HOME/.config/ghostty" ]
  [ "$(readlink "$HOME/.config/ghostty")" = "$TILDE_DIR/.config/ghostty" ]
}

@test ".config/zsh is symlinked to tilde/.config/zsh" {
  [ -L "$HOME/.config/zsh" ]
  [ "$(readlink "$HOME/.config/zsh")" = "$TILDE_DIR/.config/zsh" ]
}

@test ".config/bat is symlinked to tilde/.config/bat" {
  [ -L "$HOME/.config/bat" ]
  [ "$(readlink "$HOME/.config/bat")" = "$TILDE_DIR/.config/bat" ]
}

@test ".config/aerospace is symlinked to tilde/.config/aerospace" {
  [ -L "$HOME/.config/aerospace" ]
  [ "$(readlink "$HOME/.config/aerospace")" = "$TILDE_DIR/.config/aerospace" ]
}
```

- [ ] **Step 10.4: Write setup/command availability tests**

Create `tests/setup.bats`:

```bash
#!/usr/bin/env bats

# Tests that required commands are available after setup
# NOTE: bats @test blocks cannot be generated in loops — each command needs
# its own explicit @test block.

@test "homebrew is installed" {
  command -v brew
}

@test "mise is available" {
  command -v mise
}

@test "bat uses rose-pine-moon theme (no BAT_THEME override)" {
  # env.zsh must not export BAT_THEME so bat/config is used
  run bash -c 'source ~/.zshrc 2>/dev/null; echo "${BAT_THEME:-}"'
  [ "$output" = "" ]
}

@test "bat is available" { command -v bat; }
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
```

- [ ] **Step 10.5: Add test script to `package.json`**

In `package.json`, add to `scripts`:

```json
"test": "bats tests/"
```

- [ ] **Step 10.6: Run the tests**

```bash
cd /Users/abereghici/Development/Personal/dotfiles && bats tests/
```

Expected: All symlink tests pass (if you're running on a machine where setup.sh
has been run). Command availability tests depend on what's installed.

- [ ] **Step 10.7: Commit**

```bash
git add tests/symlinks.bats tests/setup.bats setup/Brewfile package.json
git commit -m "test: add bats tests for symlinks and required command availability"
```

---

## Verification

After all tasks are complete, run final verification:

```bash
# 1. Shell startup time
time zsh -i -c exit
# Expected: <300ms

# 2. All tests pass
cd /Users/abereghici/Development/Personal/dotfiles && bats tests/
# Expected: All tests pass

# 3. Format check passes
npm run format:check
# Expected: All shell files are formatted

# 4. Git aliases work
git branchname # should print current branch
git publish    # should push to current branch (dry-run: git publish --dry-run if supported)

# 5. Neovim loads clean
nvim --headless "+Lazy check" +qa
# Expected: no errors

# 6. bat uses rose-pine-moon
bat --config-file # should show config path
bat README.md     # should use rose-pine-moon colors

# 7. yazi wrapper works
y . # should open yazi in current dir, cd on exit

# 8. mise active
mise current node # should show node 24.x.x
```
