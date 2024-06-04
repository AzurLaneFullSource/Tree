local var0 = class("EquipESkinFormShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.oldShipId
	local var2 = var0.oldShipPos
	local var3 = var0.newShipId
	local var4 = var0.newShipPos
	local var5 = getProxy(EquipmentProxy)
	local var6 = getProxy(BayProxy)
	local var7 = var6:getShipById(var1)

	if not var7 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_no_old_ship"))

		return
	end

	local var8 = var7:getEquipSkin(var2)

	if var8 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_no_old_skinorequipment"))

		return
	end

	local var9 = var6:getShipById(var3)

	if not var9 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_no_new_ship"))

		return
	end

	local function var10()
		local var0 = var5:getEquipmnentSkinById(var8)

		if not var0 or var0.count == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_count_noenough"))

			return
		end

		pg.ConnectionMgr.GetInstance():Send(12036, {
			ship_id = var3,
			equip_skin_id = var8,
			pos = var4
		}, 12037, function(arg0)
			if arg0.result == 0 then
				local var0 = var9:getEquipSkin(var4)

				if var0 ~= 0 then
					var5:addEquipmentSkin(var0, 1)
					pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
				end

				var9:updateEquipmentSkin(var4, var8)
				var6:updateShip(var9)
				var5:useageEquipmnentSkin(var8)
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_replace_done"))
				arg0:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP_DONE)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload_failed" .. arg0.result))
			end
		end)
	end

	pg.ConnectionMgr.GetInstance():Send(12036, {
		equip_skin_id = 0,
		ship_id = var1,
		pos = var2
	}, 12037, function(arg0)
		if arg0.result == 0 then
			var7:updateEquipmentSkin(var2, 0)
			var6:updateShip(var7)
			var5:addEquipmentSkin(var8, 1)
			var10()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload_failed" .. arg0.result))
		end
	end)
end

return var0
