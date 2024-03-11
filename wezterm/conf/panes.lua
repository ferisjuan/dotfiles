local module = {}

function module.apply_to_config(config)
	config.inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.8,
	}
end

return module
