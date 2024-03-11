local ui = require("conf/ui")
local keys = require("conf/keys")
local mouse = require("conf/mouse")
local panes = require("conf/panes")
local tabbar = require("conf/tabbar")

local config = {}

ui.apply_to_config(config)
keys.apply_to_config(config)
mouse.apply_to_config(config)
panes.apply_to_config(config)
tabbar.apply_to_config(config)

return config
