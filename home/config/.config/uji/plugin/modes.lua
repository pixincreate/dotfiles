-- Permission modes for tool calls.
--
--   <S-Tab>       cycle ask, auto, and plan
--   /mode <name>  set one directly
--
-- auto allows write_file, edit_file, and run_command before the
-- planmode and readonly hooks run; plan denies them.

local ito = require("ito")

local MODES = { "ask", "auto", "plan" }
local WRITE = { write_file = true, edit_file = true, run_command = true }

local mode = ito.state("ask")

local function report()
    uji.notify("permission mode: " .. mode.value)
end

local function set(name)
    for _, known in ipairs(MODES) do
        if known == name then
            mode.value = known
            report()
            return
        end
    end
    uji.notify("unknown mode: " .. name)
end

local function cycle()
    for index, known in ipairs(MODES) do
        if known == mode.value then
            set(MODES[index % #MODES + 1])
            return
        end
    end
end

uji.on("before_tool", function(call)
    if not WRITE[call.name] then
        return nil
    end
    if mode.value == "auto" then
        return { allow = true }
    end
    if mode.value == "plan" then
        return { deny = "plan mode: " .. call.name .. " is blocked" }
    end
end, { name = "permission-modes", priority = 5 })

uji.ui.toolbar({
    ito.ToolbarItem(ito.ToolbarPlacement.bottom_bar, function()
        if mode.value == "ask" then
            return false
        end
        return ito.Text(mode.value):foreground(mode.value == "auto" and ito.Color.yellow or ito.Color.red)
    end),
})

uji.keymap.add("normal", "<S-Tab>", cycle)

uji.command.add("mode", {
    desc = "show or set the permission mode (ask, auto, plan)",
    handler = function(args)
        local name = (args or ""):match("^%s*(%a+)%s*$")
        if name then
            set(name)
        else
            report()
        end
    end,
})
