return {
  "stevearc/oil.nvim",
  config = function()
    local oil = require("oil")

    oil.setup({
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you still want to use netrw.
      default_file_explorer = true,
      -- Set to true to watch the filesystem for changes and reload oil
      experimental_watch_for_changes = true,
      -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- Sort file names in a more intuitive order for humans. Is less performant,
        -- so you may want to set to false if you work with large directories.
        natural_order = true,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, _)
          return name == ".git"
        end,
      },
      -- Configuration for the floating window in oil.open_float
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
      },
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = true,
        winblend = 0,
      },
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      use_default_keymaps = false,
      keymaps = {
        ["q"] = "actions.close",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
      },
    })

    vim.keymap.set("n", "<leader>fe", function()
      oil.toggle_float()
    end, {
      desc = "Explorer Oil (Root Dir)",
    })

    vim.keymap.set("n", "<leader>fE", function()
      oil.toggle_float(vim.uv.cwd())
    end, {
      desc = "Explorer Oil (cwd)",
    })

    vim.keymap.set("n", "<leader>e", "<leader>fe", { desc = "Explorer Oil (Root Dir)", remap = true })
    vim.keymap.set("n", "<leader>E", "<leader>fE", { desc = "Explorer Oil (cwd)", remap = true })
  end,
}
