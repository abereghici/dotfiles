return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = function()
      local custom_prompts = require("bereghicidev.custom-prompts")
      return {
        window = {
          layout = "float",
          width = 0.7,
          height = 0.7,
        },
        prompts = {
          ImproveAndCorrectText = {
            system_prompt = custom_prompts.IMPROVE_AND_CORRECT_TEXT,
            prompt = "Improve and correct the highlighted text",
            selection = require("CopilotChat.select").visual,
          },
        },
      }
    end,
  },
}
