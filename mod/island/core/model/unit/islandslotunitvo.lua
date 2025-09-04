local var0_0 = class("IslandSlotUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.formula_id = arg1_1.formula_id
	arg0_1.slotType = arg1_1.slotType
	arg0_1.slotId = arg1_1.slotId
	arg0_1.isSelfIsland = arg1_1.isSelfIsland

	arg0_1:BindSlotData()
	arg0_1:InitGrowthTime()
	arg0_1:InitProductModelId()
end

function var0_0.GetProductModelId(arg0_2)
	return arg0_2.productModelId
end

function var0_0.SetHandPlantFormulaid(arg0_3, arg1_3)
	arg0_3.formula_id = arg1_3
end

function var0_0.StartDelegateSlotPerform(arg0_4)
	arg0_4.start_time = pg.TimeMgr.GetInstance():GetServerTime()

	local var0_4 = arg0_4.slotData:GetSlotRoleData()

	arg0_4.end_time = var0_4.start_time + var0_4.cost_time_list[1]
	arg0_4.formula_id = arg0_4.slotData:GetFormulaId()

	arg0_4:InitProductModelId()
end

function var0_0.ChangeSlotType(arg0_5, arg1_5)
	arg0_5.slotType = arg1_5

	arg0_5:BindSlotData()
end

function var0_0.InitGrowthTime(arg0_6)
	if arg0_6.slotType == IslandProductSystemVO.SlotType.HandPlant then
		if arg0_6.slotData then
			arg0_6.start_time = arg0_6.slotData.start_time
			arg0_6.end_time = arg0_6.slotData.end_time
		end
	elseif arg0_6.slotType == IslandProductSystemVO.SlotType.RoleDelegation then
		local var0_6 = arg0_6.slotData:GetSlotRoleData()

		if var0_6 then
			arg0_6.start_time = var0_6.start_time
			arg0_6.end_time = var0_6.start_time + var0_6.cost_time_list[1]
		end
	end
end

function var0_0.InitProductModelId(arg0_7)
	local function var0_7()
		if arg0_7.formula_id then
			local var0_8 = pg.island_formula[arg0_7.formula_id]

			arg0_7.unitList = var0_8.unitid

			local var1_8
			local var2_8

			if arg0_7.unitList and #arg0_7.unitList > 1 then
				var1_8, var2_8 = arg0_7:GetCurrentProduct()
			else
				var1_8 = arg0_7.unitList[1][2]
				var2_8 = arg0_7.unitList[1][1]
			end

			if var2_8 ~= 1 then
				arg0_7.needPercendUpdate = true
			else
				arg0_7.needPercendUpdate = false
			end

			arg0_7.productModelId = var1_8
			arg0_7.process = var2_8
		else
			arg0_7.needPercendUpdate = false
			arg0_7.productModelId = nil
		end
	end

	if arg0_7.slotType == IslandProductSystemVO.SlotType.HandPlant then
		var0_7()
	elseif arg0_7.slotType == IslandProductSystemVO.SlotType.RoleDelegation then
		if arg0_7.slotData:GetSlotRoleData() then
			var0_7()
		elseif arg0_7.formula_id then
			local var1_7 = pg.island_formula[arg0_7.formula_id]
			local var2_7 = #var1_7.unitid

			arg0_7.productModelId = var1_7.unitid[var2_7][2]
			arg0_7.needPercendUpdate = false
		else
			arg0_7.needPercendUpdate = false
		end
	end
end

function var0_0.GetCurrentProduct(arg0_9)
	local var0_9
	local var1_9

	if arg0_9.unitList and #arg0_9.unitList > 1 then
		local var2_9 = pg.TimeMgr.GetInstance():GetServerTime()
		local var3_9 = math.min(1, (var2_9 - arg0_9.start_time) / (arg0_9.end_time - arg0_9.start_time))

		var3_9 = var3_9 < 0 and 0 or var3_9

		for iter0_9, iter1_9 in ipairs(arg0_9.unitList) do
			if var3_9 >= iter1_9[1] then
				var0_9 = iter1_9[2]
				var1_9 = iter1_9[1]
			end
		end
	end

	return var0_9, var1_9
end

function var0_0.ChangeModel(arg0_10)
	if arg0_10.needPercendUpdate == false then
		return
	end

	local var0_10, var1_10 = arg0_10:GetCurrentProduct()

	if var1_10 ~= arg0_10.process then
		arg0_10.process = var1_10
		arg0_10.productModelId = var0_10

		return true
	end

	return false
end

function var0_0.BindSlotData(arg0_11)
	switch(arg0_11.slotType, {
		[IslandProductSystemVO.SlotType.HandCollect] = function()
			arg0_11.slotData = arg0_11:HandCollectSlotData()
		end,
		[IslandProductSystemVO.SlotType.HandPlant] = function()
			arg0_11.slotData = arg0_11:HandPlantSlotData()
		end,
		[IslandProductSystemVO.SlotType.RoleDelegation] = function()
			arg0_11.slotData = arg0_11:HandDelegationData()
		end
	})
end

function var0_0.HandCollectSlotData(arg0_15)
	local var0_15

	if arg0_15.isSelfIsland then
		var0_15 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	else
		var0_15 = getProxy(IslandProxy):GetSharedIsland():GetBuildingAgency()
	end

	local var1_15 = arg0_15.slotId
	local var2_15 = pg.island_production_slot[var1_15].place
	local var3_15 = var0_15:GetBuilding(var2_15)

	if not var3_15 then
		return nil
	end

	local var4_15 = var3_15:GetCollectSlotDatas()

	for iter0_15, iter1_15 in pairs(var4_15) do
		if iter1_15.pos ~= 0 and iter1_15.pos == arg0_15.id then
			return iter1_15
		end
	end

	local var5_15 = var3_15:GetCollectSlotData(var1_15)

	if var5_15 then
		return var5_15
	end
end

function var0_0.HandPlantSlotData(arg0_16)
	local var0_16

	if arg0_16.isSelfIsland then
		var0_16 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	else
		var0_16 = getProxy(IslandProxy):GetSharedIsland():GetBuildingAgency()
	end

	local var1_16 = arg0_16.slotId
	local var2_16 = pg.island_production_slot[var1_16].place
	local var3_16 = var0_16:GetBuilding(var2_16)

	if not var3_16 then
		return nil
	end

	local var4_16 = var3_16:GetHandPlantSlotData(var1_16)

	if var4_16 then
		return var4_16
	end

	return nil
end

function var0_0.HandDelegationData(arg0_17)
	local var0_17

	if arg0_17.isSelfIsland then
		var0_17 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	else
		var0_17 = getProxy(IslandProxy):GetSharedIsland():GetBuildingAgency()
	end

	local var1_17 = arg0_17.slotId
	local var2_17 = pg.island_production_slot[var1_17].exclusion_slot[1]
	local var3_17 = pg.island_production_slot[var1_17].place
	local var4_17 = var0_17:GetBuilding(var3_17)

	if not var4_17 then
		return nil
	end

	local var5_17 = var4_17:GetDelegationSlotData(var2_17)

	if var5_17 then
		return var5_17
	end

	return nil
end

function var0_0.SetHighLight(arg0_18, arg1_18)
	arg0_18.isHighLight = arg1_18
end

function var0_0.GetHighLight(arg0_19, arg1_19)
	return arg0_19.isHighLight
end

return var0_0
