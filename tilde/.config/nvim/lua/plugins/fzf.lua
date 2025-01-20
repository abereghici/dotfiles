return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      opts.winopts.preview.layout = "vertical"

      opts.files = {
        actions = {
          -- Open file dir using oil.nvim
          ["ctrl-o"] = function(sel, opt)
            local path = require("fzf-lua.path")
            local file = path.entry_to_file(sel[1], opt)
            local filename = file.bufname or file.path or file.uri
            require("oil").toggle_float(path.parent(filename, true))
          end,
        },
      }
    end,
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    },
  },
}
