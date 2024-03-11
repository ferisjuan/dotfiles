local wezterm = require("wezterm")
local act = wezterm.action
local module = {}

function module.apply_to_config(config)
	config.mouse_bindings = {
		-- Right click sends "woot" to the terminal
		-- {
		-- 	event = { Down = { streak = 1, button = "Right" } },
		-- 	mods = "NONE",
		-- 	action = act.SendString("woot"),
		-- },

		-- Change the default click behavior so that it only selects
		-- text and doesn't open hyperlinks
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = act.CompleteSelection("ClipboardAndPrimarySelection"),
		},

		-- and make CTRL-Click open hyperlinks
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
		-- NOTE that binding only the 'Up' event can give unexpected behaviors.
		-- Read more below on the gotcha of binding an 'Up' event only.
		{
			event = { Down = { streak = 1, button = { WheelUp = 1 } } },
			mods = "CTRL",
			action = act.IncreaseFontSize,
		},

		-- Scrolling down while holding CTRL decreases the font size
		{
			event = { Down = { streak = 1, button = { WheelDown = 1 } } },
			mods = "CTRL",
			action = act.DecreaseFontSize,
		},
		-- Bind 'Up' event of CTRL-Click to open hyperlinks
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
		-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.Nop,
		},
	}
end

return module
