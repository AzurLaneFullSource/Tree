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

	arg0_1.handSlotData = {}

	for iter6_1, iter7_1 in ipairs(arg1_1.hand_list or {}) do
		arg0_1.handSlotData[iter7_1.id] = IslandHandSlot.New(arg0_1.configId, iter7_1)
	end

	if arg1_1.build_collect then
		arg0_1.collectPlaceSystem = IslandCollectSlotPlace.New(arg1_1.id, arg1_1.build_collect)
	end
end

function var0_0.GetBuildingCollectData(arg0_2)
	return arg0_2.collectPlaceSystem
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_production_place
end

function var0_0.GetDelegationSlotData(arg0_4, arg1_4)
	return arg0_4.delegationSlotData[arg1_4]
end

function var0_0.GetDelegationSlotDatas(arg0_5)
	return arg0_5.delegationSlotData
end

function var0_0.GetDelegationSlotDataByFormulaId(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.delegationSlotData) do
		if iter1_6:GetFormulaId() and iter1_6:GetFormulaId() == arg1_6 then
			return iter1_6
		end
	end

	return nil
end

function var0_0.GetHandPlantSlotData(arg0_7, arg1_7)
	return arg0_7.handSlotData[arg1_7]
end

function var0_0.InitSlotRoleDataByAbility(arg0_8, arg1_8)
	local var0_8 = pg.island_production_slot[arg1_8]

	if arg0_8.delegationSlotData[arg1_8] then
		warning("已经存在当前槽位的信息了")

		return
	end

	local var1_8 = {}
	local var2_8 = getProxy(IslandProxy):GetIsland()

	if var0_8.type == 3 then
		local var3_8 = var0_8.animal == "" and {} or var0_8.animal

		for iter0_8, iter1_8 in ipairs(var3_8) do
			if pg.island_ranch_animal[iter1_8].unlock_type == 0 then
				table.insert(var1_8, iter1_8)
			end
		end

		var2_8:DispatchEvent(IslandBuildingAgency.GEN_ANIMAL_INT, {
			aniList = var1_8,
			slotId = arg1_8
		})
	end

	if var0_8.type == 9 then
		var2_8:DispatchEvent(IslandBuildingAgency.SLOT_DELEGATE_INIT, {
			slotId = arg1_8
		})
	end

	arg0_8.delegationSlotData[arg1_8] = IslandRoleDelegationSlot.New(arg0_8.configId, {
		id = arg1_8,
		part_list = var1_8,
		formula_list = {}
	}, true)
end

function var0_0.InitSlotHandPlantByAbility(arg0_9, arg1_9)
	local var0_9 = pg.island_production_slot[arg1_9]

	if arg0_9.handSlotData[arg1_9] then
		warning("已经存在当前槽位的信息了")

		return
	end

	arg0_9.handSlotData[arg1_9] = IslandHandSlot.New(arg1_9, {
		formula_id = 0,
		start_time = 0,
		end_time = 0,
		state = 0,
		id = arg1_9
	})
end

function var0_0.InitHandSlotData(arg0_10, arg1_10)
	if arg0_10.collectPlaceSystem then
		arg0_10.collectPlaceSystem:InitHandSlotData(arg1_10)
	end
end

function var0_0.UpdateDeleationRoleDataBySlotId(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:GetDelegationSlotData(arg1_11)

	if not var0_11 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_11)

		return
	end

	var0_11:UpdateSlotRoleData(arg2_11)
end

function var0_0.UpdateDeleationRewardDataBySlotId(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12:GetDelegationSlotData(arg1_12)

	if not var0_12 then
		warning("下发数据有问题,下发的槽位id不是当前区域能委派的槽位,下发的槽位id为" .. arg1_12)

		return
	end

	var0_12:UpdateSlotRewardData(arg2_12)
end

function var0_0.GetShipAddExpData(arg0_13, arg1_13)
	local var0_13
	local var1_13 = arg0_13:GetDelegationSlotData(arg1_13):GetSlotRewardData()

	if var1_13 then
		var0_13 = {
			addShipId = var1_13.ship_id,
			addExp = var1_13.exp
		}
	end

	return var0_13
end

function var0_0.UpdateCollectDataBySlotId(arg0_14, arg1_14, arg2_14)
	if arg0_14.collectPlaceSystem then
		arg0_14.collectPlaceSystem:UpdateCollectDataBySlotId(arg1_14, arg2_14)
	end
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

	if arg0_20.collectPlaceSystem then
		arg0_20.collectPlaceSystem:UpdatePerSecond()
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

function var0_0.GetDelegateingSlotAndFormulaList(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.delegationSlotData) do
		local var1_24 = iter1_24:GetRoleSlotAndFormulaData()

		if var1_24 then
			table.insert(var0_24, var1_24)
		end
	end

	return var0_24
end

function var0_0.IsPostTip(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.delegationSlotData) do
		if iter1_25:CanStartDelegationTip() or iter1_25:GetSlotRewardData() then
			return true
		end
	end

	return false
end

function var0_0.GetCollectSlotData(arg0_26, arg1_26)
	if arg0_26.collectPlaceSystem then
		return arg0_26.collectPlaceSystem:GetCollectSlotData(arg1_26)
	end
end

return var0_0
