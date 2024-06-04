local var0 = class("BagProxy", import(".NetProxy"))

var0.ITEM_UPDATED = "item updated"

function var0.register(arg0)
	arg0:on(15001, function(arg0)
		arg0.data = {}

		for iter0, iter1 in ipairs(arg0.item_list) do
			local var0 = Item.New({
				id = iter1.id,
				count = iter1.count
			})

			var0:display("loaded")

			arg0.data[var0.id] = var0
		end

		arg0.limitList = {}

		for iter2, iter3 in ipairs(arg0.limit_list) do
			arg0.limitList[iter3.id] = iter3.count
		end

		arg0.extraItemData = {}

		for iter4, iter5 in ipairs(arg0.item_misc_list) do
			arg0.extraItemData[iter5.id] = arg0.extraItemData[iter5.id] or {}

			table.insert(arg0.extraItemData[iter5.id], iter5.data)
		end
	end)
end

function var0.addExtraData(arg0, arg1, arg2)
	arg0.extraItemData[arg1] = arg0.extraItemData[arg1] or {}

	table.insert(arg0.extraItemData[arg1], arg2)
end

function var0.removeExtraData(arg0, arg1, arg2)
	table.removebyvalue(arg0.extraItemData[arg1] or {}, arg2)
end

function var0.addItemById(arg0, arg1, arg2, arg3)
	assert(arg2 > 0, "count should greater than zero")

	if arg1 == ITEM_ID_CUBE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_CUBE_ADD, arg2)
	end

	arg0:updateItem(arg1, arg2, arg3)
end

function var0.removeItemById(arg0, arg1, arg2, arg3)
	assert(arg2 > 0, "count should greater than zero")

	if arg1 == ITEM_ID_CUBE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_CUBE_CONSUME, arg2)
	end

	arg0:updateItem(arg1, -arg2, arg3)
end

function var0.getItemsByExclude(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		local var1 = iter1:getConfig("type")

		if not Item.INVISIBLE_TYPE[var1] and iter1.count > 0 then
			if arg0.extraItemData[iter0] then
				local var2 = iter1.count

				for iter2, iter3 in ipairs(arg0.extraItemData[iter0]) do
					table.insert(var0, Item.New({
						count = 1,
						id = iter0,
						extra = iter3
					}))

					var2 = var2 - 1
				end

				if var2 > 0 then
					table.insert(var0, Item.New({
						id = iter0,
						count = var2
					}))
				end
			else
				table.insert(var0, iter1)
			end
		end
	end

	return var0
end

function var0.getItemsByType(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:getConfig("type") == arg1 and iter1.count ~= 0 then
			table.insert(var0, iter1)
		end
	end

	return Clone(var0)
end

function var0.ExitTypeItems(arg0, arg1)
	for iter0, iter1 in pairs(arg0.data) do
		if iter1:getConfig("type") == arg1 and iter1.count > 0 then
			return true
		end
	end

	return false
end

function var0.GetItemsByCondition(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		local var1 = true

		if arg1 then
			for iter2, iter3 in pairs(arg1) do
				if iter1:getConfig(iter2) ~= iter3 then
					var1 = false

					break
				end
			end
		end

		if var1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getItemById(arg0, arg1)
	if arg0.data[arg1] ~= nil then
		return arg0.data[arg1]:clone()
	end

	return nil
end

function var0.RawGetItemById(arg0, arg1)
	if arg0.data[arg1] ~= nil then
		return arg0.data[arg1]
	end

	return nil
end

function var0.getItemCountById(arg0, arg1)
	local var0 = arg0.data[arg1] and arg0.data[arg1].count or 0

	if arg0.extraItemData[arg1] and #arg0.extraItemData[arg1] > 0 then
		var0 = math.max(var0, 1)
	end

	return var0
end

function var0.getBoxCount(arg0)
	local var0 = arg0:getItemsByType(Item.EQUIPMENT_BOX_TYPE_5)

	return table.getCount(var0)
end

function var0.getCanComposeCount(arg0)
	local var0 = 0
	local var1 = pg.compose_data_template

	for iter0, iter1 in pairs(var1.all) do
		local var2 = var1[iter1].material_id
		local var3 = var1[iter1].material_num
		local var4 = arg0:getItemById(var2)

		if var4 and var3 <= var4.count then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.updateItem(arg0, arg1, arg2, arg3)
	local var0 = arg0.data[arg1] or Item.New({
		count = 0,
		id = arg1
	})

	var0.count = var0.count + arg2

	assert(var0.count >= 0, "item count error: " .. var0.id)

	if arg3 then
		arg0.extraItemData[arg1] = arg0.extraItemData[arg1] or {}

		for iter0 = -1, arg2, -1 do
			local var1 = table.removebyvalue(arg0.extraItemData[arg1], arg3)

			assert(var1 > 0)
		end

		for iter1 = 1, arg2 do
			table.insert(arg0.extraItemData[arg1], arg3)
		end
	end

	arg0.data[var0.id] = var0

	arg0.data[var0.id]:display("updated")
	arg0.facade:sendNotification(var0.ITEM_UPDATED, var0:clone())
end

function var0.canUpgradeFlagShipEquip(arg0)
	local var0 = getProxy(BayProxy):getEquipment2ByflagShip()

	if var0 then
		for iter0, iter1 in pairs(var0:getConfig("trans_use_item")) do
			local var1 = arg0:getItemById(iter1[1])

			if not var1 or var1.count < iter1[2] then
				return false
			end
		end

		return true
	end
end

function var0.AddLimitCnt(arg0, arg1, arg2)
	arg0.limitList[arg1] = (arg0.limitList[arg1] or 0) + arg2
end

function var0.GetLimitCntById(arg0, arg1)
	return arg0.limitList[arg1] or 0
end

function var0.ClearLimitCnt(arg0, arg1)
	arg0.limitList[arg1] = 0
end

function var0.GetSkinShopDiscountItemList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.count > 0 and iter1:IsSkinShopDiscountType() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

return var0
