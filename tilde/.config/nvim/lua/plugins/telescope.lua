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
        pickers = {
          find_files = {
            hidden = true,
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
          grep_string = {
            additional_args = { "--hidden" },
          },
          live_grep = {
            file_ignore_patterns = { ".git" },
            additional_args = { "--hidden" },
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
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    },
  },
}
