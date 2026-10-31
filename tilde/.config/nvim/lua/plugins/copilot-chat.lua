return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- a function replaces the extra's <leader>a* keys instead of adding to them
    keys = function()
      return {
        { "<c-s>", "<cr>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
        { "<leader>ac", "", desc = "+ai", mode = { "n", "x" } },
        {
          "<leader>aca",
          function()
            return require("CopilotChat").toggle()
          end,
          desc = "Toggle (CopilotChat)",
          mode = { "n", "x" },
        },
        {
          "<leader>acx",
          function()
            return require("CopilotChat").reset()
          end,
          desc = "Clear (CopilotChat)",
          mode = { "n", "x" },
        },
        {
          "<leader>acq",
          function()
            vim.ui.input({
              prompt = "Quick Chat: ",
            }, function(input)
              if input ~= "" then
                require("CopilotChat").ask(input)
              end
            end)
          end,
          desc = "Quick Chat (CopilotChat)",
          mode = { "n", "x" },
        },
        {
          "<leader>acp",
          function()
            require("CopilotChat").select_prompt()
          end,
          desc = "Prompt Actions (CopilotChat)",
          mode = { "n", "x" },
        },
      }
    end,
    opts = {
      window = {
        layout = "float",
        width = 0.7,
        height = 0.7,
      },
    },
  },
}
