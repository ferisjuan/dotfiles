local wezterm = require("wezterm")
local act = wezterm.action

local module = {}

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

function module.apply_to_config(config)
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

	config.keys = {
		-- Tabs config
		{ key = "h", mods = "LEADER", action = act.ActivateTabRelative(-1) },
		{ key = "l", mods = "LEADER", action = act.ActivateTabRelative(1) },
		{
			key = "|",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = ";",
			mods = "LEADER",
			action = wezterm.action.ActivateCommandPalette,
		},
		{
			key = "c",
			mods = "LEADER",
			action = act.SpawnTab("CurrentPaneDomain"),
		},
		{ key = "h", mods = "CMD", action = act.Nop },
		{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },
		{ key = "m", mods = "CMD", action = act.Nop },
		{
			key = "p",
			mods = "LEADER",
			action = act.PaneSelect({
				alphabet = "1234567890",
			}),
		},
		{
			key = "P",
			mods = "LEADER",
			action = act.PaneSelect({
				alphabet = "1234567890",
				mode = "SwapWithActive",
			}),
		},
		{
			key = "w",
			mods = "LEADER",
			action = act.CloseCurrentTab({ confirm = true }),
		},
		-- Workspaces
		{
			key = "W",
			mods = "CTRL|SHIFT",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:perform_action(
							act.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},
		{
			key = "w",
			mods = "ALT",
			action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
		},
	}

	for i = 1, 8 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = "LEADER",
			action = act.ActivateTab(i - 1),
		})
	end
end

return module
