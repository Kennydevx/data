function onSay(player, words, param)
    -- Verifique se o player é válido
    if not player then
        return false
    end

    -- Enviar uma mensagem ao player
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Evento PVP iniciado!")

    -- Coloque aqui a lógica do seu evento PVP
    -- Por exemplo, você pode teleportar jogadores para uma área específica, configurar regras, etc.

    return true
end
