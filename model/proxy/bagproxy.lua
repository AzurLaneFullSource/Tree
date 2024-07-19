local var0_0 = class("BagProxy", import(".NetProxy"))

var0_0.ITEM_UPDATED = "item updated"

function var0_0.register(arg0_1)
	arg0_1:on(15001, function(arg0_2)
		arg0_1.data = {}
		arg0_1.loveLetterRepairDic = {}

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

function var0_0.hasExtraData(arg0_5, arg1_5, arg2_5)
	warning(PrintTable(arg0_5.extraItemData[arg1_5] or {}))

	return table.contains(arg0_5.extraItemData[arg1_5] or {}, arg2_5)
end

function var0_0.addItemById(arg0_6, arg1_6, arg2_6, arg3_6)
	assert(arg2_6 > 0, "count should greater than zero")

	if arg1_6 == ITEM_ID_CUBE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_CUBE_ADD, arg2_6)
	end

	for iter0_6 = 1, arg2_6 do
		arg0_6:addExtraData(arg1_6, arg3_6)
	end

	arg0_6:updateItem(arg1_6, arg2_6, arg3_6)
end

function var0_0.removeItemById(arg0_7, arg1_7, arg2_7, arg3_7)
	assert(arg2_7 > 0, "count should greater than zero")

	if arg1_7 == ITEM_ID_CUBE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_CUBE_CONSUME, arg2_7)
	end

	for iter0_7 = 1, arg2_7 do
		arg0_7:removeExtraData(arg1_7, arg3_7)
	end

	arg0_7:updateItem(arg1_7, -arg2_7, arg3_7)
end

function var0_0.getItemsByExclude(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.data) do
		local var1_8 = iter1_8:getConfig("type")

		if not Item.INVISIBLE_TYPE[var1_8] and iter1_8.count > 0 then
			if arg0_8.extraItemData[iter0_8] then
				local var2_8 = iter1_8.count

				for iter2_8, iter3_8 in ipairs(arg0_8.extraItemData[iter0_8]) do
					table.insert(var0_8, Item.New({
						count = 1,
						id = iter0_8,
						extra = iter3_8
					}))

					var2_8 = var2_8 - 1
				end

				if var2_8 > 0 then
					table.insert(var0_8, Item.New({
						id = iter0_8,
						count = var2_8
					}))
				end
			else
				table.insert(var0_8, iter1_8)
			end
		end
	end

	return var0_8
end

function var0_0.getItemsByType(arg0_9, arg1_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.data) do
		if iter1_9:getConfig("type") == arg1_9 and iter1_9.count ~= 0 then
			table.insert(var0_9, iter1_9)
		end
	end

	return Clone(var0_9)
end

function var0_0.ExitTypeItems(arg0_10, arg1_10)
	for iter0_10, iter1_10 in pairs(arg0_10.data) do
		if iter1_10:getConfig("type") == arg1_10 and iter1_10.count > 0 then
			return true
		end
	end

	return false
end

function var0_0.GetItemsByCondition(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.data) do
		local var1_11 = true

		if arg1_11 then
			for iter2_11, iter3_11 in pairs(arg1_11) do
				if iter1_11:getConfig(iter2_11) ~= iter3_11 then
					var1_11 = false

					break
				end
			end
		end

		if var1_11 then
			table.insert(var0_11, iter1_11)
		end
	end

	return var0_11
end

function var0_0.getItemById(arg0_12, arg1_12)
	if arg0_12.data[arg1_12] ~= nil then
		return arg0_12.data[arg1_12]:clone()
	end

	return nil
end

function var0_0.RawGetItemById(arg0_13, arg1_13)
	if arg0_13.data[arg1_13] ~= nil then
		return arg0_13.data[arg1_13]
	end

	return nil
end

function var0_0.getItemCountById(arg0_14, arg1_14)
	local var0_14 = arg0_14.data[arg1_14] and arg0_14.data[arg1_14].count or 0

	if arg0_14.extraItemData[arg1_14] and #arg0_14.extraItemData[arg1_14] > 0 then
		var0_14 = math.max(var0_14, 1)
	end

	return var0_14
end

function var0_0.getBoxCount(arg0_15)
	local var0_15 = arg0_15:getItemsByType(Item.EQUIPMENT_BOX_TYPE_5)

	return table.getCount(var0_15)
end

function var0_0.getCanComposeCount(arg0_16)
	local var0_16 = 0
	local var1_16 = pg.compose_data_template

	for iter0_16, iter1_16 in pairs(var1_16.all) do
		local var2_16 = var1_16[iter1_16].material_id
		local var3_16 = var1_16[iter1_16].material_num
		local var4_16 = arg0_16:getItemById(var2_16)

		if var4_16 and var3_16 <= var4_16.count then
			var0_16 = var0_16 + 1
		end
	end

	return var0_16
end

function var0_0.updateItem(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = arg0_17.data[arg1_17] or Item.New({
		count = 0,
		id = arg1_17
	})

	var0_17.count = var0_17.count + arg2_17

	assert(var0_17.count >= 0, "item count error: " .. var0_17.id)

	arg0_17.data[var0_17.id] = var0_17

	arg0_17.data[var0_17.id]:display("updated")

	local var1_17 = var0_17:clone()

	var1_17.extra = arg3_17

	arg0_17.facade:sendNotification(var0_0.ITEM_UPDATED, var1_17)
end

function var0_0.canUpgradeFlagShipEquip(arg0_18)
	local var0_18 = getProxy(BayProxy):getEquipment2ByflagShip()

	if var0_18 then
		for iter0_18, iter1_18 in pairs(var0_18:getConfig("trans_use_item")) do
			local var1_18 = arg0_18:getItemById(iter1_18[1])

			if not var1_18 or var1_18.count < iter1_18[2] then
				return false
			end
		end

		return true
	end
end

function var0_0.AddLimitCnt(arg0_19, arg1_19, arg2_19)
	arg0_19.limitList[arg1_19] = (arg0_19.limitList[arg1_19] or 0) + arg2_19
end

function var0_0.GetLimitCntById(arg0_20, arg1_20)
	return arg0_20.limitList[arg1_20] or 0
end

function var0_0.ClearLimitCnt(arg0_21, arg1_21)
	arg0_21.limitList[arg1_21] = 0
end

function var0_0.GetSkinShopDiscountItemList(arg0_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in pairs(arg0_22.data) do
		if iter1_22.count > 0 and iter1_22:IsSkinShopDiscountType() then
			table.insert(var0_22, iter1_22)
		end
	end

	return var0_22
end

function var0_0.SetLoveLetterRepairInfo(arg0_23, arg1_23, arg2_23)
	arg0_23.loveLetterRepairDic[arg1_23] = arg2_23
end

function var0_0.GetLoveLetterRepairInfo(arg0_24, arg1_24)
	return arg0_24.loveLetterRepairDic[arg1_24]
end

return var0_0
