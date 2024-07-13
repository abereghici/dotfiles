-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local discipline = require("bereghicidev.discipline")
discipline.cowboy()

-- Increment/decrement remap
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment" })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement" })

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Join lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (cursor stationary)" })

-- Add new lines
vim.keymap.set("n", "<Leader>o", "mpo<Esc>`p", { desc = "Add new line below" })
vim.keymap.set("n", "<Leader>O", "mpO<Esc>`p", { desc = "Add new line above" })

-- Move lines remap
vim.keymap.set("n", "<C-k>", "<A-k>", { remap = true })
vim.keymap.set("n", "<C-j>", "<A-j>", { remap = true })

vim.keymap.set("v", "<C-k>", "<A-k>", { remap = true })
vim.keymap.set("v", "<C-j>", "<A-j>", { remap = true })

vim.keymap.set("i", "<C-k>", "<A-k>", { remap = true })
vim.keymap.set("i", "<C-j>", "<A-j>", { remap = true })
