function onUse(cid, item, frompos, item2, topos)
	wall1 = {x=32889, y=32349, z=15, stackpos=1}	
	getwall1 = getThingfromPos(wall1)

	if item.itemid == 1945 and getwall1.itemid == 1946 then
		doTransformItem(item.uid,item.itemid+1)
	elseif item.itemid == 1946 then
		doTransformItem(item.uid,item.itemid-1)	
	else
		doPlayerSendCancel(cid,"Sorry, not possible.")
	end

	return 1
end