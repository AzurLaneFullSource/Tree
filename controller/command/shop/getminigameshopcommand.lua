local var0_0 = class("GetMiniGameShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(26150, {
		type = 1
	}, 26151, function(arg0_2)
		local var0_2 = MiniGameShop.New(arg0_2)
		local var1_2 = getProxy(ShopsProxy):setMiniShop(var0_2)

		arg0_1:sendNotification(GAME.GET_MINI_GAME_SHOP_DONE)

		if var1_1 then
			var1_1(var0_2)
		end
	end)
end

return var0_0
