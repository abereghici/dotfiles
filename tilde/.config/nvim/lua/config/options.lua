-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Use snacks.nvim as the picker (replaces fzf-lua)
vim.g.lazyvim_picker = "snacks"

-- Disable unused language providers (no remote plugins depend on them).
-- Silences the optional provider warnings in :checkhealth.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
