local var0 = class("GetShopStreetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(22101, {
		type = 0
	}, 22102, function(arg0)
		arg0:sendNotification(GAME.GET_SHOPSTREET_DONE)

		local var0 = getProxy(ShopsProxy):getShopStreet()

		if var1 then
			var1(var0)
		end
	end)
end

return var0
