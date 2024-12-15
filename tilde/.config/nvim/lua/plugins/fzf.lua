return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      local actions = require("fzf-lua.actions")
      opts.winopts.fullscreen = true
      opts.winopts.preview.layout = "vertical"

      opts.files = {
        actions = {
          ["alt-I"] = { actions.toggle_ignore },
          ["alt-H"] = { actions.toggle_hidden },
        },
      }
      opts.grep = {
        actions = {
          ["alt-I"] = { actions.toggle_ignore },
          ["alt-H"] = { actions.toggle_hidden },
        },
      }
    end,
  },
}
