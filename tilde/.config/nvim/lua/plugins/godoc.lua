return {
  {
    "fredrikaverpil/godoc.nvim",
    version = "*",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = { "go" },
        },
      },
    },
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest",
    cmd = { "GoDoc" },
    opts = {
      window = {
        type = "vsplit", -- split | vsplit
      },
      picker = {
        type = "fzf_lua", -- native (vim.ui.select) | telescope | snacks | mini | fzf_lua
        fzf_lua = {},
      },
    },
  },
}
