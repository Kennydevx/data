local pvpEnforced = false -- Variável global para armazenar o estado do PvP

function onSay(cid, words, param, channelId)
    -- Verifica o comando e o parâmetro
    local command = string.lower(param)
    
    if command == "on" then
        pvpEnforced = true
        doBroadcastMessage("PvP Enforced mode is now ON in Rookgaard.", MESSAGE_STATUS_WARNING)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "PvP Enforced mode has been enabled.")
        
    elseif command == "off" then
        pvpEnforced = false
        doBroadcastMessage("PvP Enforced mode is now OFF in Rookgaard.", MESSAGE_STATUS_WARNING)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "PvP Enforced mode has been disabled.")
        
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /rookenf on|off")
    end

    return true
end

function onThink(interval)
    if pvpEnforced then
        -- Forçar PvP em Rookgaard
        local rookgaard = getTown(12) -- Ajuste o número do ID do município conforme necessário
        
        for _, pid in ipairs(getPlayersInTown(rookgaard)) do
            local player = Player(pid)
            if player then
                -- Cheque se o PvP está ativado para o jogador
                if not player:getPvpEnforced() then
                    player:setPvpEnforced(true)
                end
            end
        end
    end

    return true
end
