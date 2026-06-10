local wezterm = require 'wezterm'
local act = wezterm.action

-- macOS uses CMD (⌘) instead of META (Alt) for primary modifiers
return {
    { key = 'n', mods = 'CMD',        action = act.SpawnWindow },
    { key = 'w', mods = 'CMD',        action = act.CloseCurrentTab { confirm = true } },
    { key = 't', mods = 'CMD',        action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'Tab', mods = 'CTRL',     action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

    { key = '1', mods = 'CMD',        action = act.ActivateTab(0) },
    { key = '2', mods = 'CMD',        action = act.ActivateTab(1) },
    { key = '3', mods = 'CMD',        action = act.ActivateTab(2) },
    { key = '4', mods = 'CMD',        action = act.ActivateTab(3) },
    { key = '5', mods = 'CMD',        action = act.ActivateTab(4) },
    { key = '6', mods = 'CMD',        action = act.ActivateTab(5) },
    { key = '7', mods = 'CMD',        action = act.ActivateTab(6) },
    { key = '8', mods = 'CMD',        action = act.ActivateTab(7) },
    { key = '9', mods = 'CMD',        action = act.ActivateTab(8) },

    { key = '\\', mods = 'CMD',       action = act.SplitPane { direction = 'Right', size = { Percent = 50 } } },
    { key = '-', mods = 'CMD',        action = act.SplitPane { direction = 'Down', size = { Percent = 50 } } },

    { key = 'h', mods = 'CMD|SHIFT',  action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'CMD|SHIFT',  action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'CMD|SHIFT',  action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'CMD|SHIFT',  action = act.ActivatePaneDirection 'Right' },

    { key = 'z', mods = 'CMD',        action = act.TogglePaneZoomState },

    { key = 'k', mods = 'CMD',        action = act.Multiple {
        act.ClearScrollback 'ScrollbackAndViewport',
        act.SendKey { key = 'L', mods = 'CTRL' },
    }},

    { key = '=', mods = 'CMD',        action = act.IncreaseFontSize },
    { key = '-', mods = 'CMD|SHIFT',  action = act.DecreaseFontSize },
    { key = '0', mods = 'CMD',        action = act.ResetFontSize },

    { key = 'UpArrow', mods = 'CMD',   action = act.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'CMD', action = act.ScrollToPrompt(1) },

    { key = 'p', mods = 'CTRL|SHIFT', action = act.ScrollToPrompt(-1) },
    { key = 'n', mods = 'CTRL|SHIFT', action = act.ScrollToPrompt(1) },

    { key = 'p', mods = 'CMD|SHIFT',  action = act.ActivateCommandPalette },

    { key = 'r', mods = 'CTRL|CMD',   action = act.ReloadConfiguration },

    { key = 'f', mods = 'CMD',        action = act.ToggleFullScreen },

    { key = ';', mods = 'CTRL|CMD',   action = act.ActivateCopyMode },

    { key = 'f', mods = 'CMD|SHIFT',  action = act.QuickSelect },

    { key = 'i', mods = 'CMD|SHIFT',  action = act.PromptInputLine {
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, pane, line)
            if line then
                window:active_tab():set_title(line)
            end
        end),
    }},

    { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },
}
