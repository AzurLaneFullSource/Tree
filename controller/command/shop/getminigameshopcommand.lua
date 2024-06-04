local var0 = class("GetMiniGameShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(26150, {
		type = 1
	}, 26151, function(arg0)
		local var0 = MiniGameShop.New(arg0)
		local var1 = getProxy(ShopsProxy):setMiniShop(var0)

		arg0:sendNotification(GAME.GET_MINI_GAME_SHOP_DONE)

		if var1 then
			var1(var0)
		end
	end)
end

return var0
