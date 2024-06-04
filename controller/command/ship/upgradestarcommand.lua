local var0 = class("UpgradeStarCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.shipIds
	local var3 = getProxy(BayProxy)
	local var4 = var3:getShipById(var1)
	local var5 = pg.ship_data_breakout[var4.configId].breakout_id

	if var5 == 0 then
		return
	end

	local var6 = Clone(var4)

	var6.configId = var5

	for iter0, iter1 in pairs(var4.equipments) do
		if iter1 and var6:isForbiddenAtPos(iter1, iter0) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_upgrade_unequip_tip", var6:getConfig("name"), "#fad545"),
				onYes = function()
					arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
						shipId = var4.id,
						pos = iter0
					})
				end
			})

			return
		end
	end

	local var7 = Clone(var4)
	local var8 = {}

	for iter2, iter3 in ipairs(var2) do
		local var9 = var3:getShipById(iter3)

		if not var9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", iter3))

			return
		end

		table.insert(var8, var9)
	end

	local var10 = getProxy(CollectionProxy):getShipGroup(var7.groupId)

	pg.ConnectionMgr.GetInstance():Send(12027, {
		ship_id = var1,
		material_id_list = var2
	}, 12028, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(EquipmentProxy)

			for iter0, iter1 in ipairs(var8) do
				for iter2, iter3 in ipairs(iter1.equipments) do
					if iter3 then
						var0:addEquipment(iter3)
					end

					if iter1:getEquipSkin(iter2) ~= 0 then
						var0:addEquipmentSkin(iter1:getEquipSkin(iter2), 1)
						iter1:updateEquipmentSkin(iter2, 0)
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
					end
				end

				local var1 = iter1:GetSpWeapon()

				if var1 then
					iter1:UpdateSpWeapon(nil)
					var0:AddSpWeapon(var1)
				end

				var3:removeShip(iter1)
			end

			local var2 = pg.ship_data_breakout[var4.configId]

			if var2.breakout_id ~= 0 then
				var4.configId = var2.breakout_id

				local var3 = pg.ship_data_template[var4.configId]

				for iter4, iter5 in ipairs(var3.buff_list) do
					if not var4.skills[iter5] then
						var4.skills[iter5] = {
							exp = 0,
							level = 1,
							id = iter5
						}
					end
				end

				var4:updateMaxLevel(var3.max_level)

				local var4 = pg.ship_data_template[var7.configId].buff_list

				for iter6, iter7 in ipairs(var4) do
					if not table.contains(var3.buff_list, iter7) then
						var4.skills[iter7] = nil
					end
				end

				var3:updateShip(var4)
			end

			local var5 = getProxy(BagProxy)

			for iter8, iter9 in ipairs(var2.use_item) do
				var5:removeItemById(iter9[1], iter9[2])
			end

			local var6 = getProxy(PlayerProxy)
			local var7 = var6:getData()

			var7:consume({
				gold = var2.use_gold
			})
			var6:updatePlayer(var7)
			arg0:sendNotification(GAME.UPGRADE_STAR_DONE, {
				newShip = var4,
				oldShip = var7
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_upgradeStar_error", arg0.result))
		end
	end)
end

return var0
