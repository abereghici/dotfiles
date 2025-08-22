---@param kind string
local function pick(kind)
  return function()
    local actions = require("CopilotChat.actions")
    local items = actions[kind .. "_actions"]()
    if not items then
      LazyVim.warn("No " .. kind .. " found on the current line")
      return
    end
    local ok = pcall(require, "fzf-lua")
    require("CopilotChat.integrations." .. (ok and "fzflua" or "telescope")).pick(items)
  end
end

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    keys = {
      { "<leader>ac", "", desc = "+copilot-chat", mode = { "n", "v" } },
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>aa", false },
      {
        "<leader>aca",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      { "<leader>ax", false },
      {
        "<leader>acx",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      { "<leader>aq", false },
      {
        "<leader>acq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      -- Show prompts actions with telescope
      { "<leader>ap", false },
      {
        "<leader>acp",
        pick("prompt"),
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
    },
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
