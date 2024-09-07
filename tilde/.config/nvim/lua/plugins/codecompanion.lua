return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    {
      "stevearc/dressing.nvim",
      opts = {},
    },
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        llama = function()
          return require("codecompanion.adapters").extend("ollama", {
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
          })
        end,
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
}
