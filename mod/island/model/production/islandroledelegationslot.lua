local var0_0 = class("IslandRoleDelegationSlot", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.buildId = arg1_1
	arg0_1.id = arg2_1.id
	arg0_1.part_list = {}

	for iter0_1, iter1_1 in ipairs(arg2_1.part_list) do
		table.insert(arg0_1.part_list, iter1_1)
	end

	arg0_1.formula_dic = {}

	for iter2_1, iter3_1 in ipairs(arg2_1.formula_list or {}) do
		arg0_1.formula_dic[iter3_1.id] = iter3_1.num
	end

	arg0_1.isSelf = arg3_1
end

function var0_0.AddAnimal(arg0_2, arg1_2)
	table.insert(arg0_2.part_list, arg1_2)
end

function var0_0.GetFormulaId(arg0_3)
	return arg0_3.islandRoleDelegationData and arg0_3.islandRoleDelegationData.formula_id or arg0_3.islandRoleDelegationReward and arg0_3.islandRoleDelegationReward.formula_id
end

function var0_0.AddFormulaNum(arg0_4, arg1_4)
	local var0_4 = arg0_4.formula_dic[arg1_4.formula_id] or 0

	arg0_4.formula_dic[arg1_4.formula_id] = var0_4 + arg1_4.num
end

function var0_0.GetFromulaTatalCount(arg0_5, arg1_5)
	return arg0_5.formula_dic[arg1_5] or 0
end

function var0_0.bindConfigTable(arg0_6)
	return pg.island_production_slot
end

function var0_0.UpdateSlotRoleData(arg0_7, arg1_7)
	if arg1_7 then
		if arg0_7.islandRoleDelegationData then
			arg0_7.islandRoleDelegationData:UpdateData(arg1_7)
		else
			arg0_7.islandRoleDelegationData = IslandRoleDelegationData.New(arg1_7)
		end
	else
		arg0_7.islandRoleDelegationData = nil
	end
end

function var0_0.UpdateSlotRewardData(arg0_8, arg1_8)
	if arg1_8 then
		if arg0_8.islandRoleDelegationReward then
			arg0_8.islandRoleDelegationReward:UpdateData(arg1_8)
		else
			arg0_8.islandRoleDelegationReward = IslandRoleDelegationReward.New(arg1_8)
		end
	else
		arg0_8.islandRoleDelegationReward = nil
	end
end

function var0_0.GetSlotRoleData(arg0_9)
	return arg0_9.islandRoleDelegationData
end

function var0_0.GetSlotRewardData(arg0_10)
	return arg0_10.islandRoleDelegationReward
end

function var0_0.CanStartDelegation(arg0_11)
	return arg0_11.islandRoleDelegationData == nil and arg0_11.islandRoleDelegationReward == nil
end

function var0_0.Clear(arg0_12)
	return
end

function var0_0.UpdatePerSecond(arg0_13)
	if not arg0_13.islandRoleDelegationData then
		return
	end

	if arg0_13.islandRoleDelegationData:CheckDelegationIsEnd() then
		if arg0_13.isSelf then
			pg.m02:sendNotification(GAME.ISLAND_FINISH_DELEGATION, {
				build_id = arg0_13.buildId,
				area_id = arg0_13.id
			})
			arg0_13.islandRoleDelegationData:SetIsSend(true)
		else
			local var0_13 = getProxy(IslandProxy):GetSharedIsland()
			local var1_13 = var0_13:GetBuildingAgency():GetBuilding(arg0_13.buildId)
			local var2_13 = arg0_13.islandRoleDelegationData.formula_id
			local var3_13 = arg0_13.islandRoleDelegationData.ship_id

			var1_13:UpdateDeleationRewardDataBySlotId(arg0_13.id, {
				formula_id = var2_13
			})
			var1_13:UpdateDeleationRoleDataBySlotId(arg0_13.id, nil)
			var0_13:DispatchEvent(IslandFinishDelegationCommand.END_DELEGATION, {
				remainReward = true,
				build_id = arg0_13.buildId,
				ship_id = var3_13,
				area_id = arg0_13.id
			})
		end
	end
end

function var0_0.GetRoleDelegateFinishTime(arg0_14)
	if arg0_14.islandRoleDelegationReward then
		return 0
	end

	if arg0_14.islandRoleDelegationData then
		return arg0_14.islandRoleDelegationData:GetFinishTime()
	end

	return -1
end

function var0_0.GetRoleShipData(arg0_15)
	if arg0_15.islandRoleDelegationData then
		return {
			ship_id = arg0_15.islandRoleDelegationData.ship_id,
			area_id = arg0_15.id
		}
	end

	return nil
end

function var0_0.GetPartList(arg0_16)
	return arg0_16.part_list or {}
end

return var0_0
