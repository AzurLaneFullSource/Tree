local var0 = class("GetMedalShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(16106, {
		type = 0
	}, 16107, function(arg0)
		local var0

		if arg0.result == 0 then
			arg0:sendNotification(GAME.GET_MEDALSHOP_DONE)

			var0 = MedalShop.New(arg0)

			local var1 = getProxy(ShopsProxy)

			if var1.medalShop then
				var1:UpdateMedalShop(var0)
			else
				var1:SetMedalShop(var0)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end

		if var1 then
			var1(var0)
		end
	end)
end

return var0
