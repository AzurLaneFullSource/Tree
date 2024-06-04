local var0 = class("DestroyEquipmentsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = {}
	local var2 = getProxy(EquipmentProxy)
	local var3

	for iter0, iter1 in ipairs(var0.equipments) do
		local var4 = iter1[1]
		local var5 = iter1[2]
		local var6 = var2:getEquipmentById(var4)

		if not var6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_destroyEquipments_error_noEquip"))

			return
		end

		if var5 > var6.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_destroyEquipments_error_notEnoughEquip"))

			return
		end

		table.insert(var1, {
			id = var4,
			count = var5
		})

		if not var3 then
			local var7 = false

			if var6:isImportance() then
				var7 = true
			end

			if var6:getConfig("rarity") >= EquipmentRarity.Gold then
				var7 = true
			end

			if var6:getConfig("id") % 20 >= 10 then
				var7 = true
			end

			var3 = var7 and var4
		end
	end

	local var8 = {}

	if var3 then
		table.insert(var8, function(arg0)
			local var0 = pg.SecondaryPWDMgr

			var0:LimitedOperation(var0.RESOLVE_EQUIPMENT, var3, arg0)
		end)
	end

	seriesAsync(var8, function()
		pg.ConnectionMgr.GetInstance():Send(14008, {
			equip_list = var1
		}, 14009, function(arg0)
			if arg0.result == 0 then
				local var0 = getProxy(PlayerProxy):getData()
				local var1 = {}
				local var2 = 0

				local function var3(arg0, arg1)
					print("remove: " .. arg0 .. " " .. arg1)

					local var0 = var2:getEquipmentById(arg0)

					var2:removeEquipmentById(arg0, arg1)

					local var1 = var0:getConfig("destory_item") or {}
					local var2 = var0:getConfig("destory_gold") or 0

					var2 = var2 + var2 * arg1

					for iter0, iter1 in ipairs(var1) do
						local var3 = false

						for iter2, iter3 in ipairs(var1) do
							if iter1[1] == var1[iter2].id then
								var1[iter2].count = var1[iter2].count + iter1[2] * arg1
								var3 = true

								break
							end
						end

						if not var3 then
							table.insert(var1, Drop.New({
								type = DROP_TYPE_ITEM,
								id = iter1[1],
								count = iter1[2] * arg1
							}))
						end
					end
				end

				arg0:sendNotification(EquipmentMediator.NO_UPDATE)

				for iter0, iter1 in ipairs(var1) do
					var3(iter1.id, iter1.count)
				end

				table.insert(var1, Drop.New({
					id = 1,
					type = DROP_TYPE_RESOURCE,
					count = var2
				}))

				for iter2, iter3 in ipairs(var1) do
					arg0:sendNotification(GAME.ADD_ITEM, iter3)
				end

				if not LOCK_QUOTA_SHOP then
					local var4 = QuotaShop.New()

					getProxy(ShopsProxy):updateQuotaShop(var4)
				end

				arg0:sendNotification(GAME.DESTROY_EQUIPMENTS_DONE, var1)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_destroyEquipments", arg0.result))
			end
		end)
	end)
end

return var0
