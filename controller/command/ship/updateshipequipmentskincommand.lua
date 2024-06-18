local var0_0 = class("UpdateShipEquipmentSkinCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.pos
	local var3_1 = var0_1.equipmentSkinId
	local var4_1 = getProxy(EquipmentProxy)

	if var3_1 and var3_1 ~= 0 then
		local var5_1 = var4_1:getEquipmnentSkinById(var3_1)

		assert(var5_1, "不存在该外观" .. var3_1)

		if not var5_1 or var5_1.count == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_count_noenough"))

			return
		end
	end

	local var6_1 = getProxy(BayProxy)
	local var7_1 = var6_1:getShipById(var1_1)

	if not var7_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_no_new_ship"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12036, {
		ship_id = var1_1,
		equip_skin_id = var3_1,
		pos = var2_1
	}, 12037, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var7_1:getEquipSkin(var2_1)

			var7_1:updateEquipmentSkin(var2_1, var3_1)
			var6_1:updateShip(var7_1)

			if var3_1 and var3_1 ~= 0 then
				if var0_2 and var0_2 ~= 0 then
					var4_1:addEquipmentSkin(var0_2, 1)
				end

				var4_1:useageEquipmnentSkin(var3_1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_replace_done"))
			else
				var4_1:addEquipmentSkin(var0_2, 1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
			end

			arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP_DONE, {
				ship = var7_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
