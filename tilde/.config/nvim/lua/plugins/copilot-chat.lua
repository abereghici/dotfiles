return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    keys = {
      { "<leader>ac", "", desc = "+ai", mode = { "n", "x" } },
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
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
    },
    opts = function()
      return {
        window = {
          layout = "float",
          width = 0.7,
          height = 0.7,
        },
      }
    end,
  },
}
