local var0_0 = class("RemoveEliteTargerShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(13111, {
		ship_id = var1_1
	}, 13112, function(arg0_2)
		getProxy(ChapterProxy):setEliteCache(arg0_2.fleet_list)
		arg0_1:sendNotification(GAME.REMOVE_ELITE_TARGET_SHIP_DONE, {
			shipId = var1_1
		})
		existCall(var2_1)
	end)
end

return var0_0
