local var0 = class("GetNewServerShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)

	if not var1 or var1:isEnd() then
		var0()

		return
	end

	pg.ConnectionMgr.GetInstance():Send(26041, {
		act_id = var1.id
	}, 26042, function(arg0)
		if arg0.result == 0 then
			local var0 = NewServerShop.New({
				start_time = arg0.start_time,
				stop_time = arg0.stop_time,
				goods = arg0.goods,
				id = var1.id
			})

			getProxy(ShopsProxy):SetNewServerShop(var0)
			var0(var0)
			arg0:sendNotification(GAME.GET_NEW_SERVER_SHOP_DONE)
		else
			var0()
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
