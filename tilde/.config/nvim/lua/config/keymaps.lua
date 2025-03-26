-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local map = vim.keymap.set

-- Yank all
map("n", "<Leader>ya", "ggVGy<C-O>", { desc = "Yank all" })

-- Add new lines
map("n", "<Leader>o", "mpo<Esc>`p", { desc = "Add new line below" })
map("n", "<Leader>O", "mpO<Esc>`p", { desc = "Add new line above" })

-- Most terminals don't correctly map C-/, and sometimes you need to use C-_ for that key instead
map("n", "<c-/>", "<leader>fT", { desc = "Terminal (cwd)", remap = true })
map("n", "<c-_>", "<leader>fT", { desc = "Terminal (cwd)", remap = true })

-- Open definition in a new vertical split
map("n", "gdv", function()
  vim.cmd.vsplit()
  vim.lsp.buf.definition()
end, { desc = "Goto Definition (vertical)" })

-- Open definition in a new horizontal split
map("n", "gdh", function()
  vim.cmd.split()
  vim.lsp.buf.definition()
end, { desc = "Goto Definition (horizontal)" })
