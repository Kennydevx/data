function onSay(player, words, param)
    -- Verificar se o comando foi recebido corretamente
    print("Comando /eventpvpe recebido") -- Mensagem de depuração no servidor

    if not player then
        print("Player inválido") -- Mensagem de depuração no servidor
        return false
    end

    -- Mensagem ao jogador
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Evento PVP iniciado!")

    -- Definir PVP para a cidade de Thais
    local function setPvpZone(position, radius)
        for x = position.x - radius, position.x + radius do
            for y = position.y - radius, position.y + radius do
                local pos = Position(x, y, position.z)
                local tile = Tile(pos)
                if tile then
                    -- Adicione aqui a lógica para definir a área como PVP
                    -- Isso é apenas um exemplo e pode não ser aplicável diretamente
                    tile:setPvpZone()
                end
            end
        end
    end

    -- Coordenadas e raio para a área de Thais (exemplo)
    local thaisPosition = Position(32384, 32260, 7)
    local radius = 10 -- Ajuste o raio conforme necessário

    setPvpZone(thaisPosition, radius)

    -- Mensagem de sucesso
    print("PvP enforced na cidade de Thais") -- Mensagem de depuração no servidor

    return true
end