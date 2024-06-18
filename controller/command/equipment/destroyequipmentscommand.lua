local var0_0 = class("DestroyEquipmentsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = {}
	local var2_1 = getProxy(EquipmentProxy)
	local var3_1

	for iter0_1, iter1_1 in ipairs(var0_1.equipments) do
		local var4_1 = iter1_1[1]
		local var5_1 = iter1_1[2]
		local var6_1 = var2_1:getEquipmentById(var4_1)

		if not var6_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_destroyEquipments_error_noEquip"))

			return
		end

		if var5_1 > var6_1.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_destroyEquipments_error_notEnoughEquip"))

			return
		end

		table.insert(var1_1, {
			id = var4_1,
			count = var5_1
		})

		if not var3_1 then
			local var7_1 = false

			if var6_1:isImportance() then
				var7_1 = true
			end

			if var6_1:getConfig("rarity") >= EquipmentRarity.Gold then
				var7_1 = true
			end

			if var6_1:getConfig("id") % 20 >= 10 then
				var7_1 = true
			end

			var3_1 = var7_1 and var4_1
		end
	end

	local var8_1 = {}

	if var3_1 then
		table.insert(var8_1, function(arg0_2)
			local var0_2 = pg.SecondaryPWDMgr

			var0_2:LimitedOperation(var0_2.RESOLVE_EQUIPMENT, var3_1, arg0_2)
		end)
	end

	seriesAsync(var8_1, function()
		pg.ConnectionMgr.GetInstance():Send(14008, {
			equip_list = var1_1
		}, 14009, function(arg0_4)
			if arg0_4.result == 0 then
				local var0_4 = getProxy(PlayerProxy):getData()
				local var1_4 = {}
				local var2_4 = 0

				local function var3_4(arg0_5, arg1_5)
					print("remove: " .. arg0_5 .. " " .. arg1_5)

					local var0_5 = var2_1:getEquipmentById(arg0_5)

					var2_1:removeEquipmentById(arg0_5, arg1_5)

					local var1_5 = var0_5:getConfig("destory_item") or {}
					local var2_5 = var0_5:getConfig("destory_gold") or 0

					var2_4 = var2_4 + var2_5 * arg1_5

					for iter0_5, iter1_5 in ipairs(var1_5) do
						local var3_5 = false

						for iter2_5, iter3_5 in ipairs(var1_4) do
							if iter1_5[1] == var1_4[iter2_5].id then
								var1_4[iter2_5].count = var1_4[iter2_5].count + iter1_5[2] * arg1_5
								var3_5 = true

								break
							end
						end

						if not var3_5 then
							table.insert(var1_4, Drop.New({
								type = DROP_TYPE_ITEM,
								id = iter1_5[1],
								count = iter1_5[2] * arg1_5
							}))
						end
					end
				end

				arg0_1:sendNotification(EquipmentMediator.NO_UPDATE)

				for iter0_4, iter1_4 in ipairs(var1_1) do
					var3_4(iter1_4.id, iter1_4.count)
				end

				table.insert(var1_4, Drop.New({
					id = 1,
					type = DROP_TYPE_RESOURCE,
					count = var2_4
				}))

				for iter2_4, iter3_4 in ipairs(var1_4) do
					arg0_1:sendNotification(GAME.ADD_ITEM, iter3_4)
				end

				if not LOCK_QUOTA_SHOP then
					local var4_4 = QuotaShop.New()

					getProxy(ShopsProxy):updateQuotaShop(var4_4)
				end

				arg0_1:sendNotification(GAME.DESTROY_EQUIPMENTS_DONE, var1_4)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_destroyEquipments", arg0_4.result))
			end
		end)
	end)
end

return var0_0
