-- VS Code-style live diff review: changes refresh while an agent works, and files and
-- hunks can be staged, unstaged or discarded from the explorer. `?` lists its keys.
local function default_branch()
  local ref = vim.fn.systemlist({ "git", "rev-parse", "--abbrev-ref", "origin/HEAD" })[1]
  return vim.v.shell_error == 0 and ref or "main"
end

return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    opts = {},
    keys = {
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Review Changes (CodeDiff)" },
      {
        "<leader>gD",
        function()
          vim.cmd("CodeDiff " .. default_branch() .. "...")
        end,
        desc = "Review Branch (CodeDiff)",
      },
      { "<leader>gH", "<cmd>CodeDiff history<cr>", desc = "Diff History (CodeDiff)" },
    },
  },
}
