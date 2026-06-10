-- Catppuccin Mocha palette for WezTerm
-- Ported from Catppuccin Mocha standard color palette
-- Reference: https://catppuccin.com/palette
local colors = {
    foreground = "#cdd6f4",
    background = "#1e1e2e",
    cursor_bg = "#f5e0dc",
    cursor_fg = "#1e1e2e",
    cursor_border = "#f5e0dc",
    selection_bg = "#45475a",
    selection_fg = "#cdd6f4",

    ansi = {
        "#45475a", -- black       -- Surface 1
        "#f38ba8", -- red         -- Maroon
        "#a6e3a1", -- green       -- Green
        "#f9e2af", -- yellow      -- Yellow
        "#89b4fa", -- blue        -- Blue
        "#cba6f7", -- magenta     -- Mauve
        "#94e2d5", -- cyan        -- Teal
        "#bac2de", -- white       -- Subtext 1
    },

    brights = {
        "#585b70", -- bright black   -- Surface 2
        "#f38ba8", -- bright red     -- Red
        "#a6e3a1", -- bright green   -- Green
        "#f9e2af", -- bright yellow  -- Yellow
        "#89b4fa", -- bright blue    -- Blue
        "#cba6f7", -- bright magenta -- Mauve
        "#94e2d5", -- bright cyan    -- Teal
        "#a6adc8", -- bright white   -- Subtext 0
    },

    tab_bar = {
        background = "#1e1e2e",
        active_tab = {
            bg_color = "#313244",
            fg_color = "#cdd6f4",
        },
    },
}

return colors
