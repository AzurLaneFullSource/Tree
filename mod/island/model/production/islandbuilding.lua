local var0_0 = class("IslandBuilding", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.isSelf = arg2_1
	arg0_1.timer = {}
	arg0_1.configId = arg1_1.id
	arg0_1.level = arg1_1.lv or 1
	arg0_1.delegationSlotData = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.appoint_list or {}) do
		arg0_1.delegationSlotData[iter1_1.id] = IslandRoleDelegationSlot.New(arg0_1.configId, iter1_1, arg0_1.isSelf)
	end

	for iter2_1, iter3_1 in ipairs(arg1_1.ship_appoint_list or {}) do
		arg0_1:UpdateDeleationRoleDataBySlotId(iter3_1.id, iter3_1)
	end

	for iter4_1, iter5_1 in ipairs(arg1_1.award_list or {}) do
		arg0_1:UpdateDeleationRewardDataBySlotId(iter5_1.id, iter5_1)
	end

	arg0_1.collectionSlotData = {}

	for iter6_1, iter7_1 in ipairs(arg1_1.collect_list or {}) do
		arg0_1.collectionSlotData[iter7_1.id] = IslandCollectSlot.New(arg0_1.configId, iter7_1)
	end

	arg0_1.handSlotData = {}

	for iter8_1, iter9_1 in ipairs(arg1_1.hand_list or {}) do
		arg0_1.handSlotData[iter9_1.id] = IslandHandSlot.New(arg0_1.configId, iter9_1)
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_production_place
end

function var0_0.GetDelegationSlotData(arg0_3, arg1_3)
	return arg0_3.delegationSlotData[arg1_3]
end

function var0_0.GetDelegationSlotDatas(arg0_4)
	return arg0_4.delegationSlotData
end

function var0_0.GetDelegationSlotDataByFormulaId(arg0_5, arg1_5)
	for iter0_5, iter1_5 in pairs(arg0_5.delegationSlotData) do
		if iter1_5:GetFormulaId() and iter1_5:GetFormulaId() == arg1_5 then
			return iter1_5
		end
	end

	return nil
end

function var0_0.GetCollectSlotDatas(arg0_6)
	return arg0_6.collectionSlotData
end

function var0_0.GetCollectSlotData(arg0_7, arg1_7)
	return arg0_7.collectionSlotData[arg1_7]
end

function var0_0.GetHandPlantSlotData(arg0_8, arg1_8)
	return arg0_8.handSlotData[arg1_8]
end

function var0_0.InitSlotRoleDataByAbility(arg0_9, arg1_9)
	local var0_9 = pg.island_production_slot[arg1_9]

	if arg0_9.delegationSlotData[arg1_9] then
		warning("已经存在当前槽位的信息了")

		return
	end

	local var1_9 = {}

	if var0_9.type == 3 then
		local var2_9 = var0_9.animal == "" and {} or var0_9.animal

		for iter0_9, iter1_9 in ipairs(var2_9) do
			if pg.island_ranch_animal[iter1_9].unlock_type == 0 then
				table.insert(var1_9, iter1_9)
			end
		end

		getProxy(IslandProxy):GetIsland():DispatchEvent(IslandBuildingAgency.GEN_ANIMAL_INT, {
			aniList = var1_9,
			slotId = arg1_9
		})
	end

	arg0_9.delegationSlotData[arg1_9] = IslandRoleDelegationSlot.New(arg0_9.configId, {
		id = arg1_9,
		part_list = var1_9,
		formula_list = {}
	}, true)
end

function var0_0.InitSlotHandPlantByAbility(arg0_10, arg1_10)
	local var0_10 = pg.island_production_slot[arg1_10]

	if arg0_10.handSlotData[arg1_10] then
		warning("已经存在当前槽位的信息了")

		return
	end

	arg0_10.handSlotData[arg1_10] = IslandHandSlot.New(arg1_10, {
		formula_id = 0,
		start_time = 0,
		end_time = 0,
		state = 0,
		id = arg1_10
	})
end

function var0_0.InitHandSlotData(arg0_11, arg1_11)
	if arg0_11.collectionSlotData[arg1_11.id] then
		warning("已经存在当前槽位的信息了")

		return
	end

	local var0_11 = IslandCollectSlot.New(arg0_11.configId, arg1_11)

	arg0_11.collectionSlotData[arg1_11.id] = var0_11

	var0_11:SetNeedLoadModel()
end

function var0_0.UpdateDeleationRoleDataBySlotId(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12:GetDelegationSlotData(arg1_12)

	if not var0_12 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_12)

		return
	end

	var0_12:UpdateSlotRoleData(arg2_12)
end

function var0_0.UpdateDeleationRewardDataBySlotId(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13:GetDelegationSlotData(arg1_13)

	if not var0_13 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_13)

		return
	end

	var0_13:UpdateSlotRewardData(arg2_13)
end

function var0_0.UpdateCollectDataBySlotId(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14:GetCollectSlotData(arg1_14.id)

	if not var0_14 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_14.id)

		return
	end

	var0_14:UpdateCollectData(arg1_14, arg2_14)
end

function var0_0.UpdateHandPlantDataBySlotId(arg0_15, arg1_15)
	local var0_15 = arg0_15:GetHandPlantSlotData(arg1_15.id)

	if not var0_15 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_15.id)

		return
	end

	var0_15:UpdateData(arg1_15)
end

function var0_0.GetFormulaList(arg0_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in pairs(arg0_16.formulaData) do
		table.insert(var0_16, iter1_16)
	end

	return var0_16
end

function var0_0.GetLevel(arg0_17)
	return arg0_17.level
end

function var0_0.IsMaxLevel(arg0_18)
	return arg0_18:GetUpgradeCost() == ""
end

function var0_0.GetName(arg0_19)
	return arg0_19:getConfig("name")
end

function var0_0.UpdatePerSecond(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.delegationSlotData) do
		iter1_20:UpdatePerSecond(arg0_20.isSelf)
	end

	for iter2_20, iter3_20 in pairs(arg0_20.collectionSlotData) do
		iter3_20:UpdatePerSecond()
	end
end

function var0_0.GetSlotUnitDataByModelData(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in pairs(arg0_21.collectionSlotData) do
		local var1_21 = iter1_21:GetUnitData()

		if var1_21 then
			table.insert(var0_21, var1_21)
		end
	end

	return var0_21
end

function var0_0.GetMinRoleDeleGationTime(arg0_22)
	local var0_22

	for iter0_22, iter1_22 in pairs(arg0_22.delegationSlotData) do
		local var1_22 = iter1_22:GetRoleDelegateFinishTime()

		if var1_22 ~= -1 then
			var0_22 = var0_22 and math.min(var1_22, var0_22) or var1_22
		end
	end

	return var0_22 and var0_22 or -1
end

function var0_0.GetShipIdAndAreaIdList(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in pairs(arg0_23.delegationSlotData) do
		local var1_23 = iter1_23:GetRoleShipData()

		if var1_23 then
			table.insert(var0_23, var1_23)
		end
	end

	return var0_23
end

return var0_0
