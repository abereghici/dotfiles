return {
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = {
      "AiderTerminalToggle",
      "AiderHealth",
    },
    keys = {
      { "<leader>a/", "<cmd>AiderTerminalToggle<cr>", desc = "Open Aider" },
      { "<leader>as", "<cmd>AiderTerminalSend<cr>", desc = "Send to Aider", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>AiderQuickSendCommand<cr>", desc = "Send Command To Aider" },
      { "<leader>ab", "<cmd>AiderQuickSendBuffer<cr>", desc = "Send Buffer To Aider" },
      { "<leader>a+", "<cmd>AiderQuickAddFile<cr>", desc = "Add File to Aider" },
      { "<leader>a-", "<cmd>AiderQuickDropFile<cr>", desc = "Drop File from Aider" },
      { "<leader>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
    },
    config = {
      -- Command that executes Aider
      aider_cmd = "uv run aider",
      -- Command line arguments passed to aider
      args = {},
      theme = {
        user_input_color = "#9ccfd8", -- foam
        tool_output_color = "#3e8fb0", -- pine
        tool_error_color = "#eb6f92", -- love
        tool_warning_color = "#f6c177", -- gold
        assistant_output_color = "#c4a7e7", -- iris
        completion_menu_color = "#e0def4", -- text
        completion_menu_bg_color = "#232136", -- base
        completion_menu_current_color = "#393552", -- overlay
        completion_menu_current_bg_color = "#ebbcba", -- rose
      },
    },
  },
}
