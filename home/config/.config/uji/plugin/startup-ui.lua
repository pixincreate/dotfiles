-- Startup presentation for the declarative UI.
--
--   the UJI logo shows while the conversation is empty
--   the bottom bar shows the directory, model, effort, and context

local ito = require("ito")
local statusline = require("statusline")

local LOGO = {
    "            ████",
    "████        ████",
    "████",
    "████        ████",
    "████        ████",
    "████████████████",
    "████████████████",
}

local Logo = ito.view(function()
    if #uji.session.messages() > 0 then
        return false
    end
    return ito.Text(table.concat(LOGO, "\n")):foreground(ito.theme().colors.accent):align(ito.Alignment.center)
end)

uji.ui.toolbar({
    ito.ToolbarItem(ito.ToolbarPlacement.keyboard, Logo),
    ito.ToolbarItem(ito.ToolbarPlacement.bottom_bar, function()
        return statusline.Bar({
            statusline.Cwd(),
            statusline.Model(),
            statusline.Effort(),
            statusline.Context(),
        })
    end),
})
