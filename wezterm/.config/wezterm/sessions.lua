local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end

	-- Wezterm config
	local cfg_tab, cfg_pane = mux.spawn_window({
		workspace = "Config",
		cwd = wezterm.home_dir .. "dotfiles",
		args = args,
	})

	cfg_tab:set_title("Dotfiles config")
	cfg_pane:send_text("cd ~/dotfiles\n")
	cfg_pane:send_text("nv\n")

	-- add your workspaces here
	local projects = require("projects")

	print(wezterm.home_dir)

	for _, v in ipairs(projects) do
		local local_dir = wezterm.home_dir .. v.cwd
		local tab, editor_pane, window = mux.spawn_window({
			workspace = v.name,
			cwd = local_dir,
			args = args,
			height = 200,
			width = 300,
		})

		tab:set_title(v.name)
		editor_pane:send_text("nv\n")
		-- local term_pane = editor_pane:split({ direction = "Right", size = 0.4 })
		-- term_pane:send_text("sz\n")
		-- term_pane:split({ direction = "Bottom", size = 0.3 })
		-- editor_pane:activate()
		local term_tab = window:spawn_tab({ cwd = local_dir })
		term_tab:set_title("Term")
	end

	mux.set_active_workspace("Resident Payment Website")
end)
