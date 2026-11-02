# Contributing

Thanks for taking the time to help. These are personal dotfiles, so the bar for
changes is narrow: pull requests that **fix bugs** or **improve something
without breaking changes** are welcome. For a different setup, fork the
repository instead.

## Before you start

- For anything bigger than a small fix, open an issue first so we can agree on
  the change.
- Never commit secrets, tokens, email addresses or work-related data. Secrets
  live in the macOS Keychain (see [`bin/keychain`](bin/keychain)) and
  machine-specific settings in the untracked `*.local` files described in the
  [README](README.md#local-customizations).
- To report a security issue, follow [SECURITY.md](SECURITY.md) instead of
  opening a public issue.

## Development setup

```shell
# your fork; replace USERNAME
git clone https://github.com/USERNAME/dotfiles.git
cd dotfiles
npm ci # installs prettier, stylua and the pre-commit hook
```

The pre-commit hook (husky + lint-staged) checks the formatting of the files you
stage.

## Checks

Run these before opening a pull request. [CI](.github/workflows/ci.yml) runs all
but the last on every pull request and every push to `main`.

| Check                         | Command                                                        |
| ----------------------------- | -------------------------------------------------------------- |
| Shell formatting              | `npm run format:check`                                         |
| Lua formatting (Neovim)       | `npm run lint:lua:check`                                       |
| Shell syntax and lint         | `bash -n <script>` and `shellcheck -S warning <script>`        |
| Brewfile syntax               | `ruby -c setup/Brewfile`                                       |
| Linking into a fresh `HOME`   | `bats tests/fresh` (macOS; changes nothing outside a temp dir) |
| Installed setup (on your Mac) | `npm test`                                                     |

`npm run format` and `npm run lint:lua` fix the formatting for you. bats comes
from the Brewfile (`bats-core`). `npm test` checks a machine where the dotfiles
are installed, so run it after `./setup.sh`; it changes nothing.

## Pull requests

- Keep each pull request to one change, and explain why it is needed.
- Use [Conventional Commits](https://www.conventionalcommits.org/) for commit
  messages, as the history does: `feat(nvim): …`, `fix(zsh): …`, `chore: …`.
- Update the [README](README.md), [`setup/README.md`](setup/README.md) or
  [`docs/`](docs/) when you change behavior they document. Each claim there
  should be checkable against the code.
- Test on macOS. Mention your macOS version and whether the Mac is Apple silicon
  or Intel.
