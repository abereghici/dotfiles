# New Mac checklist

What I do by hand on a new Mac before running `setup.sh`. None of it is required
by the dotfiles.

1. **Firewall**: turn it on under **System Settings** → **Network** →
   **Firewall**.
1. **DNS**: point the DNS servers to
   [Cloudflare DNS](https://one.one.one.one/dns/) (`1.1.1.1`, `1.0.0.1`,
   `2606:4700:4700::1111`, `2606:4700:4700::1001`).
1. **SSH for GitHub**:
   1. [Generate an SSH key and add it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
   1. [Add the public key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
   1. Test it with `ssh -T git@github.com`
1. **Back up** anything in `~` you want to keep: `setup.sh` backs up the files
   it replaces, but a copy elsewhere is cheap.

After `setup.sh`: run [`setup/macos.sh`](macos.md) if you want its defaults,
turn off the [conflicting shortcuts](macos.md#keyboard-shortcut-conflicts), set
up [Raycast](macos.md#raycast), and add the
[keyboard layout](../keyboard/README.md) after logging in again.
