local var0 = class("SetShipSkinCommand", pm.SimpleCommand)

var0.SKIN_UPDATED = "skin updated"

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.skinId
	local var3 = var0.hideTip

	pg.ConnectionMgr.GetInstance():Send(12202, {
		ship_id = var1,
		skin_id = var2
	}, 12203, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)
			local var1 = var0:getShipById(var1)

			var1.skinId = var2 or 0

			if var1.skinId == 0 then
				var1.skinId = var1:getConfig("skin_id")
			end

			if not var1.skinId or var1.skinId == 0 then
				var1.skinId = var1:getConfig("skin_id")
			end

			var0:updateShip(var1)

			local var2 = getProxy(PlayerProxy)
			local var3 = var2:getData()

			if var3.character == var1 then
				var3.skinId = var1.skinId

				var2:updatePlayer(var3)
			end

			arg0:sendNotification(var0.SKIN_UPDATED, {
				ship = var1
			})

			if not var3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_set_skin_success"))
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_set_skin_error", arg0.result))
		end
	end)
end

return var0
