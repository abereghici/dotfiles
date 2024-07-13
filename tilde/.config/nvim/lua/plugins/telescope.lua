return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("live_grep_args")

      telescope.setup({
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            theme = "dropdown",
          },
        },
      })

      vim.keymap.set(
        "n",
        "<leader>sf",
        require("telescope").extensions.live_grep_args.live_grep_args,
        { noremap = true, desc = "Grep (filter) with args" }
      )
    end,
  },
}
