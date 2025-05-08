local var0_0 = class("IslandFutureTask", import("model.vo.BaseVO"))

var0_0.CONDITION_TYPE = {
	FINISH_TASK = 2,
	IN_TIME = 5,
	EXIST_ABILITY = 3,
	MUTEX_TASK = 4
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.task_id
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_task
end

function var0_0.InTime(arg0_3)
	local var0_3 = arg0_3:getConfig("unlock_condition")

	if var0_3 == "" or #var0_3 == 0 then
		return true
	end

	return underscore.all(var0_3, function(arg0_4)
		return arg0_4[1] ~= var0_0.CONDITION_TYPE.IN_TIME or arg0_4[1] == var0_0.CONDITION_TYPE.IN_TIME and pg.TimeMgr.GetInstance():inTime(arg0_4[2])
	end)
end

function var0_0.IsAcceptImmediately(arg0_5)
	return arg0_5:getConfig("trigger_type") == 2 and arg0_5:getConfig("trigger_data") == 0
end

function var0_0.IsUnlock(arg0_6)
	local var0_6 = arg0_6:getConfig("unlock_condition")

	if var0_6 == "" or #var0_6 == 0 then
		return true
	end

	return underscore.all(var0_6, function(arg0_7)
		return arg0_6:MatchCondition(arg0_7)
	end)
end

function var0_0.MatchCondition(arg0_8, arg1_8)
	local var0_8 = arg1_8[1]
	local var1_8 = arg1_8[2]

	return switch(var0_8, {
		[var0_0.CONDITION_TYPE.FINISH_TASK] = function()
			return getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var1_8)
		end,
		[var0_0.CONDITION_TYPE.EXIST_ABILITY] = function()
			return getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var1_8)
		end,
		[var0_0.CONDITION_TYPE.MUTEX_TASK] = function()
			return not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsPassId(var1_8)
		end,
		[var0_0.CONDITION_TYPE.IN_TIME] = function()
			return pg.TimeMgr.GetInstance():inTime(var1_8)
		end
	}, function()
		return false
	end)
end

return var0_0
