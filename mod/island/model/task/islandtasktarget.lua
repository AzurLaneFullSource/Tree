local var0_0 = class("IslandTaskTarget", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.target_id
	arg0_1.configId = arg0_1.id
	arg0_1.progress = arg1_1.target_count or 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_task_target
end

function var0_0.GetName(arg0_3)
	return arg0_3:getConfig("name")
end

function var0_0.GetType(arg0_4)
	return arg0_4:getConfig("type")
end

function var0_0.GetTargetParam(arg0_5)
	return arg0_5:getConfig("target_param")
end

function var0_0.GetTargetId(arg0_6)
	return arg0_6:getConfig("target_param")[1]
end

function var0_0.GetTargetNum(arg0_7)
	return arg0_7:getConfig("target_num")
end

function var0_0.GetTrackParma(arg0_8)
	return arg0_8:getConfig("tips")
end

function var0_0.GetProgress(arg0_9)
	local var0_9 = arg0_9:GetType()

	if var0_9 == IslandTaskTargetType.TASK_DAILY_IN_WEEK then
		return arg0_9.progress + IslandTaskHelper.GetRuntimeData(var0_9, arg0_9:GetTargetParam())
	end

	if table.contains(IslandTaskTargetType.GetRuntimeTypes(), var0_9) then
		return IslandTaskHelper.GetRuntimeData(var0_9, arg0_9:GetTargetParam())
	end

	return arg0_9.progress
end

function var0_0.UpdateProgress(arg0_10, arg1_10)
	arg0_10.progress = arg1_10
end

function var0_0.IsFinish(arg0_11)
	return arg0_11:GetProgress() / arg0_11:GetTargetNum() >= 1
end

function var0_0.CheckTypeAndTargetId(arg0_12, arg1_12, arg2_12)
	return arg0_12:GetType() == arg1_12 and arg0_12:GetTargetId() == arg2_12
end

return var0_0
