-- Fire axe Dragon Cave Quest --

function onUse(cid, item, frompos, item2, topos)
if item.uid == 15067 then
  queststatus = getPlayerStorageValue(cid,15067)
  if queststatus == -1 or queststatus == 0 then
  if getPlayerFreeCap(cid) <= 100 then
doPlayerSendTextMessage(cid,22,"You need 100 cap or more to loot this!")
return TRUE
end
   doPlayerSendTextMessage(cid,22,"You have found poison daggers and arrows..")
   item_uid = doPlayerAddItem(cid,2411,1)
   item_uid = doPlayerAddItem(cid,2411,1)
   item_uid = doPlayerAddItem(cid,2544,30)
   setPlayerStorageValue(cid,15067,1)

  else
   doPlayerSendTextMessage(cid,22,"it\'s empty.")
  end
else
  return 0
end
return 1
end

