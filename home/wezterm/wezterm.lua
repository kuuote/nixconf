local wezterm = require("wezterm")

-- from https://zenn.dev/yutakatay/articles/wezterm-intro
wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
	wezterm.log_error("1")
	local scrollback = pane:get_lines_as_text()
	local name = os.tmpname()
	local f = io.open(name, "w+")
	f:write(scrollback)
	f:flush()
	f:close()
	window:perform_action(
		wezterm.action({ SpawnCommandInNewTab = {
			args = { "nvim", name },
		} }),
		pane
	)
	wezterm.sleep_ms(1000)
	os.remove(name)
end)

-- original from https://github.com/monaqa/dotfiles/blob/dd2fccd76c6e9390fb93316fadcaad2b906d10d2/.config/wezterm/wezterm.lua
-- change to textbg
wezterm.on("toggle-bg-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.text_background_opacity then
		overrides.text_background_opacity = 0.6
	else
		overrides.text_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("toggle-jiskan", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.font then
		overrides.font = wezterm.font("JF Dot jiskan16s-2000")
		overrides.font_size = 12
	-- overrides.font = wezterm.font('JF Dot k12x10')
	-- overrides.font_size = 16
	else
		overrides.font = nil
		overrides.font_size = nil
	end
	window:set_config_overrides(overrides)
end)

local one = wezterm.get_builtin_color_schemes()["OneHalfDark"]
one.background = "black"
local color_schemes = { OneHalfDark = one }

-- local font = wezterm.font('PlemolJP Console'),
local font = wezterm.font("Noto Sans Mono CJK JP")
-- local font = nil

-- :'<,'>call vimrc#blocksort('^  \w+ =', '.*')
local settings = {
	color_scheme = "OneHalfDark",
	color_schemes = color_schemes,
	enable_csi_u_key_encoding = true,
	font = font,
	font_size = 14,
  front_end = "WebGpu",
	hide_tab_bar_if_only_one_tab = true,
	keys = {
		{ key = "B", mods = "ALT", action = wezterm.action({ EmitEvent = "toggle-bg-opacity" }) },
		{ key = "J", mods = "ALT", action = wezterm.action({ EmitEvent = "toggle-jiskan" }) },
		-- simulate modifyOtherKeys
		-- {key="Enter", mods="CTRL", action=wezterm.action.SendString('\x1b[13;5u')},
		-- {key="Enter", mods="SHIFT", action=wezterm.action.SendString('\x1b[13;2u')},
	},
	use_ime = false, -- skkeleton使ってるので(ry
	window_background_opacity = 0.7,
	window_padding = {
		left = "0cell",
		right = "0cell",
		top = "0cell",
		bottom = "0cell",
	},
}

return settings
