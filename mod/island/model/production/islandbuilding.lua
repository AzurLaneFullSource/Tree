local var0_0 = class("IslandBuilding", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.timer = {}
	arg0_1.configId = arg1_1.id
	arg0_1.level = arg1_1.lv or 1
	arg0_1.delegationSlotData = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.appoint_list or {}) do
		arg0_1.delegationSlotData[iter1_1.id] = IslandRoleDelegationSlot.New(arg0_1.configId, iter1_1)
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
		arg0_1.handSlotData[iter9_1.id] = IslandHandSlot.New(iter9_1)
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_production_place
end

function var0_0.GetDelegationSlotData(arg0_3, arg1_3)
	return arg0_3.delegationSlotData[arg1_3]
end

function var0_0.GetDelegationSlotDataByFormulaId(arg0_4, arg1_4)
	for iter0_4, iter1_4 in pairs(arg0_4.delegationSlotData) do
		if iter1_4:GetFormulaId() and iter1_4:GetFormulaId() == arg1_4 then
			return iter1_4
		end
	end

	return nil
end

function var0_0.GetCollectSlotData(arg0_5, arg1_5)
	return arg0_5.collectionSlotData[arg1_5]
end

function var0_0.GetHandPlantSlotData(arg0_6, arg1_6)
	return arg0_6.handSlotData[arg1_6]
end

function var0_0.InitSlotRoleDataByAbility(arg0_7, arg1_7)
	if pg.island_production_slot[arg1_7].type ~= 9 then
		return
	end

	if arg0_7.delegationSlotData[arg1_7] then
		warning("已经存在当前槽位的信息了")

		return
	end

	arg0_7.delegationSlotData[arg1_7] = IslandRoleDelegationSlot.New(arg0_7.id, {
		part_num = 0,
		id = arg1_7,
		formula_list = {}
	})
end

function var0_0.UpdateDeleationRoleDataBySlotId(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8:GetDelegationSlotData(arg1_8)

	if not var0_8 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_8)

		return
	end

	var0_8:UpdateSlotRoleData(arg2_8)
end

function var0_0.UpdateDeleationRewardDataBySlotId(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetDelegationSlotData(arg1_9)

	if not var0_9 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_9)

		return
	end

	var0_9:UpdateSlotRewardData(arg2_9)
end

function var0_0.UpdateCollectDataBySlotId(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetCollectSlotData(arg1_10.id)

	if not var0_10 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_10.id)

		return
	end

	local var1_10 = getProxy(IslandProxy):GetIsland()
	local var2_10 = var0_10.pos

	if arg1_10.pos ~= var2_10 then
		if var2_10 then
			var1_10:DispatchEvent(IslandBuildingAgency.SLOT_UNIT_REMOVE, {
				unitId = var2_10
			})
		end

		local var3_10 = arg0_10.timer[arg1_10.pos]

		if var3_10 then
			var3_10:Stop()
		end

		arg0_10.timer[arg1_10.pos] = Timer.New(function()
			var1_10:DispatchEvent(IslandBuildingAgency.SLOT_STATE_CHANGE, {
				modelId = 1004,
				unitId = arg1_10.pos
			})
		end, 60, 0)

		arg0_10.timer[arg1_10.pos]:Start()
	end

	var0_10:UpdateData(arg1_10)
end

function var0_0.UpdateHandPlantDataBySlotId(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetHandPlantSlotData(arg1_12.id)

	if not var0_12 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_12.id)

		return
	end

	var0_12:UpdateData(arg1_12)
end

function var0_0.GetFormulaList(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in pairs(arg0_13.formulaData) do
		table.insert(var0_13, iter1_13)
	end

	return var0_13
end

function var0_0.GetLevel(arg0_14)
	return arg0_14.level
end

function var0_0.IsMaxLevel(arg0_15)
	return arg0_15:GetUpgradeCost() == ""
end

function var0_0.GetName(arg0_16)
	return arg0_16:getConfig("name")
end

function var0_0.UpdatePerSecond(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.delegationSlotData) do
		iter1_17:UpdatePerSecond()
	end
end

function var0_0.GetSlotUnitDataByModelData(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in pairs(arg0_18.collectionSlotData) do
		table.insert(var0_18, iter1_18:GetUnitData())
	end

	return var0_18
end

function var0_0.GetCheckWorldIdByModelData(arg0_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in pairs(arg0_19.collectionSlotData) do
		table.insert(var0_19, iter1_19)
	end

	return var0_19
end

function var0_0.GetMinRoleDeleGationTime(arg0_20)
	local var0_20

	for iter0_20, iter1_20 in pairs(arg0_20.delegationSlotData) do
		local var1_20 = iter1_20:GetRoleDelegateFinishTime()

		if var1_20 ~= -1 then
			var0_20 = var0_20 and math.min(var1_20, var0_20) or var1_20
		end
	end

	return var0_20 and var0_20 or -1
end

function var0_0.GetShipIdAndAreaIdList(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in pairs(arg0_21.delegationSlotData) do
		local var1_21 = iter1_21:GetRoleShipData()

		if var1_21 then
			table.insert(var0_21, var1_21)
		end
	end

	return var0_21
end

return var0_0
