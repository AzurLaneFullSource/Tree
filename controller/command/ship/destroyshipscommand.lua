local var0_0 = class("DestroyShipsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipIds

	if not var0_1.destroyEquipment then
		local var2_1 = false
	end

	local var3_1 = getProxy(BayProxy)
	local var4_1 = {}

	for iter0_1, iter1_1 in ipairs(var1_1) do
		local var5_1 = var3_1:getShipById(iter1_1)

		if var5_1 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", iter1_1))

			return
		end

		table.insert(var4_1, var5_1)
	end

	pg.ConnectionMgr.GetInstance():Send(12004, {
		ship_id_list = var1_1
	}, 12005, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(EquipmentProxy)
			local var1_2 = {}
			local var2_2 = {}

			for iter0_2, iter1_2 in ipairs(var4_1) do
				var3_1:removeShip(iter1_2)

				for iter2_2, iter3_2 in ipairs(iter1_2.equipments) do
					if iter3_2 then
						var0_2:addEquipment(iter3_2)

						if not var1_2[iter3_2.id] then
							var1_2[iter3_2.id] = iter3_2:clone()
						else
							var1_2[iter3_2.id].count = var1_2[iter3_2.id].count + 1
						end
					end

					if iter1_2:getEquipSkin(iter2_2) ~= 0 then
						var0_2:addEquipmentSkin(iter1_2:getEquipSkin(iter2_2), 1)
						iter1_2:updateEquipmentSkin(iter2_2, 0)
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
					end
				end

				local var3_2 = iter1_2:GetSpWeapon()

				if var3_2 then
					iter1_2:UpdateSpWeapon(nil)
					var0_2:AddSpWeapon(var3_2)
					pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_unload"))
				end

				table.insert(var2_2, iter1_2.id)
			end

			local var4_2, var5_2, var6_2 = ShipCalcHelper.CalcDestoryRes(var4_1)
			local var7_2 = {}

			if var4_2 > 0 then
				table.insert(var7_2, Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResGold,
					count = var4_2
				}))
			end

			if var5_2 > 0 then
				table.insert(var7_2, Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResOil,
					count = var5_2
				}))
			end

			local var8_2 = table.mergeArray(var7_2, var6_2)

			for iter4_2, iter5_2 in ipairs(var8_2) do
				arg0_1:sendNotification(GAME.ADD_ITEM, iter5_2)
			end

			arg0_1:sendNotification(GAME.DESTROY_SHIP_DONE, {
				destroiedShipIds = var2_2,
				bonus = var8_2,
				equipments = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_destoryShips", arg0_2.result))
		end
	end)
end

function var0_0.CheckShareSkin(arg0_3, arg1_3)
	if not arg1_3.propose then
		return
	end

	local var0_3 = arg1_3:getProposeSkin()

	if not var0_3 then
		return
	end

	local var1_3 = {}
	local var2_3 = {}

	for iter0_3, iter1_3 in pairs(getProxy(BayProxy):getRawData()) do
		if iter1_3.skinId == var0_3.id then
			if iter1_3.groupId == arg1_3.groupId then
				table.insert(var1_3, iter1_3)
			else
				table.insert(var2_3, iter1_3)
			end
		end
	end

	if #var1_3 <= 0 then
		for iter2_3, iter3_3 in ipairs(var2_3) do
			iter3_3.skinId = iter3_3:getConfig("skin_id")
		end
	end

	if #var2_3 > 0 then
		local var3_3 = table.concat(_.map(var2_3, function(arg0_4)
			return arg0_4:getName()
		end), ", ")

		pg.TipsMgr.GetInstance():ShowTips(i18n("retire_marry_skin", var3_3))
	end
end

return var0_0
