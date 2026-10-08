-- Session commands built on the public session APIs.
--
--   /sessions          resume a saved conversation in this directory
--   /sessions delete   delete a saved conversation after a confirmation
--   /new               start a new conversation, keeping the draft text
--   <C-d>              delete a saved conversation after a confirmation
--
-- Switching away from a blank conversation deletes its empty record.

local function program()
    return uji.os.argv[1] or "uji"
end

local function flags()
    local out, argv = {}, uji.os.argv
    local names = { ["--config-dir"] = true, ["--data-dir"] = true, ["--db"] = true }
    for index, value in ipairs(argv) do
        local name, inline = value:match("^(%-%-[%w%-]+)=(.*)$")
        if name and names[name] then
            out[#out + 1] = name
            out[#out + 1] = inline
        elseif names[value] and argv[index + 1] then
            out[#out + 1] = value
            out[#out + 1] = argv[index + 1]
        end
    end
    return out
end

local function restart(args, carry)
    local argv = { program() }
    for _, value in ipairs(args) do
        argv[#argv + 1] = value
    end
    for _, value in ipairs(flags()) do
        argv[#argv + 1] = value
    end
    uji.os.restart({ args = argv, roots = uji.os.roots, carry = carry })
end

local function problem()
    if uji.session.state() ~= "idle" then
        return "uji is working; stop the turn first"
    end
    if #uji.session.queue() > 0 then
        return "queued input is waiting; clear it first"
    end
end

local function carried()
    local out = {}
    local text = uji.input.get()
    if text ~= "" then
        out.draft = text
    end
    if #uji.session.messages() == 0 then
        local id = uji.session.info().id
        if id ~= "" then
            out.blank = id
        end
    end
    if next(out) then
        return uji.json.encode(out)
    end
end

local function here()
    return uji.session.list({ directory = uji.os.cwd() })
end

local function choose(rows, title)
    local items, by_label = {}, {}
    for _, row in ipairs(rows) do
        local label = (row.title ~= "" and row.title or "untitled") .. "  " .. row.id
        items[#items + 1] = label
        by_label[label] = row
    end
    local choice = uji.ui.select({ title = title, items = items })
    return choice and by_label[choice]
end

local function switch()
    local busy = problem()
    if busy then
        uji.notify(busy)
        return
    end
    local rows = here()
    if #rows == 0 then
        uji.notify("no saved conversations in this directory")
        return
    end
    local session = choose(rows, "Sessions")
    if not session then
        return
    end
    if session.id == uji.session.info().id then
        uji.notify("that conversation is already open")
        return
    end
    restart({ "resume", "--id", session.id }, carried())
end

local function delete()
    local busy = problem()
    if busy then
        uji.notify(busy)
        return
    end
    local rows = here()
    if #rows == 0 then
        uji.notify("no saved conversations in this directory")
        return
    end
    local session = choose(rows, "Delete session")
    if not session then
        return
    end
    local title = session.title ~= "" and session.title or "untitled"
    if not uji.ui.confirm({ title = 'Delete "' .. title .. '" and its child history?' }) then
        return
    end
    local removed, err = uji.session.delete(session.id)
    if not removed then
        uji.notify(err)
        return
    end
    uji.notify("deleted " .. title)
end

uji.command.add("sessions", {
    desc = "list, resume, or delete saved conversations",
    handler = function(args)
        if (args or ""):match("^%s*delete%s*$") then
            delete()
        else
            switch()
        end
    end,
})

uji.command.add("new", {
    desc = "start a new conversation",
    handler = function()
        local busy = problem()
        if busy then
            uji.notify(busy)
            return
        end
        restart({ "new" }, carried())
    end,
})

uji.keymap.add("normal", "<C-d>", delete)

-- The carry above holds the ID of a blank conversation this run left behind.
local function discard_blank()
    local ok, carried = pcall(uji.json.decode, uji.os.carry or "null")
    if not ok or type(carried) ~= "table" or type(carried.blank) ~= "string" then
        return
    end
    uji.session.delete(carried.blank)
end

discard_blank()
