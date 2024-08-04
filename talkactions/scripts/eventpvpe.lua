local thaisPositions = {
    {x = 32368, y = 32197, z = 7, radius = 25}
}

local function setPvPEnforced(pos, radius, enforced)
    for x = pos.x - radius, pos.x + radius do
        for y = pos.y - radius, pos.y + radius do
            local tile = Tile(Position(x, y, pos.z))
            if tile then
                for _, creature in ipairs(tile:getCreatures()) do
                    creature:setPvpTile(enforced)
                end
            end
        end
    end
end

function onSay(player, words, param)
    local enforced = param == "on"
    for _, pos in ipairs(thaisPositions) do
        setPvPEnforced(Position(pos.x, pos.y, pos.z), pos.radius, enforced)
    end
    if enforced then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Thais agora está com PvP Enforced!")
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "PvP Enforced em Thais foi desativado.")
    end
    return true
end
