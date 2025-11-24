return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      opts.winopts.preview.layout = "vertical"

      -- Make the window transparent
      opts.winopts.backdrop = false -- Remove backdrop

      opts.files = {
        actions = {
          -- Open file dir using oil.nvim
          ["ctrl-o"] = function(sel, opt)
            local path = require("fzf-lua.path")
            local file = path.entry_to_file(sel[1], opt)
            local filename = file.bufname or file.path or file.uri
            if filename then
              require("oil").toggle_float(path.parent(filename, true))
            end
          end,
        },
      }

      -- Set transparent backgrounds for fzf-lua windows
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fzf",
        callback = function()
          vim.cmd([[
            highlight FzfLuaNormal guibg=NONE
            highlight FzfLuaBorder guibg=NONE
            highlight FzfLuaTitle guibg=NONE
          ]])
        end,
      })
    end,
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    },
  },
}
