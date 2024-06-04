local var0 = class("RemoveEliteTargerShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.callback

	pg.ConnectionMgr.GetInstance():Send(13111, {
		ship_id = var1
	}, 13112, function(arg0)
		getProxy(ChapterProxy):setEliteCache(arg0.fleet_list)
		arg0:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP_DONE, {
			shipId = var1
		})
		existCall(var2)
	end)
end

return var0
