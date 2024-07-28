return {
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        adapters = {
          llama = require("codecompanion.adapters").use("ollama", {
            schema = {
              model = {
                default = "llama3.1:latest",
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          }),
        },
        strategies = {
          chat = { adapter = "llama" },
          inline = { adapter = "llama" },
          agent = { adapter = "llama" },
        },
        display = {
          chat = {
            window = {
              layout = "float", -- float|vertical|horizontal|buffer
            },
          },
        },
      })
    end,
    init = function() end,
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        "<cmd>CodeCompanionToggle<CR>",
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        "<cmd>CodeCompanionActions<CR>",
        desc = "Prompt actions (CodeCompanion)",
        mode = { "n", "v" },
      },
    },
  },
}
