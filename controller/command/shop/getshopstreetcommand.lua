local var0_0 = class("GetShopStreetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(22101, {
		type = 0
	}, 22102, function(arg0_2)
		arg0_1:sendNotification(GAME.GET_SHOPSTREET_DONE)

		local var0_2 = getProxy(ShopsProxy):getShopStreet()

		if var1_1 then
			var1_1(var0_2)
		end
	end)
end

return var0_0
