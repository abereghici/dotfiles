return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      opts.winopts.preview.layout = "vertical"
    end,
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    },
  },
}
