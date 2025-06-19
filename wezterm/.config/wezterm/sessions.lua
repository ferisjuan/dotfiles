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
		workspace = "dotfiles",
		cwd = wezterm.home_dir .. "/dotfiles",
		args = args,
	})

	cfg_tab:set_title("Editor")
	cfg_pane:send_text("nv\n")

	-- add your workspaces here
	local projects = require("projects")

	for _, v in ipairs(projects) do
		local local_dir = wezterm.home_dir .. v.cwd
		local project_tab, project_pane, project_window = mux.spawn_window({
			workspace = v.name,
			cwd = local_dir,
			args = args,
			height = 200,
			width = 200,
		})

		project_tab:set_title("Editor")
		project_pane:send_text("nv\n")

		local term_tab = project_window:spawn_tab({ cwd = local_dir })
		term_tab:set_title("Term")

		local term_pane = term_tab:active_pane()
		term_pane:split({ direction = "Top", size = 0.6 })
	end

	mux.set_active_workspace("dotfiles")
end)
