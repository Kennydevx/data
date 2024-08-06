-- Casino Event Configuration
local cfg = {
    startCommand = "/startcasino",  -- Command to start the event
    endCommand = "/endcasino",      -- Command to end the event
    betCommand = "!bet",            -- Command to place a bet
    historyCommand = "/casinolog",  -- Command to view event history
    betAmount = 1000,               -- Amount of gold required to place a bet
    maxNumber = 500,                -- Maximum number for betting
    bettingTime = 5 * 60 * 1000,    -- Time allowed for betting (5 minutes)
    checkInterval = 30 * 1000,      -- Interval to check for winners (30 seconds)
    notificationInterval = 60 * 1000 -- Interval to notify players of remaining time (1 minute)
}

local bets = {}                    -- Table to store player bets
local eventStarted = false         -- Flag to check if the event is running
local winningNumber = 0            -- Winning number
local totalPot = 0                 -- Total accumulated prize pot
local eventHistory = {}            -- Table to store the history of events

-- Function to handle commands
function onSay(cid, words, param, channel)
    if words == cfg.startCommand then
        return startCasinoEvent(cid)
    elseif words == cfg.endCommand then
        return endCasinoEvent(cid)
    elseif words == cfg.betCommand then
        return processBet(cid, param)
    elseif words == cfg.historyCommand then
        return showEventHistory(cid)
    end
    return false
end

-- Function to start the casino event
function startCasinoEvent(cid)
    if eventStarted then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "O evento de cassino já está em andamento.")
        return true
    end

    eventStarted = true
    bets = {}
    totalPot = 0
    winningNumber = math.random(1, cfg.maxNumber)

    broadcastMessage("O evento de cassino começou! Faça suas apostas em um número entre 1 e " .. cfg.maxNumber .. " dentro de " .. (cfg.bettingTime / 60000) .. " minutos para ganhar o pote acumulado. Use o comando '" .. cfg.betCommand .. " <número>' para fazer sua aposta.", MESSAGE_EVENT_ADVANCE)

    addEvent(endCasinoEvent, cfg.bettingTime)
    addEvent(checkForWinners, cfg.checkInterval)
    addEvent(notifyPlayers, cfg.notificationInterval, cfg.bettingTime)

    return true
end

-- Function to end the casino event
function endCasinoEvent()
    if not eventStarted then
        return true
    end

    eventStarted = false

    broadcastMessage("O evento de cassino terminou! O número vencedor é " .. winningNumber .. ".", MESSAGE_EVENT_ADVANCE)

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
        broadcastMessage("Os vencedores são: " .. table.concat(winners, ", ") .. ". Cada vencedor recebe " .. prizePerWinner .. " gold.", MESSAGE_EVENT_ADVANCE)
    else
        broadcastMessage("Nenhum jogador acertou o número vencedor. O pote foi perdido.", MESSAGE_EVENT_ADVANCE)
    end

    table.insert(eventHistory, {winningNumber = winningNumber, totalPot = totalPot, winners = winners})

    bets = {}
    totalPot = 0
    winningNumber = 0

    return true
end

-- Function to process bets
function processBet(cid, param)
    if not eventStarted then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Nenhum evento de cassino está em andamento.")
        return true
    end

    local betNumber = tonumber(param)
    if not betNumber or betNumber < 1 or betNumber > cfg.maxNumber then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Aposta inválida. Escolha um número entre 1 e " .. cfg.maxNumber .. ".")
        return true
    end

    local playerMoney = getPlayerMoney(cid)
    if playerMoney < cfg.betAmount then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem dinheiro suficiente para fazer uma aposta. O valor da aposta é " .. cfg.betAmount .. " gold.")
        return true
    end

    doPlayerRemoveMoney(cid, cfg.betAmount)
    totalPot = totalPot + cfg.betAmount
    bets[cid] = betNumber

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você apostou " .. cfg.betAmount .. " gold no número " .. betNumber .. ".")
    return true
end

-- Function to check for winners periodically
function checkForWinners()
    if not eventStarted then
        return
    end

    local hasWinner = false
    for cid, number in pairs(bets) do
        if number == winningNumber then
            hasWinner = true
            break
        end
    end

    if not hasWinner then
        addEvent(checkForWinners, cfg.checkInterval)
    end
end

-- Function to notify players periodically
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

-- Function to show the history of events
function showEventHistory(cid)
    if #eventHistory == 0 then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Não há histórico de eventos de cassino.")
    else
        for i, event in ipairs(eventHistory) do
            local winnersStr = table.concat(event.winners, ", ")
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Evento #" .. i .. ": Número vencedor: " .. event.winningNumber .. ", Pote total: " .. event.totalPot .. ", Vencedores: " .. (winnersStr == "" and "Nenhum" or winnersStr) .. ".")
        end
    end
    return true
end

-- Register the commands
function onStartup()
    registerCreatureEvent(cid, "onSay")
end
