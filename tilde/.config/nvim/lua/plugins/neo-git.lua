return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Maintained fork of sindrets/diffview.nvim (no upstream release since 2024), same module
      "dlyongemallo/diffview-plus.nvim",
    },
    cmd = "Neogit",
    opts = {
      integrations = {
        diffview = true,
      },
      signs = {
        -- { CLOSED, OPENED }
        hunk = { "", "" },
        item = { "▷", "▽" },
        section = { "▷", "▽" },
      },
    },
    keys = {
      {
        "<leader>gn",
        function()
          local neogit = require("neogit")
          neogit.open()
        end,
        desc = "Neogit",
        mode = { "n", "v" },
      },
    },
  },
}
