local wezterm = require("wezterm")

local config = wezterm.config_builder()

local theme = require("lua/rose-pine").moon

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 10
config.window_frame = theme.window_frame()

config.colors = theme.colors()

config.font = wezterm.font({
	family = "MesloLGS Nerd Font",
	weight = "Medium",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})

config.font_size = 16.0

return config
