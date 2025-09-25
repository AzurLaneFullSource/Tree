local var0_0 = class("IslandTechnology", import("model.vo.BaseVO"))

var0_0.STATUS = {
	NORMAL = "normal",
	FINISHED = "finished",
	LOCK = "lock",
	UNLOCK = "unlock",
	STUDYING = "studying",
	RECEIVE = "receive"
}
var0_0.UNLOCK_TYPE = {
	FINISH_TASK = 1,
	LEVEL = 0,
	EXIST_ABILITY = 2,
	FINISH_TECHNOLOGY = 3
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

	if arg0_3.finishedCnt == 1 then
		IslandAchievementHelper.OnFinishTechnolog(arg0_3.id)
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.TECHNOLOGY)
	end
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

function var0_0.GetCostItems(arg0_15)
	local var0_15 = {}

	underscore.each(pg.island_formula[arg0_15:GetFormulaId()].commission_cost, function(arg0_16)
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

	local var0_17 = arg0_17:getConfig("sys_unlock")

	if var0_17 == "" or #var0_17 == 0 then
		return true
	end

	return underscore.all(var0_17, function(arg0_18)
		return arg0_17:MatchCondition(arg0_18)
	end)
end

function var0_0.MatchCondition(arg0_19, arg1_19)
	local var0_19 = arg1_19[1]
	local var1_19 = arg1_19[2]

	return switch(var0_19, {
		[var0_0.UNLOCK_TYPE.LEVEL] = function()
			return getProxy(IslandProxy):GetIsland():GetLevel() >= arg0_19:getConfig("island_level")
		end,
		[var0_0.UNLOCK_TYPE.FINISH_TASK] = function()
			return getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var1_19)
		end,
		[var0_0.UNLOCK_TYPE.EXIST_ABILITY] = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var1_19)
		end,
		[var0_0.UNLOCK_TYPE.FINISH_TECHNOLOGY] = function()
			return getProxy(IslandProxy):GetIsland():GetTechnologyAgency():IsFinishedTech(var1_19)
		end
	}, function()
		return false
	end)
end

function var0_0.GetStatus(arg0_25)
	if not arg0_25:IsUnlock() then
		return arg0_25:CanUnlock() and var0_0.STATUS.UNLOCK or var0_0.STATUS.LOCK
	end

	local var0_25 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetDelegationSlotDataByTechId(arg0_25.id)

	if var0_25 then
		return var0_25:GetSlotRewardData() and var0_0.STATUS.RECEIVE or var0_0.STATUS.STUDYING
	else
		return arg0_25:CheckRemainCnt() and var0_0.STATUS.NORMAL or var0_0.STATUS.FINISHED
	end
end

function var0_0.GetSlotId(arg0_26)
	local var0_26 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetDelegationSlotDataByTechId(arg0_26.id)

	return var0_26 and var0_26.id
end

function var0_0.GetUnlockText(arg0_27)
	local var0_27 = arg0_27[1]
	local var1_27 = arg0_27[2]

	return switch(var0_27, {
		[var0_0.UNLOCK_TYPE.LEVEL] = function()
			return i18n("island_tech_unlock_tip0", var1_27)
		end,
		[var0_0.UNLOCK_TYPE.FINISH_TASK] = function()
			return i18n("island_tech_unlock_tip1", pg.island_task[var1_27].name)
		end,
		[var0_0.UNLOCK_TYPE.EXIST_ABILITY] = function()
			return i18n("island_tech_unlock_tip2", pg.island_ability_template[var1_27].unlock_text)
		end,
		[var0_0.UNLOCK_TYPE.FINISH_TECHNOLOGY] = function()
			return i18n("island_tech_unlock_tip3", pg.island_technology_template[var1_27].tech_name)
		end
	})
end

return var0_0
