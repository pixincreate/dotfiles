local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function()
  local _, _, window = mux.spawn_window({})
  local gui_window = window:gui_window()
  gui_window:maximize()
end)
