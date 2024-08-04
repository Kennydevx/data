local PVP_STORAGE = 5678
local PVP_AREA = { 
    from = Position(100, 100, 7), -- Posições da área de PvP
    to = Position(120, 120, 7) 
}

local function isInPvpArea(position)
    return position.x >= PVP_AREA.from.x and position.x <= PVP_AREA.to.x and
           position.y >= PVP_AREA.from.y and position.y <= PVP_AREA.to.y and
           position.z == PVP_AREA.from.z
end

local function startPvpChallenge()
    setGlobalStorageValue(PVP_STORAGE, 1)
    local players = Game.getPlayers()
    for _, player in pairs(players) do
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "The PvP challenge has started! Fight in the designated area for rewards!")
    end
end

local function onKill(cid, target, damage, flags)
    local isActive = getGlobalStorageValue(PVP_STORAGE) == 1
    if not isActive then
        return true
    end

    if isInPvpArea(getCreaturePosition(cid)) and getCreatureType(target) == CREATURETYPE_PLAYER then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You won the PvP challenge and received 500 gold!")
        doPlayerAddMoney(cid, 500)
        return true
    end

    return false
end

function onSay(cid, words, param, channelId)
    if words == "/startpvp" then
        startPvpChallenge()
        return true
    end
    return false
end
