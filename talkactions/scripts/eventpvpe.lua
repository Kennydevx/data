function onSay(player, words, param)
    print("Comando /eventpvpe recebido") -- Mensagem de depuração no servidor

    if not player then
        print("Player inválido") -- Mensagem de depuração no servidor
        return false
    end

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Evento PVP iniciado!")

    -- Coloque aqui a lógica do seu evento PVP
    -- Exemplo de mudança temporária de PVP para a cidade de Thais:
    for x = 32369, 32399 do
        for y = 32239, 32269 do
            local tile = Tile(Position(x, y, 7))
            if tile then
                tile:setPvPZone()
            end
        end
    end

    print("Comando /eventpvpe processado com sucesso") -- Mensagem de depuração no servidor

    return true
end
