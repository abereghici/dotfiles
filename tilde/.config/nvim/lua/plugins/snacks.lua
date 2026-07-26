return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      image = { enabled = true },
      picker = {
        actions = {
          -- Open the selected file's directory in oil.nvim
          oil_open = function(picker, item)
            picker:close()
            if item and item.file then
              require("oil").toggle_float(vim.fn.fnamemodify(item.file, ":h"))
            end
          end,
        },
        win = {
          input = {
            keys = {
              ["<c-o>"] = { "oil_open", mode = { "n", "i" } },
            },
          },
        },
      },
    },
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    },
  },
  {
    -- Workaround: inline images vanish when returning to an existing buffer.
    -- Remove once fixed upstream: https://github.com/folke/snacks.nvim/issues/2896
    "folke/snacks.nvim",
    opts = function(_, opts)
      local placement = require("snacks.image.placement")
      if not placement._patched_2896 then
        placement._patched_2896 = true
        local update = placement.update
        placement.update = function(self, ...)
          if self.hidden and #self:wins() > 0 then
            self.hidden = false
            self._state = nil
          end
          return update(self, ...)
        end
      end
      return opts
    end,
  },
}
