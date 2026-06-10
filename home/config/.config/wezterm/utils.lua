local wezterm = require 'wezterm'

local function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    return tab_info.active_pane.title
end

local symbol_map = {
    right = "▐",
    left = "▌",
}

--- Join two tables
--- @param left table|nil
--- @param right table|nil
--- @return table
local function join(left, right)
    if (left == nil and right == nil) then
        return {}
    end
    if (left == nil and right ~= nil) then
        return right
    end
    if (right == nil and left ~= nil) then
        return left
    end

    local result = {}
    for k, v in pairs(left) do result[k] = v end
    for k, v in pairs(right) do result[k] = v end
    return result
end

local ok, secrets = pcall(require, "secrets")
if not ok then
    secrets = nil
end


return {
    tab_title = tab_title,
    symbol_map = symbol_map,
    join = join,
    secrets = secrets,
}
