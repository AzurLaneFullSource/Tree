local var0_0 = class("EquipESkinFormShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.oldShipId
	local var2_1 = var0_1.oldShipPos
	local var3_1 = var0_1.newShipId
	local var4_1 = var0_1.newShipPos
	local var5_1 = getProxy(EquipmentProxy)
	local var6_1 = getProxy(BayProxy)
	local var7_1 = var6_1:getShipById(var1_1)

	if not var7_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_no_old_ship"))

		return
	end

	local var8_1 = var7_1:getEquipSkin(var2_1)

	if var8_1 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_no_old_skinorequipment"))

		return
	end

	local var9_1 = var6_1:getShipById(var3_1)

	if not var9_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_no_new_ship"))

		return
	end

	local function var10_1()
		local var0_2 = var5_1:getEquipmnentSkinById(var8_1)

		if not var0_2 or var0_2.count == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_count_noenough"))

			return
		end

		pg.ConnectionMgr.GetInstance():Send(12036, {
			ship_id = var3_1,
			equip_skin_id = var8_1,
			pos = var4_1
		}, 12037, function(arg0_3)
			if arg0_3.result == 0 then
				local var0_3 = var9_1:getEquipSkin(var4_1)

				if var0_3 ~= 0 then
					var5_1:addEquipmentSkin(var0_3, 1)
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
				end

				var9_1:updateEquipmentSkin(var4_1, var8_1)
				var6_1:updateShip(var9_1)
				var5_1:useageEquipmnentSkin(var8_1)
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_replace_done"))
				arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP_DONE)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload_failed" .. arg0_3.result))
			end
		end)
	end

	pg.ConnectionMgr.GetInstance():Send(12036, {
		equip_skin_id = 0,
		ship_id = var1_1,
		pos = var2_1
	}, 12037, function(arg0_4)
		if arg0_4.result == 0 then
			var7_1:updateEquipmentSkin(var2_1, 0)
			var6_1:updateShip(var7_1)
			var5_1:addEquipmentSkin(var8_1, 1)
			var10_1()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload_failed" .. arg0_4.result))
		end
	end)
end

return var0_0
