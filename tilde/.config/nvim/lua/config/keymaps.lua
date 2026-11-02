-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local map = vim.keymap.set

-- Yank file contents
map("n", "<leader>yc", "ggVGy<c-o>", { desc = "Copy file contents" })
-- Copy current buffer path to clipboard
map("n", "<leader>yp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Path copied to clipboard: " .. path)
end, { desc = "Copy file path" })

-- Add new lines
map("n", "<leader>o", "mpo<esc>`p", { desc = "Add new line below" })
map("n", "<leader>O", "mpO<esc>`p", { desc = "Add new line above" })

-- Most terminals don't correctly map C-/, and sometimes you need to use C-_ for that key instead
map("n", "<c-/>", "<leader>fT", { desc = "Terminal (cwd)", remap = true })
map("n", "<c-_>", "<leader>fT", { desc = "Terminal (cwd)", remap = true })

-- Open definition in a new vertical split
map("n", "gldv", function()
  vim.cmd.vsplit()
  vim.lsp.buf.definition()
end, { desc = "Goto Definition (vertical)" })

-- Open definition in a new horizontal split
map("n", "gldh", function()
  vim.cmd.split()
  vim.lsp.buf.definition()
end, { desc = "Goto Definition (horizontal)" })

-- Ctrl+Alt+h/j/k/l: next nvim split, or at the edge the next herdr pane. herdr sends these
-- chords here only when nvim is focused (herdr/plugins/pane-nav). Ctrl+h/j/k/l stay nvim-only.
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  map({ "n", "i", "x", "t" }, "<C-M-" .. key .. ">", function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)
    local herdr = vim.env.HERDR_BIN_PATH or "herdr"
    if vim.api.nvim_get_current_win() == win and vim.env.HERDR_PANE_ID and vim.fn.executable(herdr) == 1 then
      vim.system({ herdr, "pane", "focus", "--direction", dir, "--pane", vim.env.HERDR_PANE_ID })
    end
  end, { desc = "Window or herdr pane " .. dir })
end
