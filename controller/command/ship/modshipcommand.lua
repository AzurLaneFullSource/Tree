local var0_0 = class("ModShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.shipIds or {}
	local var3_1 = getProxy(BayProxy)
	local var4_1 = var3_1:getShipById(var1_1)
	local var5_1 = Clone(var4_1)

	if not var4_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var1_1))

		return
	end

	if table.getCount(var2_1) == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

		return
	end

	local var6_1 = {}

	for iter0_1, iter1_1 in ipairs(var2_1) do
		local var7_1 = var3_1:getShipById(iter1_1)

		if not var7_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", iter1_1))

			return
		end

		table.insert(var6_1, var7_1)
	end

	pg.ConnectionMgr.GetInstance():Send(12017, {
		ship_id = var1_1,
		material_id_list = var2_1
	}, 12018, function(arg0_2)
		if arg0_2.result == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_INTENSIFY, #var2_1)

			local var0_2 = {}
			local var1_2 = getProxy(EquipmentProxy)

			for iter0_2, iter1_2 in ipairs(var6_1) do
				for iter2_2, iter3_2 in ipairs(iter1_2.equipments) do
					if iter3_2 then
						var1_2:addEquipment(iter3_2)

						if not var0_2[iter3_2.id] then
							var0_2[iter3_2.id] = iter3_2:clone()
						else
							var0_2[iter3_2.id].count = var0_2[iter3_2.id].count + 1
						end
					end

					if iter1_2:getEquipSkin(iter2_2) ~= 0 then
						var1_2:addEquipmentSkin(iter1_2:getEquipSkin(iter2_2), 1)
						iter1_2:updateEquipmentSkin(iter2_2, 0)
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
					end
				end

				local var2_2 = iter1_2:GetSpWeapon()

				if var2_2 then
					iter1_2:UpdateSpWeapon(nil)
					var1_2:AddSpWeapon(var2_2)
				end

				var3_1:removeShip(iter1_2)
			end

			local var3_2 = ShipModLayer.getModExpAdditions(var4_1, var6_1)

			for iter4_2, iter5_2 in pairs(var3_2) do
				var4_1:addModAttrExp(iter4_2, iter5_2)
			end

			var3_1:updateShip(var4_1)
			arg0_1:sendNotification(GAME.MOD_SHIP_DONE, {
				oldShip = var5_1,
				newShip = var4_1,
				equipments = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_modShip_error", arg0_2.result))
		end
	end)
end

return var0_0
