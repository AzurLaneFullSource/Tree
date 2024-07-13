local var0_0 = class("GetMedalShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(16106, {
		type = 0
	}, 16107, function(arg0_2)
		local var0_2

		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.GET_MEDALSHOP_DONE)

			var0_2 = MedalShop.New(arg0_2)

			local var1_2 = getProxy(ShopsProxy)

			if var1_2.medalShop then
				var1_2:UpdateMedalShop(var0_2)
			else
				var1_2:SetMedalShop(var0_2)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end

		if var1_1 then
			var1_1(var0_2)
		end
	end)
end

return var0_0
