-- Casino Event Configuration
local cfg = {
    startCommand = "/startcasino",  -- Command to start the event
    endCommand = "/endcasino",      -- Command to end the event
    betCommand = "!bet",           -- Command to place a bet
    betAmount = 1000,              -- Amount of gold required to place a bet
    maxNumber = 500,               -- Maximum number for betting
    bettingTime = 5 * 60 * 1000,    -- Time allowed for betting (5 minutes)
    checkInterval = 30 * 1000,     -- Interval to check for winners (30 seconds)
}

local bets = {}                  -- Table to store player bets
local eventStarted = false       -- Flag to check if the event is running
local winningNumber = 0          -- Winning number
local totalPot = 0               -- Total accumulated prize pot
local lastCheckTime = 0          -- Last time the event was checked for winners

-- Function to handle commands
function onSay(cid, words, param, channel)
    -- Ensure no empty parameters are processed
    if param == nil then
        param = ''
    end

    -- Start Casino Event
    if words == cfg.startCommand then
        if eventStarted then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "The casino event is already in progress.")
            return true
        end

        eventStarted = true
        bets = {}
        totalPot = 0
        winningNumber = math.random(1, cfg.maxNumber)
        lastCheckTime = os.time()

        -- Announce the start of the event
        broadcastMessage("The casino event has started! Place your bets on a number between 1 and " .. cfg.maxNumber .. " within " .. (cfg.bettingTime / 60000) .. " minutes to win the accumulated pot. Use the command '" .. cfg.betCommand .. " <number>' to place your bet.", MESSAGE_EVENT_ADVANCE)

        -- Schedule event end
        addEvent(endCasinoEvent, cfg.bettingTime)

        -- Start the checking loop
        addEvent(checkForWinners, cfg.checkInterval)

        return true

    -- End Casino Event
    elseif words == cfg.endCommand then
        if not eventStarted then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "No casino event is currently running.")
            return true
        end

        endCasinoEvent()

        return true

    -- Place Bet
    elseif words == cfg.betCommand then
        if param == '' then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Please specify a number to bet on.")
            return true
        end

        return processBet(cid, param)
    end

    return false
end

-- Function to process player bets
function processBet(cid, param)
    if not eventStarted then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "No casino event is currently running.")
        return true
    end

    local betNumber = tonumber(param)
    if not betNumber or betNumber < 1 or betNumber > cfg.maxNumber then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Invalid bet. Choose a number between 1 and " .. cfg.maxNumber .. ".")
        return true
    end

    local playerMoney = getPlayerMoney(cid)
    if playerMoney < cfg.betAmount then
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You do not have enough money to place a bet. The bet amount is " .. cfg.betAmount .. " gold.")
        return true
    end

    -- Deduct bet amount and add to the pot
    doPlayerRemoveMoney(cid, cfg.betAmount)
    totalPot = totalPot + cfg.betAmount

    -- Store player's bet
    bets[cid] = betNumber

    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You have bet " .. cfg.betAmount .. " gold on number " .. betNumber .. ".")
    return true
end

-- Function to end the casino event
function endCasinoEvent()
    if not eventStarted then
        return
    end

    eventStarted = false

    -- Announce the end of the event
    broadcastMessage("The casino event has ended! The winning number is " .. winningNumber .. ".", MESSAGE_EVENT_ADVANCE)

    -- Find winners
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
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You have won " .. prizePerWinner .. " gold in the casino event.")
        end
        broadcastMessage("The winners are: " .. table.concat(winners, ", ") .. ". Each winner receives " .. prizePerWinner .. " gold.", MESSAGE_EVENT_ADVANCE)
    else
        broadcastMessage("No players guessed the winning number. The pot has been lost.", MESSAGE_EVENT_ADVANCE)
    end

    -- Reset event variables
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
            broadcastMessage("No winners yet. The event is extended for more time. Continue placing your bets!", MESSAGE_EVENT_ADVANCE)
            -- Extend the event by re-scheduling
            addEvent(checkForWinners, cfg.checkInterval)
        end
    end
end
