return {
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = {
      "AiderTerminalToggle",
      "AiderHealth",
    },
    keys = {
      { "<leader>aa", "", desc = "+aider", mode = { "n", "v" } },
      { "<leader>aa/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
      { "<leader>aas", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
      { "<leader>aac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
      { "<leader>aab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
      { "<leader>aa+", "<cmd>Aider add<cr>", desc = "Add File" },
      { "<leader>aa-", "<cmd>Aider drop<cr>", desc = "Drop File" },
      { "<leader>aar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
      { "<leader>aaR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
    },
    config = {
      -- Command that executes Aider
      aider_cmd = "start-aider",
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
