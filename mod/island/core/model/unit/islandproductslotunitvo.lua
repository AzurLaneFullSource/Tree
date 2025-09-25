local var0_0 = class("IslandProductSlotUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.slotId = arg1_1.slotId
	arg0_1.isSelfIsland = arg1_1.isSelfIsland

	arg0_1:ChangeSlotType(arg1_1.slotType)
	arg0_1:StartPlantGrowthTime(arg1_1.formula_id)
end

function var0_0.ChangeSlotType(arg0_2, arg1_2)
	arg0_2.slotType = arg1_2

	arg0_2:BindSlotData()
	arg0_2:InitGrowthEndTime()
end

function var0_0.InitGrowthEndTime(arg0_3)
	if not arg0_3.slotData then
		return
	end

	switch(arg0_3.slotType, {
		[IslandProductConst.ProductSlotType.HandPlant] = function()
			arg0_3.logic_startTime = arg0_3.slotData.start_time
			arg0_3.end_time = arg0_3.slotData.end_time
		end,
		[IslandProductConst.ProductSlotType.RoleDelegation] = function()
			local var0_5 = arg0_3.slotData:GetSlotRoleData()

			if var0_5 then
				arg0_3.logic_startTime = var0_5.start_time
				arg0_3.end_time = arg0_3.logic_startTime + var0_5.cost_time_list[1]
			else
				arg0_3.logic_startTime = pg.TimeMgr.GetInstance():GetServerTime()
				arg0_3.end_time = arg0_3.logic_startTime
			end
		end
	})
end

function var0_0.GetEndProductEndTime(arg0_6)
	if not arg0_6.slotData then
		return
	end

	if arg0_6.slotType == IslandProductConst.ProductSlotType.HandPlant then
		return arg0_6.slotData.end_time
	else
		return arg0_6.slotData.end_time
	end
end

function var0_0.StartPlantGrowthTime(arg0_7, arg1_7, arg2_7)
	arg0_7.formula_id = arg1_7

	if not arg0_7.formula_id then
		arg0_7.productProcess = {}

		return
	end

	arg0_7.startGrowthTime = arg2_7 or arg0_7.logic_startTime

	local var0_7 = pg.island_formula[arg0_7.formula_id].unitid

	arg0_7.productProcess = {}

	local var1_7 = arg0_7.end_time - arg0_7.startGrowthTime

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var2_7 = math.floor(iter1_7[1] * var1_7) + arg0_7.startGrowthTime
		local var3_7 = iter1_7[2]

		table.insert(arg0_7.productProcess, {
			startTime = var2_7,
			model = var3_7
		})
	end
end

function var0_0.StartDelegateSlotPerform(arg0_8)
	local var0_8 = arg0_8.slotData:GetFormulaId()

	arg0_8:StartPlantGrowthTime(var0_8, pg.TimeMgr.GetInstance():GetServerTime())
end

function var0_0.BindSlotData(arg0_9)
	switch(arg0_9.slotType, {
		[IslandProductConst.ProductSlotType.HandPlant] = function()
			arg0_9.slotData = arg0_9:HandPlantSlotData()
		end,
		[IslandProductConst.ProductSlotType.RoleDelegation] = function()
			arg0_9.slotData = arg0_9:HandDelegationData()
		end
	})
end

function var0_0.GetProductProcess(arg0_12)
	return arg0_12.productProcess
end

function var0_0.HandPlantSlotData(arg0_13)
	local var0_13

	if arg0_13.isSelfIsland then
		var0_13 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	else
		var0_13 = getProxy(IslandProxy):GetSharedIsland():GetBuildingAgency()
	end

	local var1_13 = arg0_13.slotId
	local var2_13 = pg.island_production_slot[var1_13].place
	local var3_13 = var0_13:GetBuilding(var2_13)

	if not var3_13 then
		return nil
	end

	local var4_13 = var3_13:GetHandPlantSlotData(var1_13)

	if var4_13 then
		return var4_13
	end

	return nil
end

function var0_0.HandDelegationData(arg0_14)
	local var0_14

	if arg0_14.isSelfIsland then
		var0_14 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	else
		var0_14 = getProxy(IslandProxy):GetSharedIsland():GetBuildingAgency()
	end

	local var1_14 = arg0_14.slotId
	local var2_14 = pg.island_production_slot[var1_14].exclusion_slot[1]
	local var3_14 = pg.island_production_slot[var1_14].place
	local var4_14 = var0_14:GetBuilding(var3_14)

	if not var4_14 then
		return nil
	end

	local var5_14 = var4_14:GetDelegationSlotData(var2_14)

	if var5_14 then
		return var5_14
	end

	return nil
end

function var0_0.SetHighLight(arg0_15, arg1_15)
	arg0_15.isHighLight = arg1_15
end

function var0_0.GetHighLight(arg0_16, arg1_16)
	return arg0_16.isHighLight
end

return var0_0
