local rookgaard = {x = 100, y = 100, z = 7, width = 200, height = 200} -- Defina a área de Rookgaard

local function isInRookgaard(pos)
    return pos.x >= rookgaard.x and pos.x <= rookgaard.x + rookgaard.width and
           pos.y >= rookgaard.y and pos.y <= rookgaard.y + rookgaard.height and
           pos.z == rookgaard.z
end

local function enforcePVP()
    local players = getPlayersOnline()
    for _, pid in ipairs(players) do
        local pos = getCreaturePosition(pid)
        if isInRookgaard(pos) then
            doPlayerSetPVP(pid, true) -- Garante que o PVP está ativado
            doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Você está em uma área de PVP forçada em Rookgaard!")
        end
    end
    return true
end

function onThink(interval)
    return enforcePVP()
end
