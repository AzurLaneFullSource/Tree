local var0_0 = class("ShipAddInimacyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(19011, {
		id = var0_1
	}, 19012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)
			local var1_2 = var0_2:getShipById(var0_1)
			local var2_2 = var1_2.state_info_3

			var1_2:addLikability(var2_2)

			var1_2.state_info_3 = 0

			var0_2:updateShip(var1_2)

			if var2_2 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_getResource_emptry"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ok", var1_2:getName()))
			end

			getProxy(DormProxy):UpdateInimacyAndMoney()
			arg0_1:sendNotification(GAME.BACKYARD_ADD_INTIMACY_DONE, {
				id = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_shipAddInimacy", arg0_2.result))
		end
	end)
end

return var0_0
