-- Configurações do evento
local cfg = {
    startCommand = "!startcasino",  -- Comando para iniciar o evento
    endCommand = "!endcasino",      -- Comando para finalizar o evento
    betAmount = 1000,              -- Valor da aposta
    maxNumber = 500,               -- Número máximo que pode ser apostado
    bettingTime = 5 * 60 * 1000,    -- Tempo de apostas (5 minutos)
}

local bets = {}                  -- Tabela para armazenar apostas dos jogadores
local eventStarted = false       -- Flag para verificar se o evento foi iniciado
local winningNumber = 0          -- Número vencedor
local totalPot = 0               -- Valor total acumulado no pote

-- Função para iniciar o evento
function onSay(cid, words, param, channel)
    if words == cfg.startCommand then
        if eventStarted then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "O evento de cassino já está em andamento.")
            return true
        end

        eventStarted = true
        bets = {}
        totalPot = 0
        winningNumber = math.random(1, cfg.maxNumber)

        -- Mensagem de início do evento
        broadcastMessage("O evento de cassino começou! Aposte um número de 1 a " .. cfg.maxNumber .. " por " .. (cfg.bettingTime / 60000) .. " minutos para ter a chance de ganhar o pote acumulado. Use o comando '!bet <número>' para apostar.", MESSAGE_EVENT_ADVANCE)

        -- Encerra o evento após o tempo de apostas
        addEvent(endCasinoEvent, cfg.bettingTime)

        return true
    elseif words == cfg.endCommand then
        if not eventStarted then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nenhum evento de cassino está em andamento.")
            return true
        end

        endCasinoEvent()

        return true
    end

    return false
end

-- Função para processar apostas dos jogadores
function onSay(cid, words, param, channel)
    if not eventStarted then
        return false
    end

    if words == "!bet" and param then
        local betNumber = tonumber(param)
        if not betNumber or betNumber < 1 or betNumber > cfg.maxNumber then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Aposta inválida. Escolha um número entre 1 e " .. cfg.maxNumber .. ".")
            return true
        end

        local playerMoney = getPlayerMoney(cid)
        if playerMoney < cfg.betAmount then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem dinheiro suficiente para apostar. O valor da aposta é " .. cfg.betAmount .. " gold.")
            return true
        end

        -- Subtrai o valor da aposta e adiciona ao pote
        doPlayerRemoveMoney(cid, cfg.betAmount)
        totalPot = totalPot + cfg.betAmount

        -- Armazena a aposta do jogador
        bets[cid] = betNumber

        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você apostou " .. cfg.betAmount .. " gold no número " .. betNumber .. ".")
        return true
    end

    return false
end

-- Função para encerrar o evento de cassino
function endCasinoEvent()
    if not eventStarted then
        return
    end

    eventStarted = false

    -- Mensagem de encerramento do evento
    broadcastMessage("O evento de cassino acabou! O número vencedor é " .. winningNumber .. ".", MESSAGE_EVENT_ADVANCE)

    -- Encontra vencedores e distribui o prêmio
    local winners = {}
    for cid, number in pairs(bets) do
        if number == winningNumber then
            table.insert(winners, cid)
        end
    end

    if #winners > 0 then
        local prizePerWinner = totalPot / #winners
        for _, cid in ipairs(winners) do
            doPlayerAddMoney(cid, prizePerWinner)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Parabéns! Você ganhou " .. prizePerWinner .. " gold no evento de cassino.")
        end
        broadcastMessage("Os vencedores foram: " .. table.concat(winners, ", ") .. ". Cada um ganhou " .. prizePerWinner .. " gold.", MESSAGE_EVENT_ADVANCE)
    else
        broadcastMessage("Nenhum jogador apostou no número vencedor. O pote foi perdido.", MESSAGE_EVENT_ADVANCE)
    end

    bets = {}
    totalPot = 0
    winningNumber = 0
end
