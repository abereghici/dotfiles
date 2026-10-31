-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Use snacks.picker instead of the legacy fzf-lua default.
-- (Our install_version is 7, so LazyVim would otherwise auto-select fzf.)
vim.g.lazyvim_picker = "snacks"

-- Use TypeScript 7's native language server (`tsc --lsp`) instead of vtsls,
-- which bundles TypeScript 5.9 and can't load a TS 7 project's tsconfig.
vim.g.lazyvim_ts_lsp = "tsgo"

-- Disable the language providers that have no host installed (no pynvim, cpan or gem
-- host); node stays on, since mise installs the `neovim` npm package for it.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
