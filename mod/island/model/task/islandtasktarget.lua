local var0_0 = class("IslandTaskTarget", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.target_id
	arg0_1.configId = arg0_1.id
	arg0_1.progress = arg1_1.target_count or 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_task_target
end

function var0_0.GetType(arg0_3)
	return arg0_3:getConfig("type")
end

function var0_0.GetTargetParam(arg0_4)
	return arg0_4:getConfig("target_param")
end

function var0_0.GetTargetId(arg0_5)
	return arg0_5:getConfig("target_param")[1]
end

function var0_0.GetTargetNum(arg0_6)
	return arg0_6:getConfig("target_num")
end

function var0_0.GetTrackParma(arg0_7)
	return arg0_7:getConfig("tips")
end

function var0_0.GetProgress(arg0_8)
	local var0_8 = arg0_8:GetType()

	if table.contains(IslandTaskTargetType.GetRuntimeTypes(), var0_8) then
		arg0_8.progress = IslandTaskHelper.GetRuntimeData(var0_8, arg0_8:GetTargetParam())
	end

	return arg0_8.progress
end

function var0_0.UpdateProgress(arg0_9, arg1_9)
	arg0_9.progress = arg1_9
end

function var0_0.IsFinish(arg0_10)
	return arg0_10:GetProgress() / arg0_10:GetTargetNum() >= 1
end

function var0_0.CheckTypeAndTargetId(arg0_11, arg1_11, arg2_11)
	return arg0_11:GetType() == arg1_11 and arg0_11:GetTargetId() == arg2_11
end

return var0_0
