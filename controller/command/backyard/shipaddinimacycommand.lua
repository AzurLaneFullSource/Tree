local var0 = class("ShipAddInimacyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(19011, {
		id = var0
	}, 19012, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)
			local var1 = var0:getShipById(var0)
			local var2 = var1.state_info_3

			var1:addLikability(var2)

			var1.state_info_3 = 0

			var0:updateShip(var1)

			if var2 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_getResource_emptry"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ok", var1:getName()))
			end

			getProxy(DormProxy):UpdateInimacyAndMoney()
			arg0:sendNotification(GAME.BACKYARD_ADD_INTIMACY_DONE, {
				id = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_shipAddInimacy", arg0.result))
		end
	end)
end

return var0
