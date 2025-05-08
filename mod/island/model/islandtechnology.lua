local var0_0 = class("IslandTechnology", import("model.vo.BaseVO"))

var0_0.STATUS = {
	NORMAL = "normal",
	FINISHED = "finished",
	LOCK = "lock",
	UNLOCK = "unlock",
	STUDYING = "studying",
	RECEIVE = "receive"
}
var0_0.UNLCOK_TYPE = {
	FINISH_TASK = 1,
	EXIST_ABILITY = 2
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg1_1
	arg0_1.finishedCnt = arg2_1 or 0
end

function var0_0.SetFinishedCnt(arg0_2, arg1_2)
	arg0_2.finishedCnt = arg1_2
end

function var0_0.AddFinishedCnt(arg0_3)
	arg0_3.finishedCnt = arg0_3.finishedCnt + 1
end

function var0_0.GetFinishedCnt(arg0_4)
	return arg0_4.finishedCnt
end

function var0_0.bindConfigTable(arg0_5)
	return pg.island_technology_template
end

function var0_0.IsAutoType(arg0_6)
	return arg0_6:getConfig("auto_finish") == 0
end

function var0_0.CheckFinishImmd(arg0_7)
	return arg0_7:IsUnlock() and arg0_7:IsAutoType() and arg0_7.finishedCnt == 0
end

function var0_0.GetFormulaId(arg0_8)
	return arg0_8:getConfig("formula_id")
end

function var0_0.IsOnceType(arg0_9)
	return arg0_9:getConfig("tech_repeat")[1] == 0
end

function var0_0.IsNoLimitType(arg0_10)
	return not arg0_10:IsOnceType() and arg0_10:getConfig("tech_repeat")[2] == 0
end

function var0_0.GetMaxFinishedCnt(arg0_11)
	return arg0_11:IsOnceType() and 1 or arg0_11:getConfig("tech_repeat")[2]
end

function var0_0.CheckRemainCnt(arg0_12)
	return arg0_12:IsNoLimitType() or arg0_12:GetMaxFinishedCnt() - arg0_12.finishedCnt > 0
end

function var0_0.GetAbilityId(arg0_13)
	return pg.island_formula[arg0_13:GetFormulaId()].unlock_type
end

function var0_0.IsUnlock(arg0_14)
	local var0_14 = arg0_14:GetAbilityId()

	return var0_14 == 0 or getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_14)
end

function var0_0.GetRecycleItemInfos(arg0_15)
	local var0_15 = {}

	underscore.each(arg0_15:getConfig("item_unlock"), function(arg0_16)
		table.insert(var0_15, Drop.New({
			type = DROP_TYPE_ISLAND_ITEM,
			id = arg0_16[1],
			count = arg0_16[2]
		}))
	end)

	return var0_15
end

function var0_0.CanUnlock(arg0_17)
	if getProxy(IslandProxy):GetIsland():GetLevel() < arg0_17:getConfig("island_level") then
		return false
	end

	local var0_17 = arg0_17:GetRecycleItemInfos()

	if underscore.any(var0_17, function(arg0_18)
		return getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(arg0_18.id) < arg0_18.count
	end) then
		return false
	end

	local var1_17 = arg0_17:getConfig("sys_unlock")

	if var1_17 == "" or #var1_17 == 0 then
		return true
	end

	return underscore.all(var1_17, function(arg0_19)
		return arg0_17:MatchCondition(arg0_19)
	end)
end

function var0_0.MatchCondition(arg0_20, arg1_20)
	local var0_20 = arg1_20[1]
	local var1_20 = arg1_20[2]

	return switch(var0_20, {
		[var0_0.UNLCOK_TYPE.FINISH_TASK] = function()
			return getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var1_20)
		end,
		[var0_0.UNLCOK_TYPE.EXIST_ABILITY] = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var1_20)
		end
	}, function()
		return false
	end)
end

function var0_0.GetStatus(arg0_24)
	if not arg0_24:IsUnlock() then
		return arg0_24:CanUnlock() and var0_0.STATUS.UNLOCK or var0_0.STATUS.LOCK
	end

	local var0_24 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetDelegationSlotDataByTechId(arg0_24.id)

	if var0_24 then
		return var0_24:GetSlotRewardData() and var0_0.STATUS.RECEIVE or var0_0.STATUS.STUDYING
	else
		return arg0_24:CheckRemainCnt() and var0_0.STATUS.NORMAL or var0_0.STATUS.FINISHED
	end
end

function var0_0.GetSlotId(arg0_25)
	local var0_25 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetDelegationSlotDataByTechId(arg0_25.id)

	return var0_25 and var0_25.id
end

return var0_0
