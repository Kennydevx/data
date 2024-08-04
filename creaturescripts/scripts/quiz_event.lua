local QUIZ_STORAGE = 9876
local CORRECT_ANSWER = "42" -- Resposta correta

local function startQuiz()
    setGlobalStorageValue(QUIZ_STORAGE, 1)
    local players = Game.getPlayers()
    for _, player in pairs(players) do
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "The quiz has started! Type '/answer [your answer]' to participate.")
    end
end

local function onSay(cid, words, param, channelId)
    if words == "/startquiz" then
        startQuiz()
        return true
    end

    if words:sub(1, 8) == "/answer " then
        local answer = words:sub(9)
        if answer == CORRECT_ANSWER then
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! You answered correctly and received 1000 gold!")
            doPlayerAddMoney(cid, 1000)
        else
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Incorrect answer. Try again!")
        end
        return true
    end

    return false
end
