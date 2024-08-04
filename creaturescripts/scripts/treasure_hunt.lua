local TREASURE_ITEM_ID = 1234
local TREASURE_STORAGE = 1234
local TREASURE_POSITION = Position(100, 100, 7) -- Substitua com a posição desejada

local function startTreasureHunt()
    local treasurePos = Position(math.random(100, 200), math.random(100, 200), 7) -- Posição aleatória
    local treasureItem = Game.createItem(TREASURE_ITEM_ID, 1, treasurePos)
    if treasureItem then
        setGlobalStorageValue(TREASURE_STORAGE, treasurePos:getId()) -- Armazena a posição do tesouro
        local players = Game.getPlayers()
        for _, player in pairs(players) do
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "A new treasure has been hidden somewhere in the world! Find it for a reward!")
        end
    end
end

local function onUse(cid, item, fromPosition, itemEx, toPosition)
    local treasurePos = Position(getGlobalStorageValue(TREASURE_STORAGE))
    if treasurePos and fromPosition == treasurePos then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You have found the treasure and won 1000 gold!")
        doPlayerAddMoney(cid, 1000)
        setGlobalStorageValue(TREASURE_STORAGE, -1) -- Desativa o evento
        return true
    end
    return false
end

function onThink(interval)
    local isActive = getGlobalStorageValue(TREASURE_STORAGE) ~= -1
    if not isActive then
        return true
    end

    -- Lógica para verificar se o tesouro foi encontrado
    local treasurePos = Position(getGlobalStorageValue(TREASURE_STORAGE))
    if not treasurePos then
        startTreasureHunt()
    end

    return true
end
