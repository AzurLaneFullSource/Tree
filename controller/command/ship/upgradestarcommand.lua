local var0_0 = class("UpgradeStarCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.shipIds
	local var3_1 = getProxy(BayProxy)
	local var4_1 = var3_1:getShipById(var1_1)
	local var5_1 = pg.ship_data_breakout[var4_1.configId].breakout_id

	if var5_1 == 0 then
		return
	end

	local var6_1 = Clone(var4_1)

	var6_1.configId = var5_1

	for iter0_1, iter1_1 in pairs(var4_1.equipments) do
		if iter1_1 and var6_1:isForbiddenAtPos(iter1_1, iter0_1) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_upgrade_unequip_tip", var6_1:getConfig("name"), "#fad545"),
				onYes = function()
					arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
						shipId = var4_1.id,
						pos = iter0_1
					})
				end
			})

			return
		end
	end

	local var7_1 = Clone(var4_1)
	local var8_1 = {}

	for iter2_1, iter3_1 in ipairs(var2_1) do
		local var9_1 = var3_1:getShipById(iter3_1)

		if not var9_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", iter3_1))

			return
		end

		table.insert(var8_1, var9_1)
	end

	local var10_1 = getProxy(CollectionProxy):getShipGroup(var7_1.groupId)

	pg.ConnectionMgr.GetInstance():Send(12027, {
		ship_id = var1_1,
		material_id_list = var2_1
	}, 12028, function(arg0_3)
		if arg0_3.result == 0 then
			local var0_3 = getProxy(EquipmentProxy)

			for iter0_3, iter1_3 in ipairs(var8_1) do
				for iter2_3, iter3_3 in ipairs(iter1_3.equipments) do
					if iter3_3 then
						var0_3:addEquipment(iter3_3)
					end

					if iter1_3:getEquipSkin(iter2_3) ~= 0 then
						var0_3:addEquipmentSkin(iter1_3:getEquipSkin(iter2_3), 1)
						iter1_3:updateEquipmentSkin(iter2_3, 0)
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
					end
				end

				local var1_3 = iter1_3:GetSpWeapon()

				if var1_3 then
					iter1_3:UpdateSpWeapon(nil)
					var0_3:AddSpWeapon(var1_3)
				end

				var3_1:removeShip(iter1_3)
			end

			local var2_3 = pg.ship_data_breakout[var4_1.configId]

			if var2_3.breakout_id ~= 0 then
				var4_1.configId = var2_3.breakout_id

				local var3_3 = pg.ship_data_template[var4_1.configId]

				for iter4_3, iter5_3 in ipairs(var3_3.buff_list) do
					if not var4_1.skills[iter5_3] then
						var4_1.skills[iter5_3] = {
							exp = 0,
							level = 1,
							id = iter5_3
						}
					end
				end

				var4_1:updateMaxLevel(var3_3.max_level)

				local var4_3 = pg.ship_data_template[var7_1.configId].buff_list

				for iter6_3, iter7_3 in ipairs(var4_3) do
					if not table.contains(var3_3.buff_list, iter7_3) then
						var4_1.skills[iter7_3] = nil
					end
				end

				var3_1:updateShip(var4_1)
			end

			local var5_3 = getProxy(BagProxy)

			for iter8_3, iter9_3 in ipairs(var2_3.use_item) do
				var5_3:removeItemById(iter9_3[1], iter9_3[2])
			end

			local var6_3 = getProxy(PlayerProxy)
			local var7_3 = var6_3:getData()

			var7_3:consume({
				gold = var2_3.use_gold
			})
			var6_3:updatePlayer(var7_3)
			arg0_1:sendNotification(GAME.UPGRADE_STAR_DONE, {
				newShip = var4_1,
				oldShip = var7_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_upgradeStar_error", arg0_3.result))
		end
	end)
end

return var0_0
