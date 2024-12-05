local wezterm = require("wezterm")
local theme = require("lua.themes.rose-pine").moon

local M = {}

M.colors = theme.colors()

M.font = wezterm.font({
	family = "MesloLGS Nerd Font",
	weight = "Medium",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})

M.font_size = 16.0

M.enable_tab_bar = false
M.window_frame = theme.window_frame()
M.window_decorations = "RESIZE"
M.window_background_opacity = 0.95
M.macos_window_background_blur = 10

return M
