local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- =========================================================
-- 1. APPEARANCE & FONT
-- =========================================================
config.front_end = "OpenGL"

config.font = wezterm.font_with_fallback({
	{ family = "JetBrains Mono", weight = "Bold" }, -- Primary Font, Bold Weight
	{ family = "Fira Code iScript", weight = "Bold" }, -- Secondary Font, Bold Italic Weight
	{ family = "BlexMono Nerd Font", weight = "Bold" }, -- IBM Plex Mono for Programming Ligatures, Bold Weight
	{ family = "CaskaydiaCove Nerd Font", weight = "Bold" }, -- Cascadia Code for Programming Ligatures, Bold Weight
	{ family = "Apple Color Emoji", scale = 0.8 },
})
config.font_size = 13.5
config.line_height = 1.9
config.color_scheme_dirs = { "colors" }
config.color_scheme = "Homunculus"
config.window_background_opacity = 0.95
config.text_background_opacity = 0.97
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_padding = { left = 10, right = 10, top = 10, bottom = 0 }

-- =========================================================
-- 2. SYSTEM BEHAVIOR
-- =========================================================
config.audible_bell = "Disabled"
config.adjust_window_size_when_changing_font_size = false
config.window_close_confirmation = "AlwaysPrompt"
config.disable_default_key_bindings = true
-- MacOS Specific: Use Option as Meta/Alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- =========================================================
-- 3. KEYBINDINGS
-- =========================================================
config.keys = {
	-- Preserve Ctrl+/ identity through Herdr instead of ambiguous legacy byte 0x1f.
	{ key = "phys:Slash", mods = "CTRL", action = act.SendString("\x1b[47;5u") },
	{ key = "mapped:/", mods = "CTRL", action = act.SendString("\x1b[47;5u") },

	-- F12 is Herdr's internal prefix so Ctrl+B remains available to Neovim.
	{ key = "b", mods = "CMD", action = act.SendKey({ key = "F12" }) },
	{
		key = "t",
		mods = "CMD",
		action = act.Multiple({
			act.SendKey({ key = "F12" }),
			act.SendKey({ key = "c" }),
		}),
	},
	{
		key = "n",
		mods = "CMD|SHIFT",
		action = act.Multiple({
			act.SendKey({ key = "F12" }),
			act.SendKey({ key = "n", mods = "SHIFT" }),
		}),
	},
	{
		key = "w",
		mods = "CMD",
		action = act.Confirmation({
			message = "Close current Herdr tab and stop its processes?",
			action = wezterm.action_callback(function(window, pane)
				window:perform_action(
					act.Multiple({
						act.SendKey({ key = "F12" }),
						act.SendKey({ key = "x", mods = "SHIFT" }),
					}),
					pane
				)
			end),
		}),
	},
	{
		key = "w",
		mods = "CMD|OPT",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = act.Confirmation({
			message = "Close current window and stop all its processes?",
			action = wezterm.action_callback(function(window, pane)
				local actions = {}
				for _ = 1, #window:mux_window():tabs() do
					table.insert(actions, act.CloseCurrentTab({ confirm = false }))
				end
				window:perform_action(act.Multiple(actions), pane)
			end),
		}),
	},

	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	{ key = "f", mods = "CMD", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "h", mods = "CMD", action = act.HideApplication },
	{ key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "n", mods = "CMD", action = act.SpawnWindow },
	{ key = "q", mods = "CMD", action = act.QuitApplication },
	{ key = "r", mods = "CMD", action = act.ReloadConfiguration },
	{ key = "=", mods = "CMD", action = act.IncreaseFontSize },
	{ key = "-", mods = "CMD", action = act.DecreaseFontSize },

	{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
	{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
	{ key = "DownArrow", mods = "CMD", action = act.ScrollToBottom },
	{ key = "UpArrow", mods = "CMD", action = act.ScrollToTop },
}

-- Switch Herdr tabs directly without entering prefix mode.
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CMD",
		action = act.Multiple({
			act.SendKey({ key = "F12" }),
			act.SendKey({ key = tostring(i) }),
		}),
	})
end

-- =========================================================
-- 4. STARTUP
-- =========================================================
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
