-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local discipline = require("bereghicidev.discipline")
discipline.cowboy()

-- Select all
vim.keymap.set("n", "<Leader>ya", "ggVGy<C-O>", { desc = "Select all" })

-- Add new lines
vim.keymap.set("n", "<Leader>o", "mpo<Esc>`p", { desc = "Add new line below" })
vim.keymap.set("n", "<Leader>O", "mpO<Esc>`p", { desc = "Add new line above" })
