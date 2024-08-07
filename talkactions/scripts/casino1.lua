-- Casino Event Configuration
local cfg = {
    startCommand = "/startcasino",  -- Command to start the event
    endCommand = "/endcasino",      -- Command to end the event
    betCommand = "!bet",            -- Command to place a bet
    betAmount = 1000,               -- Amount of gold required to place a bet
    maxNumber = 10,                -- Maximum number for betting
    bettingTime = 2 * 60 * 1000,    -- Time allowed for betting (5 minutes)
    checkInterval = 30 * 1000,      -- Interval to check for winners (30 seconds)
    notificationInterval = 60 * 1000, -- Interval to notify players of remaining time (1 minute)
}

local bets = {}                    -- Table to store player bets
local eventStarted = false         -- Flag to check if the event is running
local winningNumber = 0            -- Winning number
local totalPot = 0                 -- Total accumulated prize pot
local lastCheckTime = 0            -- Last time the event was checked for winners
local eventHistory = {}            -- Table to store the history of events

-- Function to handle commands
function onSay(cid, words, param, channel)
    print("onSay called with words: " .. words .. " and param: " .. param)
    print("Event started status: " .. tostring(eventStarted))

    -- Ensure no empty parameters are processed
    if param == nil then
        param = ''
    end

    -- Start Casino Event
    if words == cfg.startCommand then
        print("Start command detected")
        if eventStarted then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "O evento de cassino já está em andamento.")
            return true
        end

        eventStarted = true
        bets = {}
        totalPot = 0
        winningNumber = math.random(1, cfg.maxNumber)
        lastCheckTime = os.time()

        -- Announce the start of the event
        broadcastMessage("O evento de cassino começou! Faça suas apostas em um número entre 1 e " .. cfg.maxNumber .. " dentro de " .. (cfg.bettingTime / 60000) .. " minutos para ganhar o pote acumulado. Use o comando '" .. cfg.betCommand .. " <número>' para fazer sua aposta.", MESSAGE_EVENT_ADVANCE)
        print("> Broadcasted message: \"O evento de cassino começou! Faça suas apostas em um número entre 1 e " .. cfg.maxNumber .. " dentro de " .. (cfg.bettingTime / 60000) .. " minutos para ganhar o pote acumulado. Use o comando '" .. cfg.betCommand .. " <número>' para fazer sua aposta.\".")

        -- Schedule event end
        addEvent(endCasinoEvent, cfg.bettingTime)

        -- Start the checking loop
        addEvent(checkForWinners, cfg.checkInterval, cfg.checkInterval)

        -- Start the notification loop
        addEvent(notifyPlayers, cfg.notificationInterval, cfg.bettingTime)

        return true

    -- End Casino Event
    elseif words == cfg.endCommand then
        print("End command detected")
        if not eventStarted then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nenhum evento de cassino está em andamento.")
            return true
        end

        endCasinoEvent()

        return true

    -- Place Bet
    elseif words == cfg.betCommand then
        print("Bet command detected")
        if param == '' then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Por favor, especifique um número para apostar.")
            return true
        end

        return processBet(cid, param)
    end

    return false
end

-- Function to start the casino event
function startCasinoEvent(cid, words, param, channel)
    print("Start command detected")
    if eventStarted then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "O evento de cassino já está em andamento.")
        return true
    end

    eventStarted = true
    bets = {}
    totalPot = 0
    winningNumber = math.random(1, cfg.maxNumber)
    lastCheckTime = os.time()

    -- Announce the start of the event
    broadcastMessage("O evento de cassino começou! Faça suas apostas em um número entre 1 e " .. cfg.maxNumber .. " dentro de " .. (cfg.bettingTime / 60000) .. " minutos para ganhar o pote acumulado. Use o comando '" .. cfg.betCommand .. " <número>' para fazer sua aposta.", MESSAGE_EVENT_ADVANCE)
    print("> Broadcasted message: \"O evento de cassino começou! Faça suas apostas em um número entre 1 e " .. cfg.maxNumber .. " dentro de " .. (cfg.bettingTime / 60000) .. " minutos para ganhar o pote acumulado. Use o comando '" .. cfg.betCommand .. " <número>' para fazer sua aposta.\".")

    -- Schedule event end
    addEvent(endCasinoEvent, cfg.bettingTime)

    -- Start the checking loop
    addEvent(checkForWinners, cfg.checkInterval, cfg.checkInterval)

    -- Start the notification loop
    addEvent(notifyPlayers, cfg.notificationInterval, cfg.bettingTime)

    return true
end


-- Function to process player bets
function processBet(cid, param)
    print("Processing bet with param: " .. param)
    if not eventStarted then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nenhum evento de cassino está em andamento.")
        return true
    end

    local betNumber = tonumber(param)
    if not betNumber or betNumber < 1 or betNumber > cfg.maxNumber then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Aposta inválida. Escolha um número entre 1 e " .. cfg.maxNumber .. ".")
        print("Invalid bet number: " .. tostring(betNumber))
        return true
    end

    local playerMoney = getPlayerMoney(cid)
    print("Player money: " .. playerMoney)
    if playerMoney < cfg.betAmount then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem dinheiro suficiente para fazer uma aposta. O valor da aposta é " .. cfg.betAmount .. " gold.")
        print("Not enough money. Player has: " .. playerMoney .. ", Bet amount: " .. cfg.betAmount)
        return true
    end

    -- Deduct bet amount and add to the pot
    doPlayerRemoveMoney(cid, cfg.betAmount)
    totalPot = totalPot + cfg.betAmount
    print("Total pot after bet: " .. totalPot)

    -- Store player's bet
    bets[cid] = betNumber
    print("Bet stored for player " .. getPlayerName(cid) .. ": " .. betNumber)

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você apostou " .. cfg.betAmount .. " gold no número " .. betNumber .. ".")
    return true
end


-- Função para terminar o evento de cassino
function endCasinoEvent()
    print("End command detected")
    if not eventStarted then
        print("Nenhum evento de cassino está em andamento.")
        return
    end

    eventStarted = false
    print("Evento de cassino terminou")

    -- Anunciar o fim do evento
    broadcastMessage("O evento de cassino terminou! O número vencedor é " .. winningNumber .. ".", MESSAGE_EVENT_ADVANCE)

    -- Encontrar vencedores
    local winners = {}
    for cid, number in pairs(bets) do
        print("Checking bet: Player " .. getPlayerName(cid) .. " bet on " .. number)
        if number == winningNumber then
            print("Player " .. getPlayerName(cid) .. " won with number " .. number)
            table.insert(winners, getPlayerName(cid))
        end
    end

    -- Distribuir prêmios
    if #winners > 0 then
        local prizePerWinner = totalPot / #winners
        for _, name in ipairs(winners) do
            local cid = getPlayerByName(name)
            doPlayerAddMoney(cid, prizePerWinner)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Parabéns! Você ganhou " .. prizePerWinner .. " gold no evento de cassino.")
            print("Prize added to player: " .. name)
        end
        broadcastMessage("Os vencedores são: " .. table.concat(winners, ", ") .. ". Cada vencedor recebe " .. prizePerWinner .. " gold.", MESSAGE_EVENT_ADVANCE)
    else
        broadcastMessage("Nenhum jogador acertou o número vencedor. O pote foi perdido.", MESSAGE_EVENT_ADVANCE)
        print("No winners")
    end

    -- Armazenar resultado do evento na história
    table.insert(eventHistory, {winningNumber = winningNumber, totalPot = totalPot, winners = winners})

    -- Resetar variáveis do evento
    bets = {}
    totalPot = 0
    winningNumber = 0
end



-- Function to repeatedly check for winners and extend the event if necessary
function checkForWinners()
    if not eventStarted then
        return
    end

    if os.time() - lastCheckTime >= cfg.checkInterval / 1000 then
        lastCheckTime = os.time()

        -- Check if there's a winner
        local hasWinner = false
        for cid, number in pairs(bets) do
            if number == winningNumber then
                hasWinner = true
                break
            end
        end

        if not hasWinner then
            broadcastMessage("Nenhum vencedor ainda. O evento é estendido por mais tempo. Continue fazendo suas apostas!", MESSAGE_EVENT_ADVANCE)
            -- Extend the event by re-scheduling
            addEvent(checkForWinners, cfg.checkInterval, cfg.checkInterval)
        end
    end
end

-- Function to notify players of remaining time
function notifyPlayers(timeLeft)
    if not eventStarted then
        return
    end

    timeLeft = timeLeft - cfg.notificationInterval
    if timeLeft > 0 then
        broadcastMessage("Faltam " .. (timeLeft / 60000) .. " minutos para o fim do evento de cassino. Faça sua aposta agora!", MESSAGE_EVENT_ADVANCE)
        addEvent(notifyPlayers, cfg.notificationInterval, timeLeft)
    end
end

-- Command to view event history
function showEventHistory(cid)
    if #eventHistory == 0 then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nenhum evento de cassino foi realizado ainda.")
        return true
    end

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Histórico de Eventos de Cassino:")
    for i, event in ipairs(eventHistory) do
        local winnerNames = table.concat(event.winners, ", ")
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Evento " .. i .. ": Número Vencedor: " .. event.winningNumber .. ", Pote: " .. event.totalPot .. " gold, Vencedores: " .. (winnerNames ~= "" and winnerNames or "Nenhum"))
    end

    return true
end

-- Register the commands
function onSay(cid, words, param, channel)
    print("onSay called with words: " .. words .. " and param: " .. param)
    if words == cfg.startCommand then
        return startCasinoEvent(cid, words, param, channel)
    elseif words == cfg.endCommand then
        return endCasinoEvent()
    elseif words == cfg.betCommand then
        return processBet(cid, param)
    elseif words == "/showhistory" then
        return showEventHistory(cid)
    else
        return false
    end
end
