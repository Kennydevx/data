local treasurePositions = {
    {x = 100, y = 100, z = 7}, -- Coordenadas para o tesouro 1
    {x = 200, y = 200, z = 7}, -- Coordenadas para o tesouro 2
    -- Adicione mais coordenadas conforme necessário
}

local function generateTreasureLocation()
    local index = math.random(1, #treasurePositions)
    return treasurePositions[index]
end

local function onKill(cid, target)
    if isPlayer(target) then
        local pos = generateTreasureLocation()
        doSendMagicEffect(pos, CONST_ME_GIFT_WRAPS) -- Adicione uma animação para o tesouro
        doSendMagicEffect(getCreaturePosition(cid), CONST_ME_HOLYAREA)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você encontrou um tesouro escondido! Procure na posição " .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. " para reivindicar seu prêmio.")
        -- Adicione aqui a lógica para o prêmio real
    end
    return true
end

function onKill(cid, target)
    return onKill(cid, target)
end
