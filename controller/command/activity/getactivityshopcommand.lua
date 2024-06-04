local var0 = class("GetActivityShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback
	local var2 = ActivityConst.ACTIVITY_TYPE_SHOP
	local var3 = getProxy(ActivityProxy):getActivitiesByType(var2)
	local var4 = getProxy(ShopsProxy)
	local var5 = {}

	_.each(var3, function(arg0)
		if arg0 and not arg0:isEnd() and arg0:getConfig("config_id") == 0 then
			local var0 = ActivityShop.New(arg0)

			var5[arg0.id] = var0

			var4:addActivityShops(var5)
		end
	end)
	arg0:sendNotification(GAME.GET_ACTIVITY_SHOP_DONE)

	if var1 then
		var1(var5)
	end
end

return var0
