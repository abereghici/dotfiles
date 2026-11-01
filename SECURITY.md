# Security Policy

## Supported versions

Only the latest commit on the `main` branch is supported. Please check that an
issue still exists there before reporting it.

## Reporting a vulnerability

Please **do not open a public issue**. Report it privately through
[GitHub's private vulnerability reporting](https://github.com/abereghici/dotfiles/security/advisories/new).

Include what is affected, how to reproduce it and the impact you expect. You can
expect a first reply within a week. Once a fix is in, the advisory is published
with credit to you, unless you prefer otherwise.

## Scope

These dotfiles run with your user's privileges and, in a few places, with
`sudo`. Reports are especially welcome about:

- the setup scripts ([`setup.sh`](setup.sh) and [`setup/`](setup/)), which
  install software and change system settings
- secrets handling ([`bin/keychain`](bin/keychain)) or anything that could leak
  a secret into the repository, shell history or logs
- configs that load code from outside this repository (plugins, installers)

Issues in the tools themselves (Homebrew, Neovim, herdr…) belong upstream.
