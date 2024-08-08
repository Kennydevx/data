function onSay(player, words, param)
    if not player:getGroup():getAccess() then
        return true
    end

    Game.startGlobalEvent("battle_royale_safezone")
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Safezone battle royale iniciada.")
    return false
end
