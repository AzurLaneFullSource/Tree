local var0_0 = class("BagProxy", import(".NetProxy"))

var0_0.ITEM_UPDATED = "item updated"

function var0_0.register(arg0_1)
	arg0_1:on(15001, function(arg0_2)
		arg0_1.data = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.item_list) do
			local var0_2 = Item.New({
				id = iter1_2.id,
				count = iter1_2.count
			})

			var0_2:display("loaded")

			arg0_1.data[var0_2.id] = var0_2
		end

		arg0_1.limitList = {}

		for iter2_2, iter3_2 in ipairs(arg0_2.limit_list) do
			arg0_1.limitList[iter3_2.id] = iter3_2.count
		end

		arg0_1.extraItemData = {}

		for iter4_2, iter5_2 in ipairs(arg0_2.item_misc_list) do
			arg0_1.extraItemData[iter5_2.id] = arg0_1.extraItemData[iter5_2.id] or {}

			table.insert(arg0_1.extraItemData[iter5_2.id], iter5_2.data)
		end
	end)
end

function var0_0.addExtraData(arg0_3, arg1_3, arg2_3)
	arg0_3.extraItemData[arg1_3] = arg0_3.extraItemData[arg1_3] or {}

	table.insert(arg0_3.extraItemData[arg1_3], arg2_3)
end

function var0_0.removeExtraData(arg0_4, arg1_4, arg2_4)
	table.removebyvalue(arg0_4.extraItemData[arg1_4] or {}, arg2_4)
end

function var0_0.addItemById(arg0_5, arg1_5, arg2_5, arg3_5)
	assert(arg2_5 > 0, "count should greater than zero")

	if arg1_5 == ITEM_ID_CUBE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_CUBE_ADD, arg2_5)
	end

	arg0_5:updateItem(arg1_5, arg2_5, arg3_5)
end

function var0_0.removeItemById(arg0_6, arg1_6, arg2_6, arg3_6)
	assert(arg2_6 > 0, "count should greater than zero")

	if arg1_6 == ITEM_ID_CUBE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_CUBE_CONSUME, arg2_6)
	end

	arg0_6:updateItem(arg1_6, -arg2_6, arg3_6)
end

function var0_0.getItemsByExclude(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.data) do
		local var1_7 = iter1_7:getConfig("type")

		if not Item.INVISIBLE_TYPE[var1_7] and iter1_7.count > 0 then
			if arg0_7.extraItemData[iter0_7] then
				local var2_7 = iter1_7.count

				for iter2_7, iter3_7 in ipairs(arg0_7.extraItemData[iter0_7]) do
					table.insert(var0_7, Item.New({
						count = 1,
						id = iter0_7,
						extra = iter3_7
					}))

					var2_7 = var2_7 - 1
				end

				if var2_7 > 0 then
					table.insert(var0_7, Item.New({
						id = iter0_7,
						count = var2_7
					}))
				end
			else
				table.insert(var0_7, iter1_7)
			end
		end
	end

	return var0_7
end

function var0_0.getItemsByType(arg0_8, arg1_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.data) do
		if iter1_8:getConfig("type") == arg1_8 and iter1_8.count ~= 0 then
			table.insert(var0_8, iter1_8)
		end
	end

	return Clone(var0_8)
end

function var0_0.ExitTypeItems(arg0_9, arg1_9)
	for iter0_9, iter1_9 in pairs(arg0_9.data) do
		if iter1_9:getConfig("type") == arg1_9 and iter1_9.count > 0 then
			return true
		end
	end

	return false
end

function var0_0.GetItemsByCondition(arg0_10, arg1_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.data) do
		local var1_10 = true

		if arg1_10 then
			for iter2_10, iter3_10 in pairs(arg1_10) do
				if iter1_10:getConfig(iter2_10) ~= iter3_10 then
					var1_10 = false

					break
				end
			end
		end

		if var1_10 then
			table.insert(var0_10, iter1_10)
		end
	end

	return var0_10
end

function var0_0.getItemById(arg0_11, arg1_11)
	if arg0_11.data[arg1_11] ~= nil then
		return arg0_11.data[arg1_11]:clone()
	end

	return nil
end

function var0_0.RawGetItemById(arg0_12, arg1_12)
	if arg0_12.data[arg1_12] ~= nil then
		return arg0_12.data[arg1_12]
	end

	return nil
end

function var0_0.getItemCountById(arg0_13, arg1_13)
	local var0_13 = arg0_13.data[arg1_13] and arg0_13.data[arg1_13].count or 0

	if arg0_13.extraItemData[arg1_13] and #arg0_13.extraItemData[arg1_13] > 0 then
		var0_13 = math.max(var0_13, 1)
	end

	return var0_13
end

function var0_0.getBoxCount(arg0_14)
	local var0_14 = arg0_14:getItemsByType(Item.EQUIPMENT_BOX_TYPE_5)

	return table.getCount(var0_14)
end

function var0_0.getCanComposeCount(arg0_15)
	local var0_15 = 0
	local var1_15 = pg.compose_data_template

	for iter0_15, iter1_15 in pairs(var1_15.all) do
		local var2_15 = var1_15[iter1_15].material_id
		local var3_15 = var1_15[iter1_15].material_num
		local var4_15 = arg0_15:getItemById(var2_15)

		if var4_15 and var3_15 <= var4_15.count then
			var0_15 = var0_15 + 1
		end
	end

	return var0_15
end

function var0_0.updateItem(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg0_16.data[arg1_16] or Item.New({
		count = 0,
		id = arg1_16
	})

	var0_16.count = var0_16.count + arg2_16

	assert(var0_16.count >= 0, "item count error: " .. var0_16.id)

	if arg3_16 then
		arg0_16.extraItemData[arg1_16] = arg0_16.extraItemData[arg1_16] or {}

		for iter0_16 = -1, arg2_16, -1 do
			local var1_16 = table.removebyvalue(arg0_16.extraItemData[arg1_16], arg3_16)

			assert(var1_16 > 0)
		end

		for iter1_16 = 1, arg2_16 do
			table.insert(arg0_16.extraItemData[arg1_16], arg3_16)
		end
	end

	arg0_16.data[var0_16.id] = var0_16

	arg0_16.data[var0_16.id]:display("updated")
	arg0_16.facade:sendNotification(var0_0.ITEM_UPDATED, var0_16:clone())
end

function var0_0.canUpgradeFlagShipEquip(arg0_17)
	local var0_17 = getProxy(BayProxy):getEquipment2ByflagShip()

	if var0_17 then
		for iter0_17, iter1_17 in pairs(var0_17:getConfig("trans_use_item")) do
			local var1_17 = arg0_17:getItemById(iter1_17[1])

			if not var1_17 or var1_17.count < iter1_17[2] then
				return false
			end
		end

		return true
	end
end

function var0_0.AddLimitCnt(arg0_18, arg1_18, arg2_18)
	arg0_18.limitList[arg1_18] = (arg0_18.limitList[arg1_18] or 0) + arg2_18
end

function var0_0.GetLimitCntById(arg0_19, arg1_19)
	return arg0_19.limitList[arg1_19] or 0
end

function var0_0.ClearLimitCnt(arg0_20, arg1_20)
	arg0_20.limitList[arg1_20] = 0
end

function var0_0.GetSkinShopDiscountItemList(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in pairs(arg0_21.data) do
		if iter1_21.count > 0 and iter1_21:IsSkinShopDiscountType() then
			table.insert(var0_21, iter1_21)
		end
	end

	return var0_21
end

return var0_0
