local var0 = class("ModShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.shipIds or {}
	local var3 = getProxy(BayProxy)
	local var4 = var3:getShipById(var1)
	local var5 = Clone(var4)

	if not var4 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var1))

		return
	end

	if table.getCount(var2) == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

		return
	end

	local var6 = {}

	for iter0, iter1 in ipairs(var2) do
		local var7 = var3:getShipById(iter1)

		if not var7 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", iter1))

			return
		end

		table.insert(var6, var7)
	end

	pg.ConnectionMgr.GetInstance():Send(12017, {
		ship_id = var1,
		material_id_list = var2
	}, 12018, function(arg0)
		if arg0.result == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_INTENSIFY, #var2)

			local var0 = {}
			local var1 = getProxy(EquipmentProxy)

			for iter0, iter1 in ipairs(var6) do
				for iter2, iter3 in ipairs(iter1.equipments) do
					if iter3 then
						var1:addEquipment(iter3)

						if not var0[iter3.id] then
							var0[iter3.id] = iter3:clone()
						else
							var0[iter3.id].count = var0[iter3.id].count + 1
						end
					end

					if iter1:getEquipSkin(iter2) ~= 0 then
						var1:addEquipmentSkin(iter1:getEquipSkin(iter2), 1)
						iter1:updateEquipmentSkin(iter2, 0)
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
					end
				end

				local var2 = iter1:GetSpWeapon()

				if var2 then
					iter1:UpdateSpWeapon(nil)
					var1:AddSpWeapon(var2)
				end

				var3:removeShip(iter1)
			end

			local var3 = ShipModLayer.getModExpAdditions(var4, var6)

			for iter4, iter5 in pairs(var3) do
				var4:addModAttrExp(iter4, iter5)
			end

			var3:updateShip(var4)
			arg0:sendNotification(GAME.MOD_SHIP_DONE, {
				oldShip = var5,
				newShip = var4,
				equipments = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_modShip_error", arg0.result))
		end
	end)
end

return var0
