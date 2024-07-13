return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- Open as floating window
      opts.window.position = "float"
    end,
  },
}
