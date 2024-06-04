local var0 = class("UpdateShipEquipmentSkinCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.pos
	local var3 = var0.equipmentSkinId
	local var4 = getProxy(EquipmentProxy)

	if var3 and var3 ~= 0 then
		local var5 = var4:getEquipmnentSkinById(var3)

		assert(var5, "不存在该外观" .. var3)

		if not var5 or var5.count == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_count_noenough"))

			return
		end
	end

	local var6 = getProxy(BayProxy)
	local var7 = var6:getShipById(var1)

	if not var7 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_no_new_ship"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12036, {
		ship_id = var1,
		equip_skin_id = var3,
		pos = var2
	}, 12037, function(arg0)
		if arg0.result == 0 then
			local var0 = var7:getEquipSkin(var2)

			var7:updateEquipmentSkin(var2, var3)
			var6:updateShip(var7)

			if var3 and var3 ~= 0 then
				if var0 and var0 ~= 0 then
					var4:addEquipmentSkin(var0, 1)
				end

				var4:useageEquipmnentSkin(var3)
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_replace_done"))
			else
				var4:addEquipmentSkin(var0, 1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
			end

			arg0:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP_DONE, {
				ship = var7
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
