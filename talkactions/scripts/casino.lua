-- Em data/talkactions/scripts/casino.lua
local Casino = {}

function Casino:start()
    self.roundStarted = true
    self.casino = Casino:new()
    self.casino:startRound()
end

function Casino:placeBet(player, number)
    if not self.roundStarted then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "The casino round has not started yet.")
        return
    end

    if number < 1 or number > 500 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid number. Please choose a number between 1 and 500.")
        return
    end

    self.casino:placeBet(player, number)
end

function Casino:endRound()
    if not self.roundStarted then
        return
    end
    
    self.casino:endRound()
    self.roundStarted = false
end

function onSay(player, words, param)
    if words == "!startcasino" then
        Casino:start()
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Casino round has started.")
    elseif words == "!bet" then
        local number = tonumber(param)
        Casino:placeBet(player, number)
    elseif words == "!endcasino" then
        Casino:endRound()
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Casino round has ended.")
    end
end
