local var0_0 = class("IslandRoleDelegationSlot", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.buildId = arg1_1
	arg0_1.id = arg2_1.id
	arg0_1.part_num = arg2_1.part_num
	arg0_1.formula_dic = {}

	for iter0_1, iter1_1 in ipairs(arg2_1.formula_list or {}) do
		arg0_1.formula_dic[iter1_1.id] = iter1_1.num
	end
end

function var0_0.GetFormulaId(arg0_2)
	return arg0_2.islandRoleDelegationData and arg0_2.islandRoleDelegationData.formula_id or arg0_2.islandRoleDelegationReward and arg0_2.islandRoleDelegationReward.formula_id
end

function var0_0.ResetFormulaNum(arg0_3, arg1_3)
	arg0_3.formula_dic[arg1_3.formula_id] = arg1_3.num
end

function var0_0.GetFromulaTatalCount(arg0_4, arg1_4)
	return arg0_4.formula_dic[arg1_4] or 0
end

function var0_0.bindConfigTable(arg0_5)
	return pg.island_production_slot
end

function var0_0.UpdateSlotRoleData(arg0_6, arg1_6)
	if arg1_6 then
		if arg0_6.islandRoleDelegationData then
			arg0_6.islandRoleDelegationData:UpdateData(arg1_6)
		else
			arg0_6.islandRoleDelegationData = IslandRoleDelegationData.New(arg1_6)
		end
	else
		arg0_6.islandRoleDelegationData = nil
	end
end

function var0_0.UpdateSlotRewardData(arg0_7, arg1_7)
	if arg1_7 then
		if arg0_7.islandRoleDelegationReward then
			arg0_7.islandRoleDelegationReward:UpdateData(arg1_7)
		else
			arg0_7.islandRoleDelegationReward = IslandRoleDelegationReward.New(arg1_7)
		end
	else
		arg0_7.islandRoleDelegationReward = nil
	end
end

function var0_0.GetSlotRoleData(arg0_8)
	return arg0_8.islandRoleDelegationData
end

function var0_0.GetSlotRewardData(arg0_9)
	return arg0_9.islandRoleDelegationReward
end

function var0_0.CanStartDelegation(arg0_10)
	return arg0_10.islandRoleDelegationData == nil and arg0_10.islandRoleDelegationReward == nil
end

function var0_0.Clear(arg0_11)
	return
end

function var0_0.UpdatePerSecond(arg0_12)
	if not arg0_12.islandRoleDelegationData then
		return
	end

	if arg0_12.islandRoleDelegationData:CheckDelegationIsEnd() then
		pg.m02:sendNotification(GAME.ISLAND_FINISH_DELEGATION, {
			build_id = arg0_12.buildId,
			area_id = arg0_12.id
		})
		arg0_12.islandRoleDelegationData:SetIsSend(true)
	end
end

function var0_0.GetRoleDelegateFinishTime(arg0_13)
	if arg0_13.islandRoleDelegationReward then
		return 0
	end

	if arg0_13.islandRoleDelegationData then
		return arg0_13.islandRoleDelegationData:GetFinishTime()
	end

	return -1
end

function var0_0.GetRoleShipData(arg0_14)
	if arg0_14.islandRoleDelegationData then
		return {
			ship_id = arg0_14.islandRoleDelegationData.ship_id,
			area_id = arg0_14.id
		}
	end

	return nil
end

return var0_0
