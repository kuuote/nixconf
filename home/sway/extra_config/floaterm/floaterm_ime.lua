local wezterm = require('wezterm')
local config = loadfile(os.getenv('HOME') .. '/.config/wezterm/wezterm.lua')()
config.font = wezterm.font('JF Dot jiskan16s-2000')
config.font_size = 12
return config
