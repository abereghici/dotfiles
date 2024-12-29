-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local discipline = require("bereghicidev.discipline")
discipline.cowboy()

local map = vim.keymap.set
-- Select all
map("n", "<Leader>ya", "ggVGy<C-O>", { desc = "Select all" })

-- Add new lines
map("n", "<Leader>o", "mpo<Esc>`p", { desc = "Add new line below" })
map("n", "<Leader>O", "mpO<Esc>`p", { desc = "Add new line above" })

-- Most terminals don't correctly map C-/, and sometimes you need to use C-_ for that key instead
map("n", "<c-/>", "<leader>fT", { desc = "Terminal (cwd)", remap = true })
map("n", "<c-_>", "<leader>fT", { desc = "Terminal (cwd)", remap = true })
