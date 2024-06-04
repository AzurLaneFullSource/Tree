local var0 = class("ShipAddMoneyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(19013, {
		id = var0
	}, 19014, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)
			local var1 = var0:getShipById(var0)
			local var2 = var1.state_info_4

			var1.state_info_4 = 0

			var0:updateShip(var1)

			local var3 = getProxy(PlayerProxy)
			local var4 = var3:getData()

			var4:addResources({
				dormMoney = var2
			})
			var3:updatePlayer(var4)

			if var2 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_getResource_emptry"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddMoney_ok", var1:getName(), var2))
			end

			getProxy(DormProxy):UpdateInimacyAndMoney()
			arg0:sendNotification(GAME.BACKYARD_ADD_MONEY_DONE, {
				id = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_shipAddMoney", arg0.result))
		end
	end)
end

return var0
