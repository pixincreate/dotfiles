local wezterm = require 'wezterm'
local act = wezterm.action

return {
    { key = 'n', mods = 'META',       action = act.SpawnWindow },
    { key = 'w', mods = 'META',       action = act.CloseCurrentTab { confirm = true } },
    { key = 't', mods = 'META',       action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'Tab', mods = 'CTRL',     action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

    { key = '1', mods = 'META',       action = act.ActivateTab(0) },
    { key = '2', mods = 'META',       action = act.ActivateTab(1) },
    { key = '3', mods = 'META',       action = act.ActivateTab(2) },
    { key = '4', mods = 'META',       action = act.ActivateTab(3) },
    { key = '5', mods = 'META',       action = act.ActivateTab(4) },
    { key = '6', mods = 'META',       action = act.ActivateTab(5) },
    { key = '7', mods = 'META',       action = act.ActivateTab(6) },
    { key = '8', mods = 'META',       action = act.ActivateTab(7) },
    { key = '9', mods = 'META',       action = act.ActivateTab(8) },

    { key = '\\', mods = 'META',      action = act.SplitPane { direction = 'Right', size = { Percent = 50 } } },
    { key = '-', mods = 'META',       action = act.SplitPane { direction = 'Down', size = { Percent = 50 } } },

    { key = 'h', mods = 'META|SHIFT', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'META|SHIFT', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'META|SHIFT', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'META|SHIFT', action = act.ActivatePaneDirection 'Right' },

    { key = 'z', mods = 'META',       action = act.TogglePaneZoomState },

    { key = 'k', mods = 'META',       action = act.Multiple {
        act.ClearScrollback 'ScrollbackAndViewport',
        act.SendKey { key = 'L', mods = 'CTRL' },
    }},

    { key = '=', mods = 'META',       action = act.IncreaseFontSize },
    { key = '-', mods = 'META|SHIFT', action = act.DecreaseFontSize },
    { key = '0', mods = 'META',       action = act.ResetFontSize },

    { key = 'UpArrow', mods = 'META',    action = act.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'META',  action = act.ScrollToPrompt(1) },

    { key = 'p', mods = 'CTRL|SHIFT', action = act.ScrollToPrompt(-1) },
    { key = 'n', mods = 'CTRL|SHIFT', action = act.ScrollToPrompt(1) },

    { key = 'p', mods = 'META|SHIFT', action = act.ActivateCommandPalette },

    { key = 'r', mods = 'CTRL|META',  action = act.ReloadConfiguration },

    { key = 'f', mods = 'META',       action = act.ToggleFullScreen },

    { key = ';', mods = 'CTRL|META',  action = act.ActivateCopyMode },

    { key = 'f', mods = 'META|SHIFT', action = act.QuickSelect },

    { key = 'i', mods = 'META|SHIFT', action = act.PromptInputLine {
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
