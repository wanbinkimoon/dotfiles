-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- my coolnight colorscheme
-- config.colors = {
-- 	foreground = "#CBE0F0",
-- 	background = "#011423",
-- 	cursor_bg = "#47FF9C",
-- 	cursor_border = "#47FF9C",
-- 	cursor_fg = "#011423",
-- 	selection_bg = "#033259",
-- 	selection_fg = "#CBE0F0",
-- 	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
-- 	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
-- }

config.color_scheme = "Dracula"
-- config.color_scheme = "tokyonight-night"
-- config.color_scheme = "Batman"

config.font = wezterm.font("JetBrainsMono Nerd Font")
-- config.font = wezterm.font("MesloLGS Nerd Font Mono")
-- config.font = wezterm.font("FiraCode Nerd Font")
-- config.font = wezterm.font("CaskaydiaCove Nerd Font")
-- config.font = wezterm.font("FantasqueSansM Nerd Font")
-- config.font = wezterm.font("Iosevka Nerd Font")
-- config.font = wezterm.font("Monoid Nerd Font")
-- config.font = wezterm.font("VictorMono Nerd Font")
-- config.font = wezterm.font("MonoLisa", { weight = "Light" })

config.harfbuzz_features = { "ss01", "ss02", "ss03", "ss19", "ss20" }

config.font_size = 14
config.line_height = 1.2

config.enable_tab_bar = false
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 0,
}

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

config.window_decorations = "RESIZE"
config.window_background_opacity = 1.95
config.macos_window_background_blur = 40
config.keys = {
	{ mods = "OPT", key = "LeftArrow", action = wezterm.action.SendKey({ mods = "ALT", key = "b" }) },
	{ mods = "OPT", key = "RightArrow", action = wezterm.action.SendKey({ mods = "ALT", key = "f" }) },
	{ mods = "CMD", key = "LeftArrow", action = wezterm.action.SendKey({ mods = "CTRL", key = "a" }) },
	{ mods = "CMD", key = "RightArrow", action = wezterm.action.SendKey({ mods = "CTRL", key = "e" }) },
	{ mods = "CMD", key = "Backspace", action = wezterm.action.SendKey({ mods = "CTRL", key = "u" }) },
}

require("zen-mode")

-- and finally, return the configuration to wezterm
return config
