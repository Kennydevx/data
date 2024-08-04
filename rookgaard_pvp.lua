-- rookgaard_pvp.lua
local pvpEnforced = false

function onSay(cid, words, param, channelId)
    local command = string.lower(param)
    
    if command == "on" then
        pvpEnforced = true
        doBroadcastMessage("PvP Enforced mode is now ON in Rookgaard.", MESSAGE_STATUS_WARNING)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "PvP Enforced mode has been enabled.")
        
    elseif command == "off" then
        pvpEnforced = false
        doBroadcastMessage("PvP Enforced mode is now OFF in Rookgaard.", MESSAGE_STATUS_WARNING)
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "PvP Enforced mode has been disabled.")
        
    else
        doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Usage: /rookenf on|off")
    end

    return true
end

function onThink(interval)
    if pvpEnforced then
        local rookgaard = getTown(12)  -- Assumindo que 12 é o ID de Rookgaard
        
        for _, pid in ipairs(getPlayersInTown(rookgaard)) do
            local player = Player(pid)
            if player then
                if not player:getPvpEnforced() then
                    player:setPvpEnforced(true)
                end
            end
        end
    end

    return true
end
