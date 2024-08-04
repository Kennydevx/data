local function giveDailyReward()
    local players = getPlayersOnline()
    for _, pid in ipairs(players) do
        local lastLogin = getPlayerLastLogin(pid)
        local currentDate = os.date("%Y-%m-%d")

        if lastLogin ~= currentDate then
            local reward = math.random(1000, 5000) -- Recompensa aleatória
            doPlayerAddMoney(pid, reward)
            doPlayerSendTextMessage(pid, MESSAGE_STATUS_CONSOLE_BLUE, "Você recebeu uma recompensa diária de " .. reward .. " ouro por logar no jogo!")
            db.executeQuery("UPDATE `players` SET `last_login` = '" .. currentDate .. "' WHERE `id` = " .. getPlayerGUID(pid))
        end
    end
    return true
end

function onThink(interval)
    return giveDailyReward()
end
