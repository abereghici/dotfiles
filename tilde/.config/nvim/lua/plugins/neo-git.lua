return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    config = true,
    opts = {
      integrations = {
        telescope = true,
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
