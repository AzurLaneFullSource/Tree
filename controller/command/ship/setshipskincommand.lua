local var0_0 = class("SetShipSkinCommand", pm.SimpleCommand)

var0_0.SKIN_UPDATED = "skin updated"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.skinId
	local var3_1 = var0_1.hideTip

	pg.ConnectionMgr.GetInstance():Send(12202, {
		ship_id = var1_1,
		skin_id = var2_1
	}, 12203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)
			local var1_2 = var0_2:getShipById(var1_1)

			var1_2.skinId = var2_1 or 0

			if var1_2.skinId == 0 then
				var1_2.skinId = var1_2:getConfig("skin_id")
			end

			if not var1_2.skinId or var1_2.skinId == 0 then
				var1_2.skinId = var1_2:getConfig("skin_id")
			end

			var0_2:updateShip(var1_2)

			local var2_2 = getProxy(PlayerProxy)
			local var3_2 = var2_2:getData()

			if var3_2.character == var1_1 then
				var3_2.skinId = var1_2.skinId

				var2_2:updatePlayer(var3_2)
			end

			arg0_1:sendNotification(var0_0.SKIN_UPDATED, {
				ship = var1_2
			})

			if not var3_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_set_skin_success"))
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_set_skin_error", arg0_2.result))
		end
	end)
end

return var0_0
