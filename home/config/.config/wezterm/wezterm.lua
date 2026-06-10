local wezterm = require 'wezterm'
local config = wezterm.config_builder and wezterm.config_builder() or {}

config = require("loader")["global"](config)
config = require("loader")[wezterm.target_triple](config)


return config
