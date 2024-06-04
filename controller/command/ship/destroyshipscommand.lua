local var0 = class("DestroyShipsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipIds

	if not var0.destroyEquipment then
		local var2 = false
	end

	local var3 = getProxy(BayProxy)
	local var4 = {}

	for iter0, iter1 in ipairs(var1) do
		local var5 = var3:getShipById(iter1)

		if var5 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", iter1))

			return
		end

		table.insert(var4, var5)
	end

	pg.ConnectionMgr.GetInstance():Send(12004, {
		ship_id_list = var1
	}, 12005, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(EquipmentProxy)
			local var1 = {}
			local var2 = {}

			for iter0, iter1 in ipairs(var4) do
				var3:removeShip(iter1)

				for iter2, iter3 in ipairs(iter1.equipments) do
					if iter3 then
						var0:addEquipment(iter3)

						if not var1[iter3.id] then
							var1[iter3.id] = iter3:clone()
						else
							var1[iter3.id].count = var1[iter3.id].count + 1
						end
					end

					if iter1:getEquipSkin(iter2) ~= 0 then
						var0:addEquipmentSkin(iter1:getEquipSkin(iter2), 1)
						iter1:updateEquipmentSkin(iter2, 0)
						pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_skin_unload"))
					end
				end

				local var3 = iter1:GetSpWeapon()

				if var3 then
					iter1:UpdateSpWeapon(nil)
					var0:AddSpWeapon(var3)
					pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_unload"))
				end

				table.insert(var2, iter1.id)
			end

			local var4, var5, var6 = ShipCalcHelper.CalcDestoryRes(var4)
			local var7 = {}

			if var4 > 0 then
				table.insert(var7, Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResGold,
					count = var4
				}))
			end

			if var5 > 0 then
				table.insert(var7, Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResOil,
					count = var5
				}))
			end

			local var8 = table.mergeArray(var7, var6)

			for iter4, iter5 in ipairs(var8) do
				arg0:sendNotification(GAME.ADD_ITEM, iter5)
			end

			arg0:sendNotification(GAME.DESTROY_SHIP_DONE, {
				destroiedShipIds = var2,
				bonus = var8,
				equipments = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_destoryShips", arg0.result))
		end
	end)
end

function var0.CheckShareSkin(arg0, arg1)
	if not arg1.propose then
		return
	end

	local var0 = arg1:getProposeSkin()

	if not var0 then
		return
	end

	local var1 = {}
	local var2 = {}

	for iter0, iter1 in pairs(getProxy(BayProxy):getRawData()) do
		if iter1.skinId == var0.id then
			if iter1.groupId == arg1.groupId then
				table.insert(var1, iter1)
			else
				table.insert(var2, iter1)
			end
		end
	end

	if #var1 <= 0 then
		for iter2, iter3 in ipairs(var2) do
			iter3.skinId = iter3:getConfig("skin_id")
		end
	end

	if #var2 > 0 then
		local var3 = table.concat(_.map(var2, function(arg0)
			return arg0:getName()
		end), ", ")

		pg.TipsMgr.GetInstance():ShowTips(i18n("retire_marry_skin", var3))
	end
end

return var0
