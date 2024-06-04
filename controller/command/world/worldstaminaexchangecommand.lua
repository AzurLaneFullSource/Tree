local var0 = class("WorldStaminaExchangeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(PlayerProxy)
	local var2 = nowWorld().staminaMgr
	local var3, var4, var5, var6 = var2:GetExchangeData()

	pg.ConnectionMgr.GetInstance():Send(33108, {
		type = 1
	}, 33109, function(arg0)
		if arg0.result == 0 then
			local var0 = var1:getData()

			var0:consume({
				oil = var4
			})
			var1:updatePlayer(var0)
			var2:ExchangeStamina(var3, true)
			arg0:sendNotification(GAME.WORLD_STAMINA_EXCHANGE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_stamina_exchange_err_", arg0.result))
		end
	end)
end

return var0
