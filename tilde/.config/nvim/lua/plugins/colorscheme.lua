-- Bereghici Dark/Light from abereghici/themes (installed by setup/misc.sh). It
-- follows 'background', which Neovim updates when the terminal reports a new appearance, so it
-- switches live with macOS. Without the themes (setup not run yet) Neovim falls back to habamax.
local dir = vim.fn.expand("~/.local/share/bereghici/ports/nvim")
local installed = vim.uv.fs_stat(dir) ~= nil

return {
  {
    dir = dir,
    name = "bereghici",
    cond = installed,
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        transparency = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = installed and "bereghici" or "habamax",
    },
  },
}
