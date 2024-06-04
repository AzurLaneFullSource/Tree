local var0 = class("ProposeRegiesterShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().shipId
	local var1 = getProxy(BayProxy):getShipById(var0)

	if not var1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var0))

		return
	end

	if not var1.propose or var1:ShowPropose() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(12032, {
		ship_id = var0
	}, 12033, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(PlayerProxy)
			local var1 = var0:getData()

			var1:SetProposeShipId(var0)
			var0:updatePlayer(var1)
			arg0:sendNotification(GAME.PROPOSE_REGISTER_SHIP_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_proposeShip", arg0.result))
		end
	end)
end

return var0
