local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()
require("sessions")

-- region toggle-opacity
wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.9
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)
-- end region

-- region fonts
config.font = wezterm.font_with_fallback({
	{
		family = "Hack Nerd Font Mono",
		weight = "Medium",
		harfbuzz_features = { "calt=0", "clig=0", "liga=1" },
	},
	{ family = "FiraCode Nerd Font Mono", weight = "Medium", harfbuzz_features = { "calt=0", "clig=0", "liga=1" } },
})
-- end region

-- region toast position
wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)
-- end region

--region plugins
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
--endregion

if wezterm.config_builder then
	config = wezterm.config_builder()
end

--#region Configuration
config.color_scheme = "Everforest Dark (Gogh)"
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 18
config.line_height = 1.05
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
--#endregion

--#region keybinding
config.leader = { key = "h", mods = "CMD", timeout_milliseconds = 2000 }

config.keys = {
	{ mods = "LEADER", key = "b", action = wezterm.action.EmitEvent("toggle-opacity") },
	{
		mods = "LEADER",
		key = "c",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "x",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "p",
		action = act.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = act.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "|",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "SHIFT|ALT",
		key = "h",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		mods = "SHIFT|ALT",
		key = "j",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		mods = "SHIFT|ALT",
		key = "k",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		mods = "SHIFT|ALT",
		key = "s",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		mods = "ALT",
		key = "LeftArrow",
		action = act.AdjustPaneSize({ "Left", 10 }),
	},
	{
		mods = "ALT",
		key = "DownArrow",
		action = act.AdjustPaneSize({ "Down", 10 }),
	},
	{
		mods = "ALT",
		key = "UpArrow",
		action = act.AdjustPaneSize({ "Up", 10 }),
	},
	{
		mods = "ALT",
		key = "RightArrow",
		action = act.AdjustPaneSize({ "Right", 10 }),
	},
	-- Create a new workspace with a random name and switch to it
	{ key = "i", mods = "LEADER", action = act.SwitchToWorkspace },

	--#region smart workspace switcher
	{
		key = "[",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	},
	{
		key = "]",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	},
	--#endregion

	-- #region resurrect
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	{
		key = "W",
		mods = "ALT",
		action = resurrect.window_state.save_window_action(),
	},
	{
		key = "T",
		mods = "ALT",
		action = resurrect.tab_state.save_tab_action(),
	},
	{
		key = "s",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
		end),
	},
	{
		key = "r",
		mods = "ALT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = true,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.state_manager.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.state_manager.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.state_manager.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
	-- #endregion
}
--#endregion

--#region tabs
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

for i = 0, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "WIN",
		action = act.ActivateTab(i),
	})
end
--#endregion

--#region resurrect
-- loads the state whenever I create a new workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
	local workspace_state = resurrect.workspace_state

	workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

-- Saves the state whenever I select a workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
	local workspace_state = resurrect.workspace_state
	resurrect.state_manager.save_state(workspace_state.get_workspace_state())
end)

wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
--#endregion resurrect

-- and finally, return the configuration to wezterm
bar.apply_to_config(config, {
	modules = {
		clock = {
			enabled = false,
		},
		-- pane = {
		-- 	enabled = false,
		-- },
	},
})

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, workspace)
	local gui_win = window:gui_window()
	local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
	gui_win:set_right_status(wezterm.format({
		{ Foreground = { Color = "green" } },
		{ Text = base_path .. "  " },
	}))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, workspace)
	local gui_win = window:gui_window()
	local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
	gui_win:set_right_status(wezterm.format({
		{ Foreground = { Color = "green" } },
		{ Text = base_path .. "  " },
	}))
end)

workspace_switcher.switch_workspace({ extra_args = " | rg -Fxf ~/wps/IH/" })
workspace_switcher.apply_to_config(config)
--#endregion workspace suitcher

return config
