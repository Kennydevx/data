function onUse(cid, item, itemEx, toPosition)
 
local pos = getCreaturePosition(cid)
if (getTilePzInfo(getPlayerPosition(cid)) == TRUE) then
if(getPlayerStorageValue(cid, 1038) == 1) then
doPlayerSendTextMessage(cid, 22, "You already have Green Djin Quest!")
else
doRemoveItem(item.uid, 1)
setPlayerStorageValue(cid, 1038, 1)
doPlayerSendTextMessage(cid, 22, "You just completed Green Djin Quest!")
end
else
doPlayerSendTextMessage(cid, 22, "You can only use this item inside protection zone!")
end
return true
end