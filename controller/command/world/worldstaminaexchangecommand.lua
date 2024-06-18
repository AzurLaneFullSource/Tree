local var0_0 = class("WorldStaminaExchangeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(PlayerProxy)
	local var2_1 = nowWorld().staminaMgr
	local var3_1, var4_1, var5_1, var6_1 = var2_1:GetExchangeData()

	pg.ConnectionMgr.GetInstance():Send(33108, {
		type = 1
	}, 33109, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var1_1:getData()

			var0_2:consume({
				oil = var4_1
			})
			var1_1:updatePlayer(var0_2)
			var2_1:ExchangeStamina(var3_1, true)
			arg0_1:sendNotification(GAME.WORLD_STAMINA_EXCHANGE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_stamina_exchange_err_", arg0_2.result))
		end
	end)
end

return var0_0
