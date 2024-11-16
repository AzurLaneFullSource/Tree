local var0_0 = class("GetNewServerShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.actType or ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP
	local var3_1 = getProxy(ActivityProxy):getActivityByType(var2_1)

	if not var3_1 or var3_1:isEnd() then
		var1_1()

		return
	end

	pg.ConnectionMgr.GetInstance():Send(26041, {
		act_id = var3_1.id
	}, 26042, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2

			if var2_1 == ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP then
				var0_2 = NewServerShop.New({
					start_time = arg0_2.start_time,
					stop_time = arg0_2.stop_time,
					goods = arg0_2.goods,
					id = var3_1.id
				})
			elseif var2_1 == ActivityConst.ACTIVITY_TYPE_BLACK_FRIDAY_SHOP then
				var0_2 = BlackFridayShop.New({
					start_time = arg0_2.start_time,
					stop_time = arg0_2.stop_time,
					goods = arg0_2.goods,
					id = var3_1.id
				})
			end

			getProxy(ShopsProxy):SetNewServerShop(var2_1, var0_2)
			var1_1(var0_2)
			arg0_1:sendNotification(GAME.GET_NEW_SERVER_SHOP_DONE)
		else
			var1_1()
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
