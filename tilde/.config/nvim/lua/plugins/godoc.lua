return {
  {
    "fredrikaverpil/godoc.nvim",
    version = "*",
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest",
    cmd = { "GoDoc" },
    opts = {
      window = {
        type = "vsplit", -- split | vsplit
      },
      picker = {
        type = "snacks", -- native (vim.ui.select) | telescope | snacks | mini | fzf_lua
        snacks = {},
      },
    },
  },
}
