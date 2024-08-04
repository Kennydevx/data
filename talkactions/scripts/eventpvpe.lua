function onSay(player, words, param)
    print("Evento PVP comando recebido!") -- Verifique se o comando é recebido

    if not player then
        print("Player inválido") -- Verifique se o player é válido
        return false
    end

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Evento PVP iniciado!")

    -- Coloque aqui a lógica do seu evento PVP

    return true
end
