local var0_0 = class("ShipAddInimacyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(19011, {
		id = var0_1
	}, 19012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy):getShipById(var0_1)
			local var1_2 = getProxy(DormProxy)
			local var2_2 = var1_2:getRawData()
			local var3_2, var4_2 = var2_2:HarvestInimacyAndMoney(var0_1)

			var1_2:updateDrom(var2_2, BackYardConst.DORM_UPDATE_TYPE_SHIP)

			if inimacy == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_getResource_emptry"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shipAddInimacy_ok", var0_2:getName()))
			end

			arg0_1:sendNotification(GAME.BACKYARD_ADD_INTIMACY_DONE, {
				id = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("backyard_shipAddInimacy", arg0_2.result))
		end
	end)
end

return var0_0
