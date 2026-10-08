require("uji.builtin.defaults")

local ito = require("ito")

local function startup_screen(screen)
    local placement = ito.ToolbarPlacement
    local columns = uji.ui.size() or 120
    local width = math.min(80, math.max(columns - 12, 24))
    local empty = #uji.session.messages() == 0
    local composer = ito.VStack({
        screen.modals(),
        screen.composer():border(ito.theme().borders.plain, { edges = ito.Edges.horizontal }),
        ito.ToolbarItems(placement.bottom_bar),
    })
    if empty then
        composer = ito.HStack({ ito.Spacer(), composer:width(width), ito.Spacer() })
    end
    local rows = {
        ito.HStack({
            ito.ToolbarItems(placement.top_bar_leading, ito.HStack),
            ito.Spacer(),
            ito.ToolbarItems(placement.top_bar_trailing, ito.HStack),
        }),
        empty and ito.Spacer() or screen.transcript():grow(),
        screen.activity():padding({ vertical = 1 }),
        ito.ToolbarItems(placement.keyboard),
        composer,
    }
    if empty then
        rows[#rows + 1] = ito.Spacer()
    end
    return ito.VStack(rows)
end

uji.ui.configure({
    theme = require("uji.themes.default")({
        colors = { accent = ito.Color.yellow },
        views = { [uji.ui.Screen] = startup_screen },
    }),
})

uji.pack.add({ { "uji-labs/uji-plugins", commit = "3fbfd7081cbdfc6d551f2eada92f36279e8e1e3d" } })

require("skills").setup({
    -- The trailing slash lets discovery follow the symlinked skills root.
    roots = { "~/.agents/skills/" },
})

require("planmode").setup({})
require("readonly").setup({ "~/.agents/skills" })
require("subagent").setup({})
require("telescope").setup({})
require("websearch").setup({})

require("mcp").setup({ servers = {
    deepwiki = { url = "https://mcp.deepwiki.com/mcp" },
    grep = { url = "https://mcp.grep.app" },
    kite = { url = "https://mcp.kite.trade/mcp" },
    context7 = { url = "https://mcp.context7.com/mcp" },
    firecrawl = { url = "https://mcp.firecrawl.dev/v2/mcp" },
} })
