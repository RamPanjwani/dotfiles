local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()
config.font = wezterm.font 'JetBrains Mono'
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.default_prog = {'pwsh.exe', '-NoLogo'}
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)
return config
