local wezterm = require("wezterm")

local module = {}

function module.apply_to_config(config)
	config.color_scheme = "Tokyo Night Storm"
	config.font = wezterm.font({ family = "JetBrains Mono" })
	config.font_size = 16
	config.window_background_opacity = 0.9
	config.text_background_opacity = 0.3
end

return module
