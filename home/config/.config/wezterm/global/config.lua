local wezterm = require "wezterm"
local colors = require "themes.colors"

return function(config)
    config.font = wezterm.font_with_fallback {
        { family = "JetBrains Mono", weight = "Regular" },
        { family = "Iosevka",        weight = "Medium" },
        { family = "CommitMono",     weight = "Medium" },
        { family = "Geist Mono",     weight = "Medium" },
    }

    config.window_decorations = "RESIZE"
    config.default_cursor_style = "SteadyBar"
    config.window_background_opacity = 0.88
    config.colors = colors
    config.hide_mouse_cursor_when_typing = true

    config.window_padding = {
        top = 4,
        left = 4,
        bottom = 4,
        right = 4,
    }
    config.scroll_to_bottom_on_input = true
    config.scrollback_lines = 350000

    config.enable_kitty_keyboard = false
    config.enable_csi_u_key_encoding = true
    config.selection_word_boundary = " \t\n{}[]()\"'`,;:@│┃"

    config.tab_bar_at_bottom = false
    config.enable_tab_bar = true
    config.use_fancy_tab_bar = false
    config.show_new_tab_button_in_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = false

    config.max_fps = 75

    config.command_palette_bg_color = colors.background
    config.command_palette_fg_color = colors.foreground
    config.command_palette_font_size = 14.0
    config.command_palette_rows = 10

    config.audible_bell = "Disabled"

    config.quick_select_patterns = {
        "[\\w./]+:\\d+:\\d+", -- filename with line:col
        "[\\w.-]+@[\\w.-]+",  -- email addresses
    }

    config.hyperlink_rules = wezterm.default_hyperlink_rules()

    return config
end
