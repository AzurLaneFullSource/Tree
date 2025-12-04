local var0_0 = class("IslandInventoryAgency", import(".IslandBaseAgency"))

var0_0.ADD_ITEM = "IslandInventoryAgency.ADD_ITEM"
var0_0.REMOVE_ITEM = "IslandInventoryAgency.REMOVE_ITEM"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.level = 1
	arg0_1.configId = arg0_1.level
	arg0_1.itemList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.item_list or {}) do
		local var0_1 = IslandItem.New(iter1_1)

		arg0_1.itemList[var0_1.id] = var0_1
	end

	arg0_1.overflowItemList = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.item_list_cache or {}) do
		local var1_1 = IslandItem.New(iter3_1)

		arg0_1.overflowItemList[var1_1.id] = var1_1
	end
end

function var0_0.InitPrivateData(arg0_2, arg1_2)
	arg0_2.level = arg1_2.storage_level
end

function var0_0.GetOverflowItemList(arg0_3)
	return arg0_3.overflowItemList
end

function var0_0.RemoveOverflowItem(arg0_4, arg1_4, arg2_4)
	if not arg0_4.overflowItemList[arg1_4] then
		return
	end

	local var0_4 = math.max(0, arg0_4.overflowItemList[arg1_4].count - arg2_4)

	if var0_4 <= 0 then
		arg0_4.overflowItemList[arg1_4] = nil
	else
		arg0_4.overflowItemList[arg1_4].count = var0_4
	end
end

function var0_0.AddOverFlowItem(arg0_5, arg1_5)
	arg0_5.overflowItemList[arg1_5.id] = arg1_5
end

function var0_0.GetItemList(arg0_6)
	return arg0_6.itemList
end

function var0_0.GetGroupedItemList(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.itemList) do
		local var1_7 = iter1_7:GetNumberOfSlotsOccupied()

		if var1_7 <= 1 then
			table.insert(var0_7, IslandItem.New({
				id = iter0_7,
				num = iter1_7:GetCount()
			}))
		else
			local var2_7 = iter1_7:getConfig("group_max")
			local var3_7 = iter1_7:GetCount() % var2_7

			for iter2_7 = 1, var1_7 do
				local var4_7 = iter2_7 == var1_7 and var3_7 > 0 and IslandItem.New({
					id = iter0_7,
					num = var3_7
				}) or IslandItem.New({
					id = iter0_7,
					num = var2_7
				})

				table.insert(var0_7, var4_7)
			end
		end
	end

	return var0_7
end

function var0_0.TryAddItemFromOverflowList(arg0_8)
	local var0_8, var1_8 = arg0_8:SplitItemList4Add(arg0_8.overflowItemList)

	for iter0_8, iter1_8 in ipairs(var0_8) do
		arg0_8:AddItem(iter1_8)
	end

	arg0_8.overflowItemList = {}

	for iter2_8, iter3_8 in ipairs(var1_8) do
		arg0_8.overflowItemList[iter3_8.id] = iter3_8
	end

	return not arg0_8:ExistAnyOverFlowItem()
end

function var0_0.GetCanAddItemsFormOverFlowList(arg0_9)
	local var0_9, var1_9 = arg0_9:SplitItemList4Add(arg0_9.overflowItemList)

	return var0_9
end

function var0_0.AddItem(arg0_10, arg1_10)
	assert(isa(arg1_10, IslandItem))

	local var0_10 = arg1_10:GetCount()

	if var0_10 <= 0 then
		return
	end

	local var1_10 = 0

	if arg0_10:OwnItem(arg1_10.id) then
		local var2_10 = arg0_10.itemList[arg1_10.id].count

		arg0_10.itemList[arg1_10.id]:IncreaseCount(var0_10)
	else
		arg0_10.itemList[arg1_10.id] = arg1_10
	end

	arg0_10:DispatchEvent(var0_0.ADD_ITEM, arg1_10.id)
	IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.RECYCLE)
end

function var0_0.SplitItemList4Add(arg0_11, arg1_11)
	local var0_11 = {}
	local var1_11 = {}

	table.sort(arg1_11, CompareFuncs({
		function(arg0_12)
			return arg0_12:GetRarity() * -1
		end,
		function(arg0_13)
			return arg0_13.id
		end
	}))

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		for iter2_11 = 1, iter1_11:GetCount() do
			if arg0_11:CanAddItem(iter1_11.id, 1) then
				var0_11[iter1_11.id] = (var0_11[iter1_11.id] or 0) + 1
			else
				var1_11[iter1_11.id] = (var1_11[iter1_11.id] or 0) + 1
			end
		end
	end

	local var2_11 = {}
	local var3_11 = {}

	for iter3_11, iter4_11 in pairs(var0_11) do
		local var4_11 = IslandItem.New({
			id = iter3_11,
			num = iter4_11
		})

		table.insert(var2_11, var4_11)
	end

	for iter5_11, iter6_11 in pairs(var1_11) do
		local var5_11 = IslandItem.New({
			id = iter5_11,
			num = iter6_11
		})

		table.insert(var3_11, var5_11)
	end

	return var2_11, var3_11
end

function var0_0.TryAddItems(arg0_14, arg1_14)
	if arg0_14:ExistAnyOverFlowItem() then
		return
	end

	local var0_14, var1_14 = arg0_14:SplitItemList4Add(arg1_14)

	for iter0_14, iter1_14 in ipairs(var0_14) do
		arg0_14:AddItem(iter1_14)
	end

	for iter2_14, iter3_14 in ipairs(var1_14) do
		arg0_14.overflowItemList[iter3_14.id] = iter3_14
	end

	return not arg0_14:ExistAnyOverFlowItem()
end

function var0_0.ExistAnyOverFlowItem(arg0_15)
	return table.getCount(arg0_15.overflowItemList) > 0
end

function var0_0.CanAddItem(arg0_16, arg1_16, arg2_16)
	if arg0_16:ExistAnyOverFlowItem() then
		return false
	end

	local var0_16 = arg0_16:GetLength()

	if arg0_16:OwnItem(arg1_16) then
		local var1_16 = arg0_16:GetItemById(arg1_16)
		local var2_16 = arg2_16 + var1_16:GetCount()

		var0_16 = var0_16 + (IslandItem.New({
			id = arg1_16,
			num = var2_16
		}):GetNumberOfSlotsOccupied() - var1_16:GetNumberOfSlotsOccupied())
	end

	local var3_16 = arg0_16:GetCapacity()

	return var0_16 < var3_16, var0_16 - var3_16
end

function var0_0.RemoveItem(arg0_17, arg1_17, arg2_17)
	if not arg0_17:OwnItem(arg1_17) then
		return
	end

	local var0_17 = arg0_17.itemList[arg1_17]

	if not var0_17:CanRemove(arg2_17) then
		return
	end

	local var1_17 = var0_17.count

	var0_17:ReduceCount(arg2_17)

	if var0_17:IsNotOwned() then
		arg0_17.itemList[arg1_17] = nil
	end

	arg0_17:DispatchEvent(var0_0.REMOVE_ITEM, arg1_17)
	IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.RECYCLE)
end

function var0_0.GetItemById(arg0_18, arg1_18)
	return arg0_18.itemList[arg1_18]
end

function var0_0.OwnItem(arg0_19, arg1_19)
	local var0_19 = arg0_19.itemList[arg1_19]

	return var0_19 and not var0_19:IsNotOwned()
end

function var0_0.GetOwnCount(arg0_20, arg1_20)
	local var0_20 = arg0_20.itemList[arg1_20]

	if not var0_20 then
		return 0
	else
		return var0_20:GetCount()
	end
end

function var0_0.GetCapacity(arg0_21)
	local var0_21 = arg0_21:GetHost():GetAblityAgency():GetInventoryMaxCntAddition()

	return arg0_21:getConfig("capacity") + var0_21
end

function var0_0.GetNextCapacity(arg0_22, arg1_22)
	local var0_22 = arg0_22:GetHost():GetAblityAgency():GetInventoryMaxCntAddition()
	local var1_22 = pg.island_storage_level

	if not var1_22[arg1_22] then
		return 0
	end

	return var1_22[arg1_22].capacity + var0_22
end

function var0_0.StaticGetLength(arg0_23, arg1_23)
	local var0_23 = 0

	for iter0_23, iter1_23 in pairs(arg1_23) do
		var0_23 = var0_23 + iter1_23:GetNumberOfSlotsOccupied()
	end

	return var0_23
end

function var0_0.GetLength(arg0_24)
	return arg0_24:StaticGetLength(arg0_24.itemList)
end

function var0_0.GetLevel(arg0_25)
	return arg0_25.level
end

function var0_0.getConfig(arg0_26, arg1_26)
	return pg.island_storage_level[arg0_26.level][arg1_26]
end

function var0_0.Upgrade(arg0_27)
	arg0_27.level = arg0_27.level + 1
	arg0_27.configId = arg0_27.level
end

function var0_0.IsMaxLevel(arg0_28)
	local var0_28 = pg.island_storage_level

	return var0_28.all[#var0_28.all] <= arg0_28.level
end

function var0_0.CanUpgrade(arg0_29)
	return not arg0_29:IsMaxLevel()
end

function var0_0.GetUpgradeConsume(arg0_30)
	if arg0_30:IsMaxLevel() then
		return {}
	end

	local var0_30 = pg.island_storage_level[arg0_30.level + 1].upgrade_material
	local var1_30 = {}

	for iter0_30, iter1_30 in ipairs(var0_30) do
		table.insert(var1_30, iter1_30)
	end

	return var1_30
end

function var0_0.GetGifts(arg0_31)
	local var0_31 = {}
	local var1_31 = pg.island_item_data_template.get_id_list_by_usage[IslandItemUsage.usage_ship_state]

	for iter0_31, iter1_31 in ipairs(var1_31) do
		local var2_31 = arg0_31:GetItemById(iter1_31) or IslandItem.New({
			num = 0,
			id = iter1_31
		})

		if var2_31 then
			table.insert(var0_31, var2_31)
		end
	end

	return var0_31
end

function var0_0.GetShipExpBooks(arg0_32)
	local var0_32 = {}
	local var1_32 = pg.island_item_data_template.get_id_list_by_type[IslandItem.TYPE_SHIP_EXP_BOOK]

	for iter0_32, iter1_32 in ipairs(var1_32) do
		local var2_32 = arg0_32:GetItemById(iter1_32) or IslandItem.New({
			num = 0,
			id = iter1_32
		})

		if var2_32 then
			table.insert(var0_32, var2_32)
		end
	end

	return var0_32
end

function var0_0.GetFishingItems(arg0_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(arg0_33:GetItemList()) do
		if iter1_33:IsFishingProp() then
			table.insert(var0_33, iter1_33)
		end
	end

	return var0_33
end

function var0_0.OnSeasonReset(arg0_34)
	local var0_34 = 0

	arg0_34.overflowItemList = {}

	for iter0_34, iter1_34 in pairs(arg0_34.itemList) do
		if iter1_34:CanConvert() then
			var0_34 = var0_34 + iter1_34:GetConvertPt() * iter1_34:GetCount()
			arg0_34.itemList[iter0_34] = nil
		end
	end

	return var0_34
end

return var0_0
