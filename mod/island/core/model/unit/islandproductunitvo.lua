local var0_0 = class("IslandProductUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	if arg1_1.productType == 1 then
		arg0_1.slotData = arg0_1:HandPlantSlotData(arg1_1)
		arg0_1.end_time = arg0_1.slotData.end_time
		arg0_1.start_time = arg0_1.slotData.start_time
	end

	arg0_1.formuluaId = arg1_1.formuluaId
	arg0_1.unitList = pg.island_formula[arg1_1.formuluaId].unitid

	local var0_1

	if #arg0_1.unitList > 1 then
		local var1_1 = pg.TimeMgr.GetInstance():GetServerTime()
		local var2_1 = math.min(1, (var1_1 - arg0_1.start_time) / (arg0_1.end_time - arg0_1.start_time))

		var2_1 = var2_1 < 0 and 0 or var2_1

		for iter0_1, iter1_1 in ipairs(arg0_1.unitList) do
			if var2_1 >= iter1_1[1] then
				var0_1 = iter1_1[2]
				arg0_1.process = iter1_1[1]
			end
		end
	else
		var0_1 = unitList[1][1]
	end

	arg1_1.modelId = var0_1

	var0_0.super.Ctor(arg0_1, arg1_1)
end

function var0_0.HandPlantSlotData(arg0_2, arg1_2)
	local var0_2 = 1001
	local var1_2 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var2_2 = arg1_2.slotId

	for iter0_2, iter1_2 in pairs(var1_2:GetBuildingListByMap(var0_2)) do
		local var3_2 = iter1_2:GetHandPlantSlotData(var2_2)

		if var3_2 then
			return var3_2
		end
	end

	return nil
end

function var0_0.ChangeModel(arg0_3)
	local var0_3

	if #arg0_3.unitList > 1 then
		local var1_3 = pg.TimeMgr.GetInstance():GetServerTime()
		local var2_3 = math.min(1, (var1_3 - arg0_3.start_time) / (arg0_3.end_time - arg0_3.start_time))

		var2_3 = var2_3 < 0 and 0 or var2_3

		local var3_3

		for iter0_3, iter1_3 in ipairs(arg0_3.unitList) do
			if var2_3 >= iter1_3[1] then
				var0_3 = iter1_3[2]
				var3_3 = iter1_3[1]
			end
		end

		if var3_3 ~= arg0_3.process then
			arg0_3.process = var3_3
			arg0_3.modelId = var0_3

			return true
		end

		return false
	end

	return false
end

return var0_0
