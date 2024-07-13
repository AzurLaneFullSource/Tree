local var0_0 = class("GetActivityShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = ActivityConst.ACTIVITY_TYPE_SHOP
	local var3_1 = getProxy(ActivityProxy):getActivitiesByType(var2_1)
	local var4_1 = getProxy(ShopsProxy)
	local var5_1 = {}

	_.each(var3_1, function(arg0_2)
		if arg0_2 and not arg0_2:isEnd() and arg0_2:getConfig("config_id") == 0 then
			local var0_2 = ActivityShop.New(arg0_2)

			var5_1[arg0_2.id] = var0_2

			var4_1:addActivityShops(var5_1)
		end
	end)
	arg0_1:sendNotification(GAME.GET_ACTIVITY_SHOP_DONE)

	if var1_1 then
		var1_1(var5_1)
	end
end

return var0_0
