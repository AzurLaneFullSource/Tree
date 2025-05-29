local var0_0 = class("SetShipSkinCommand", pm.SimpleCommand)

var0_0.SKIN_UPDATED = "skin updated"

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.phantomId
	local var3_1 = var0_1.skinId
	local var4_1 = var0_1.hideTip

	if var3_1 ~= 0 then
		var3_1 = ShipSkin.GetChangeSkinMainId(var3_1)
	end

	pg.ConnectionMgr.GetInstance():Send(12202, {
		ship_id = var1_1,
		skin_id = var3_1,
		skin_shadow = var2_1
	}, 12203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)

			var0_2:updateShipSkin(var1_1, var2_1, var3_1)

			local var1_2 = var0_2:GetShipPhantom(ShipPhantom.PackMark(var1_1, var2_1))
			local var2_2 = getProxy(PlayerProxy)
			local var3_2 = var2_2:getData()

			if var3_2:GetFlagShipPhantomMark() == var1_2:GetShipPhantomMark() then
				var3_2.skinId = var1_2:getSkinId()

				var2_2:updatePlayer(var3_2)
			end

			arg0_1:sendNotification(var0_0.SKIN_UPDATED, {
				ship = var1_2
			})

			if not var4_1 then
				if var2_1 == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_set_skin_success"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("shadow_skin_change_success"))
				end
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_set_skin_error", arg0_2.result))
		end
	end)
end

return var0_0
