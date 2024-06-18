local var0_0 = class("ProposeRegiesterShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().shipId
	local var1_1 = getProxy(BayProxy):getShipById(var0_1)

	if not var1_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var0_1))

		return
	end

	if not var1_1.propose or var1_1:ShowPropose() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(12032, {
		ship_id = var0_1
	}, 12033, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(PlayerProxy)
			local var1_2 = var0_2:getData()

			var1_2:SetProposeShipId(var0_1)
			var0_2:updatePlayer(var1_2)
			arg0_1:sendNotification(GAME.PROPOSE_REGISTER_SHIP_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_proposeShip", arg0_2.result))
		end
	end)
end

return var0_0
